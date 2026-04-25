cmake_minimum_required(VERSION 3.20)
project(M6_Test)

set(CMAKE_PREFIX_PATH "C:/msys64/ucrt64")

# Look for the C++ wrapper
find_package(libpqxx REQUIRED)

add_executable(M6_Test
        main.cpp
        database.cpp
        country_count.cpp
)

# Link both
target_link_libraries(M6_Test PRIVATE libpqxx::pqxx)

# Automatically copy .env to the folder where the .exe lives
configure_file(.env .env COPYONLY)