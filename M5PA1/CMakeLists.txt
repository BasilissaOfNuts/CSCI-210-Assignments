cmake_minimum_required(VERSION 3.20)
project(M5PA1)

set(CMAKE_CXX_STANDARD 26)

add_executable(M5PA1 M5PA1.cpp sqlite3.c)

# link the library for SQLite
find_package(Threads REQUIRED)
target_link_libraries(M5PA1 Threads::Threads ${CMAKE_DL_LIBS})