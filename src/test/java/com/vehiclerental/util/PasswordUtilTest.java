package com.vehiclerental.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PasswordUtilTest {

    @Test
    void hash_producesADifferentValueThanThePlaintext() {
        String hash = PasswordUtil.hash("mySecret123");
        assertNotEquals("mySecret123", hash);
        assertTrue(PasswordUtil.isHashed(hash));
    }

    @Test
    void verify_acceptsCorrectPasswordAndRejectsWrongOne() {
        String hash = PasswordUtil.hash("mySecret123");
        assertTrue(PasswordUtil.verify("mySecret123", hash));
        assertFalse(PasswordUtil.verify("wrongPassword", hash));
    }

    @Test
    void verify_stillWorksAgainstLegacyPlaintextValues() {
        assertTrue(PasswordUtil.verify("oldPlainPassword", "oldPlainPassword"));
        assertFalse(PasswordUtil.verify("wrong", "oldPlainPassword"));
    }

    @Test
    void hash_producesUniqueSaltsForTheSamePassword() {
        String hash1 = PasswordUtil.hash("samePassword");
        String hash2 = PasswordUtil.hash("samePassword");
        assertNotEquals(hash1, hash2, "each hash should use a fresh random salt");
    }
}
