cmake_minimum_required(VERSION 3.20)
project(M5PA2)

set(CMAKE_CXX_STANDARD 26)

add_executable(M5PA2 M5PA2.cpp sqlite3.c)

# link the library for SQLite
find_package(Threads REQUIRED)
target_link_libraries(M5PA2 Threads::Threads ${CMAKE_DL_LIBS})