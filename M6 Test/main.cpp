#include <iostream>
#include "database.h"

int main() {
    int choice = 0;

    while (true) {
        std::cout << "\n--- Ivy Tech CSCI 210 Database Menu ---" << std::endl;
        std::cout << "1. Get Country Count" << std::endl;
        std::cout << "2. Exit" << std::endl;
        std::cout << "Enter choice: ";
        std::cin >> choice;

        if (choice == 1) {
            long count = getCountryCount();
            if (count != -1) {
                std::cout << "\n>>> Total Countries: " << count << std::endl;
            }
        }
        else if (choice == 2) {
            std::cout << "Exiting program..." << std::endl;
            break;
        }
        else {
            std::cout << "Invalid choice. Try again." << std::endl;
        }
    }

    return 0;
}