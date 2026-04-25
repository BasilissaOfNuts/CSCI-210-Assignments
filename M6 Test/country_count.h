#include "database.h"
#include <pqxx/pqxx>
#include <iostream>

long getCountryCount() {
    try {
        // Connection string (Update with your specific credentials)
        std::string conn_str = 
            "host=amp.jtperry.net "
            "dbname=your_db "
            "user=jperry5 "
            "password='your_password' "
            "channel_binding=disable";

        pqxx::connection c(conn_str);
        pqxx::work tx{c};

        // Execute query and return the value
        long count = tx.query_value<long>("SELECT count(*) FROM public.countries;");
        
        tx.commit();
        return count;

    } catch (const std::exception &e) {
        std::cerr << "Database error: " << e.what() << std::endl;
        return -1; // Return -1 to indicate an error to main()
    }
}