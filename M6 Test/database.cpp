#include "database.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <algorithm>

/**
 * Internal Helper: loadEnv
 * Safely reads key-value pairs from a .env file.
 * Handles Windows (CRLF) and Linux (LF) line endings.
 */
static std::map<std::string, std::string> loadEnv(const std::string& filename) {
    std::map<std::string, std::string> env;
    std::ifstream file(filename);

    if (!file.is_open()) {
        std::cerr << "[Warning] Could not open " << filename << ". Ensure it is in the working directory." << std::endl;
        return env;
    }

    std::string line;
    while (std::getline(file, line)) {
        // 1. Remove Windows carriage return (\r) if present
        if (!line.empty() && line.back() == '\r') {
            line.pop_back();
        }

        // 2. Skip empty lines or comments
        if (line.empty() || line[0] == '#') continue;

        // 3. Find the delimiter
        size_t delimiterPos = line.find('=');
        if (delimiterPos != std::string::npos) {
            std::string key = line.substr(0, delimiterPos);
            std::string value = line.substr(delimiterPos + 1);

            // 4. Robustly trim whitespace around the value
            value.erase(0, value.find_first_not_of(" \t"));
            value.erase(value.find_last_not_of(" \t") + 1);

            env[key] = value;
        }
    }
    return env;
}

/**
 * getConnectionString
 * Centralized logic for the database connection string.
 * Uses static caching and OS-specific flags.
 */
std::string getConnectionString() {
    static std::string connection_string = "";

    // Load from .env only on the first call
    if (connection_string.empty()) {
        auto env = loadEnv(".env");

        // Validation check
        if (env.find("DB_HOST") == env.end() || env.find("DB_PASS") == env.end()) {
            std::cerr << "[Error] Critical database configuration missing in .env!" << std::endl;
            return "";
        }

        // Build the base connection string
        // Note: single quotes around password handle special characters
        std::string base = "host=" + env["DB_HOST"] +
                          " dbname=" + env["DB_NAME"] +
                          " user=" + env["DB_USER"] +
                          " password='" + env["DB_PASS"] + "' " +
                          "port=5432 ";

        // Append OS-specific parameters for platform parity
        #ifdef _WIN32
            // Windows: Prioritize SCRAM-SHA-256 stability
            base += "sslmode=prefer channel_binding=disable";
        #elif __linux__
            // Linux (Fedora): Ensure modern libpq doesn't fail on handshake
            base += "channel_binding=disable";
        #elif __APPLE__
            // macOS: Homebrew-based libpq often expects SSL for remote hosts
            base += "sslmode=require";
        #endif

        connection_string = base;
    }

    return connection_string;
}