/* Program name: M5PA1.cpp
* Author: Stella Song
* Date last updated: 4/17/2026
* Purpose: Connect to the Chinook database and display a grouped list of albums, artists, and their respective tracks using SQLite3 callbacks.
*/

#include <iostream>
#include <string>
#include "sqlite3.h"

// Callback function to handle and print results of SQL query
int callback(void* data, int argc, char** argv, char** azColName) {

    // argv[0] = AlbumId, argv[1] = Title, argv[2] = Artist Name, argv[3] = Track Name

    if (auto* lastAlbumId = static_cast<std::string*>(data); *lastAlbumId != argv[0]) {
        if (!lastAlbumId->empty()) std::cout << std::endl; // Add space between albums

        std::cout << "AlbumId: " << (argv[0] ? argv[0] : "NULL") << std::endl;
        std::cout << "Album Name: " << (argv[1] ? argv[1] : "NULL") << std::endl;
        std::cout << "Artist Name: " << (argv[2] ? argv[2] : "NULL") << std::endl;
        std::cout << "Tracks:" << std::endl;

        // Update the state to the current AlbumId
        *lastAlbumId = argv[0];
    }

    // Print the track name
    std::cout << (argv[3] ? argv[3] : "NULL") << std::endl;

    return 0;
}

int main() {
    sqlite3* db;
    char* zErrMsg = nullptr;

    // Open connection to the database
    int rc = sqlite3_open("chinook.db", &db);

    if (rc) {
        std::cerr << "Error in connection: unable to open database file" << std::endl;
        return 1;
    }

    std::cout << "Database opened successfully" << std::endl;

    // SQL statement with plural table names, whoever did this is stupid.
    const auto sql = "SELECT al.AlbumId, al.Title, ar.Name, t.Name "
                      "FROM albums al "
                      "JOIN artists ar ON al.ArtistId = ar.ArtistId "
                      "JOIN tracks t ON al.AlbumId = t.AlbumId "
                      "ORDER BY al.AlbumId;";

    // Maintain state between callback calls
    std::string currentId;
    rc = sqlite3_exec(db, sql, callback, &currentId, &zErrMsg);

    if (rc != SQLITE_OK) {
        std::cerr << "SQL error: " << zErrMsg << std::endl;
        sqlite3_free(zErrMsg);
    }

    // Close the database connection
    sqlite3_close(db);

    return 0;
}