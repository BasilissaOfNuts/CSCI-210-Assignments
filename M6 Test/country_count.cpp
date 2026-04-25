#include "database.h"
#include <pqxx/pqxx>
#include <iostream>

long getCountryCount() {
    try {
        pqxx::connection c(getConnectionString());
        pqxx::work tx{c};
        long count = tx.query_value<long>("SELECT count(*) FROM public.countries;");
        tx.commit();
        return count;
    } catch (const std::exception &e) {
        std::cerr << "Database Error: " << e.what() << std::endl;
        return -1;
    }
}