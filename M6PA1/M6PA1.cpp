/*
 * Program name: M6PA1.cpp
 * Author: Stella Song
 * Date last updated: 4/24/2026
 * Purpose: A menu-driven system for the Sakila database using prepared statements updated for Module 6
*/

#include "sqlite3.h"
#include <iostream>
#include <string>
#include <iomanip>

using namespace std;

// Function Prototypes
void viewRental(sqlite3*);
void viewCustomer(sqlite3*);
void enterRental(sqlite3*);
int selectFilm(sqlite3*);
int selectStaff(sqlite3*);
int selectCustomer(sqlite3*, const string& prompt);
int getValidatedInt(const string& prompt, int min, int max, bool allowQuit = false);

int main() {
    sqlite3* mydb;
    if (sqlite3_open("sakila.db", &mydb) != SQLITE_OK) {
        cerr << "Error in connection" << endl;
        return 1;
    }

    int choice = 0;
    while (choice != -1) {
        cout << "\nPlease choose an option (enter -1 to quit):" << endl;
        cout << "1. View the rentals for a customer" << endl;
        cout << "2. View Customer Information" << endl;
        cout << "3. Enter a Rental" << endl; // New Option
        cout << "Enter Choice: ";

        choice = getValidatedInt("", -1, 3, true);

        if (choice == 1) viewRental(mydb);
        else if (choice == 2) viewCustomer(mydb);
        else if (choice == 3) enterRental(mydb);
    }

    sqlite3_close(mydb);
    return 0;
}

int getValidatedInt(const string& prompt, const int min, const int max, const bool allowQuit) {
    int val;
    if (!prompt.empty()) cout << prompt;
    while (!(cin >> val) || (val < min && !(allowQuit && val == -1)) || val > max) {
        if (cin.fail()) {
            cin.clear();
            cin.ignore(1000, '\n');
        }

        cout << "Invalid entry. Please enter a valid value: ";
    }
    return val;
}

void enterRental(sqlite3* mydb) {
    const int customerId = selectCustomer(mydb, "for the rental");
    const int filmId = selectFilm(mydb);
    const int staffId = selectStaff(mydb);

    sqlite3_stmt* stmt;

    // Get an available inventory_id for the film
    sqlite3_prepare_v2(mydb, "SELECT inventory_id FROM inventory WHERE film_id = ? LIMIT 1;", -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, filmId);
    sqlite3_step(stmt);
    const int inventoryId = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);

    // Get rental_rate
    sqlite3_prepare_v2(mydb, "SELECT rental_rate FROM film WHERE film_id = ?;", -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, filmId);
    sqlite3_step(stmt);
    const double amount = sqlite3_column_double(stmt, 0);
    sqlite3_finalize(stmt);

    // Start Transaction
    sqlite3_exec(mydb, "BEGIN TRANSACTION;", nullptr, nullptr, nullptr);

    // Insert Rental
    const auto rentSql = "INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id) VALUES (DATETIME('now'), ?, ?, ?);";
    sqlite3_prepare_v2(mydb, rentSql, -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, inventoryId);
    sqlite3_bind_int(stmt, 2, customerId);
    sqlite3_bind_int(stmt, 3, staffId);
    sqlite3_step(stmt);
    const long long rentalId = sqlite3_last_insert_rowid(mydb);
    sqlite3_finalize(stmt);

    // Insert Payment
    const auto* paySql = "INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date) VALUES (?, ?, ?, ?, DATETIME('now'));";
    sqlite3_prepare_v2(mydb, paySql, -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, customerId);
    sqlite3_bind_int(stmt, 2, staffId);
    sqlite3_bind_int64(stmt, 3, rentalId);
    sqlite3_bind_double(stmt, 4, amount);
    sqlite3_step(stmt);
    const long long paymentId = sqlite3_last_insert_rowid(mydb);
    sqlite3_finalize(stmt);

    // Commit Transaction
    sqlite3_exec(mydb, "COMMIT;", nullptr, nullptr, nullptr);

    cout << "\nRental and Payment entered successfully." << endl;
    cout << "Rental Id: " << rentalId << " Payment Id: " << paymentId << endl;
}

int selectFilm(sqlite3* mydb) {
    sqlite3_stmt* stmt;
    int totalFilms = 0;
    sqlite3_prepare_v2(mydb, "SELECT count(*) FROM film;", -1, &stmt, nullptr);
    sqlite3_step(stmt);
    totalFilms = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);

    cout << "\nThere are " << totalFilms << " films. How many per page? ";
    const int rowsPerPage = getValidatedInt("", 1, totalFilms);

    const auto* sql = "SELECT film_id, title FROM film ORDER BY title;";
    sqlite3_prepare_v2(mydb, sql, -1, &stmt, nullptr);

    int startNum = 0;
    while (true) {
        cout << "Please choose the film you want to rent (enter 0 for next page):" << endl;
        for (int i = 1; i <= rowsPerPage; i++) {
            if (sqlite3_step(stmt) != SQLITE_ROW) break;
            cout << i + startNum << ". " << sqlite3_column_int(stmt, 0) << " - " << sqlite3_column_text(stmt, 1) << endl;
        }

        if (const int choice = getValidatedInt("", 0, totalFilms); choice == 0) {
            startNum = (startNum + rowsPerPage >= totalFilms) ? 0 : startNum + rowsPerPage;
            sqlite3_reset(stmt);
            for (int i = 0; i < startNum; i++) sqlite3_step(stmt);
        } else {
            sqlite3_reset(stmt);
            for (int i = 0; i < choice - 1; i++) sqlite3_step(stmt);
            const int id = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
            return id;
        }
    }
}

int selectStaff(sqlite3* mydb) {
    sqlite3_stmt* stmt;
    const auto sql = "SELECT staff_id, first_name, last_name FROM staff;";
    sqlite3_prepare_v2(mydb, sql, -1, &stmt, nullptr);

    cout << "\nPlease choose the staff member logging the transaction:" << endl;
    int i = 1;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        cout << i++ << ". " << sqlite3_column_int(stmt, 0) << " - "
             << sqlite3_column_text(stmt, 1) << " " << sqlite3_column_text(stmt, 2) << endl;
    }

    const int choice = getValidatedInt("Enter choice: ", 1, i - 1);

    sqlite3_reset(stmt);

    for (int j = 0; j < choice - 1; j++) sqlite3_step(stmt);
    const int id = sqlite3_column_int(stmt, 0);

    sqlite3_finalize(stmt);
    return id;
}

int selectCustomer(sqlite3* mydb, const string& prompt) {
    sqlite3_stmt* stmt;
    int totalRows = 0;

    sqlite3_prepare_v2(mydb, "SELECT count(*) FROM customer;", -1, &stmt, nullptr);
    sqlite3_step(stmt);
    totalRows = sqlite3_column_int(stmt, 0);

    sqlite3_finalize(stmt);

    cout << "\nThere are " << totalRows << " rows in the result.  How many do you want to see per page?" << endl;
    const int rowsPerPage = getValidatedInt("", 1, totalRows);

    const auto* sql = "SELECT customer_id, first_name, last_name FROM customer ORDER BY customer_id;";
    sqlite3_prepare_v2(mydb, sql, -1, &stmt, nullptr);

    int startNum = 0;
    while (true) {
        cout << "Please choose the customer " << prompt << " (enter 0 to go to the next page";
        if (startNum > 0) cout << " or -1 to go to the previous page";
        cout << "):" << endl;

        for (int i = 1; i <= rowsPerPage; i++) {
            if (sqlite3_step(stmt) != SQLITE_ROW) break;
            cout << i + startNum << ". " << sqlite3_column_int(stmt, 0) << " - "
                 << sqlite3_column_text(stmt, 1) << " " << sqlite3_column_text(stmt, 2) << endl;
        }

        if (const int choice = getValidatedInt("", -1, totalRows); choice == 0) {
            startNum = (startNum + rowsPerPage >= totalRows) ? 0 : startNum + rowsPerPage;
            sqlite3_reset(stmt);
            for (int i = 0; i < startNum; i++) sqlite3_step(stmt);
        }
        else if (choice == -1 && startNum > 0) {
            startNum -= rowsPerPage;
            sqlite3_reset(stmt);
            for (int i = 0; i < startNum; i++) sqlite3_step(stmt);
        }
        else if (choice > 0) {
            sqlite3_finalize(stmt);
            return choice;
        }
    }
}

void viewCustomer(sqlite3* mydb) {
    const int customerId = selectCustomer(mydb, "you want to see");

    sqlite3_stmt* stmt;
    const auto* sql = "SELECT c.first_name, c.last_name, a.address, ct.city, a.postal_code, a.phone, c.email, c.active, c.last_update "
                      "FROM customer c "
                      "JOIN address a ON c.address_id = a.address_id "
                      "JOIN city ct ON a.city_id = ct.city_id "
                      "WHERE c.customer_id = ?;";

    sqlite3_prepare_v2(mydb, sql, -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, customerId);

    if (sqlite3_step(stmt) == SQLITE_ROW) {
        cout << "\n----Customer Information----" << endl;
        cout << "Name: " << sqlite3_column_text(stmt, 0) << " " << sqlite3_column_text(stmt, 1) << endl;
        cout << "Address: " << sqlite3_column_text(stmt, 2) << endl;
        cout << sqlite3_column_text(stmt, 3) << ", " << sqlite3_column_text(stmt, 3) << " " << sqlite3_column_text(stmt, 4) << endl;
        cout << "Phone Number: " << sqlite3_column_text(stmt, 5) << endl;
        cout << "Email: " << sqlite3_column_text(stmt, 6) << endl;
        cout << "Last Update: " << sqlite3_column_text(stmt, 8) << endl;
    }

    sqlite3_finalize(stmt);
}

void viewRental(sqlite3* mydb) {
    const int customerId = selectCustomer(mydb, "you want to see rentals for");

    sqlite3_stmt* stmt;
    sqlite3_prepare_v2(mydb, "SELECT count(*) FROM rental WHERE customer_id = ?;", -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, customerId);
    sqlite3_step(stmt);
    const int totalRentals = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);

    cout << "\nThere are " << totalRentals << " rows in the result.  How many do you want to see per page?" << endl;
    const int rowsPerPage = getValidatedInt("", 1, totalRentals);

    const auto* listSql = "SELECT rental_id, rental_date FROM rental WHERE customer_id = ? ORDER BY rental_date ASC;";
    sqlite3_prepare_v2(mydb, listSql, -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, customerId);

    int startNum = 0;
    int rentalId = -1;
    while (rentalId == -1) {
        cout << "Please choose the rental you want to see (enter 0 to go to the next page):" << endl;

        for (int i = 1; i <= rowsPerPage; i++) {
            if (sqlite3_step(stmt) != SQLITE_ROW) break;
            cout << i + startNum << ". " << sqlite3_column_int(stmt, 0) << " - " << sqlite3_column_text(stmt, 1) << endl;
        }

        if (const int choice = getValidatedInt("", 0, 1000000); choice == 0) {
            startNum = (startNum + rowsPerPage >= totalRentals) ? 0 : startNum + rowsPerPage;
            sqlite3_reset(stmt);
            sqlite3_bind_int(stmt, 1, customerId);
            for (int i = 0; i < startNum; i++) sqlite3_step(stmt);
        } else {
            // Find the ID of the rental selected from the numbered menu list
            sqlite3_reset(stmt);
            sqlite3_bind_int(stmt, 1, customerId);
            for (int i = 0; i < choice; i++) sqlite3_step(stmt);
            rentalId = sqlite3_column_int(stmt, 0);
        }
    }

    sqlite3_finalize(stmt);

    const auto* finalSql = "SELECT r.rental_date, s.first_name || ' ' || s.last_name, c.first_name || ' ' || c.last_name, "
                           "f.title, f.description, f.rental_rate, r.return_date "
                           "FROM rental r "
                           "JOIN staff s ON r.staff_id = s.staff_id "
                           "JOIN customer c ON r.customer_id = c.customer_id "
                           "JOIN inventory i ON r.inventory_id = i.inventory_id "
                           "JOIN film f ON i.film_id = f.film_id "
                           "WHERE r.rental_id = ?;";

    sqlite3_prepare_v2(mydb, finalSql, -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, rentalId);

    if (sqlite3_step(stmt) == SQLITE_ROW) {
        cout << "\nRental Date: " << sqlite3_column_text(stmt, 0) << endl;
        cout << "Staff: " << sqlite3_column_text(stmt, 1) << endl;
        cout << "Customer: " << sqlite3_column_text(stmt, 2) << endl;
        cout << "Film Information:" << endl;
        cout << sqlite3_column_text(stmt, 3) << " - " << sqlite3_column_text(stmt, 4) << " $" << sqlite3_column_text(stmt, 5) << endl;
        const unsigned char* ret = sqlite3_column_text(stmt, 6);
        cout << "Return Date: " << (ret ? reinterpret_cast<const char *>(ret) : "Not Returned") << endl;
    }

    sqlite3_finalize(stmt);
}