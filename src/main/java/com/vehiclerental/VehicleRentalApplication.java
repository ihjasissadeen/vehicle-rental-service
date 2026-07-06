package com.vehiclerental;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@SpringBootApplication
@ServletComponentScan // This magic tag tells Spring Boot to look for your @WebServlet files!
public class VehicleRentalApplication {

    public static void main(String[] args) {
        SpringApplication.run(VehicleRentalApplication.class, args);
        System.out.println("🚗 Vehicle Rental System is running on http://localhost:8080");
    }
}











