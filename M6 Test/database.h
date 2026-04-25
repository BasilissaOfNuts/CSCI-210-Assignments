#ifndef DATABASE_H
#define DATABASE_H

#include <string>

// Centralized function to get connection credentials
std::string getConnectionString();

// Your existing database functions
long getCountryCount();

#endif