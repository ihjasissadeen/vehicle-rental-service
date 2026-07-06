package com.vehiclerental.service;

import com.vehiclerental.model.Booking;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class BookingServiceTest {

    private BookingService bookingService;

    @TempDir
    Path tempDir;

    @BeforeEach
    void setUp() {
        // Package-private constructor points the service at an isolated temp file instead of the real data/ dir
        bookingService = new BookingService(tempDir.resolve("bookings.txt").toString());
    }

    @Test
    void addBooking_assignsSequentialIds() throws IOException {
        bookingService.addBooking(new Booking(0, 1, 10, "2026-01-01", "2026-01-05", "pending"));
        bookingService.addBooking(new Booking(0, 2, 11, "2026-02-01", "2026-02-05", "pending"));

        List<Booking> all = bookingService.getAllBookings();
        assertEquals(2, all.size());
        assertEquals(1, all.get(0).getId());
        assertEquals(2, all.get(1).getId());
    }

    @Test
    void isVehicleAvailable_returnsFalseWhenDateRangesOverlap() throws IOException {
        bookingService.addBooking(new Booking(0, 1, 10, "2026-01-10", "2026-01-20", "active"));

        assertFalse(bookingService.isVehicleAvailable(10, "2026-01-15", "2026-01-25"));
        assertTrue(bookingService.isVehicleAvailable(10, "2026-01-21", "2026-01-25"));
        assertTrue(bookingService.isVehicleAvailable(99, "2026-01-15", "2026-01-25"));
    }

    @Test
    void deleteBooking_removesOnlyTheMatchingRecord() throws IOException {
        bookingService.addBooking(new Booking(0, 1, 10, "2026-01-01", "2026-01-05", "pending"));
        bookingService.addBooking(new Booking(0, 2, 11, "2026-02-01", "2026-02-05", "pending"));

        bookingService.deleteBooking(1);

        List<Booking> remaining = bookingService.getAllBookings();
        assertEquals(1, remaining.size());
        assertEquals(2, remaining.get(0).getId());
    }
}
