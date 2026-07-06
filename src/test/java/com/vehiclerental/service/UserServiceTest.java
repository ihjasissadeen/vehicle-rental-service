package com.vehiclerental.service;

import com.vehiclerental.model.User;
import com.vehiclerental.util.PasswordUtil;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class UserServiceTest {

    private final UserService userService = new UserService();

    @TempDir
    Path tempDir;

    private String usersFile() {
        return tempDir.resolve("users.txt").toString();
    }

    @Test
    void addUser_neverStoresPlaintextPassword() {
        User user = User.createUser(0, "Nimal", "nimal@test.com", "mypassword", "customer");
        userService.addUser(user, usersFile());

        User saved = userService.getUserById(user.getId(), usersFile());
        assertNotEquals("mypassword", saved.getPassword());
        assertTrue(PasswordUtil.isHashed(saved.getPassword()));
    }

    @Test
    void validateUser_succeedsWithCorrectPasswordAndFailsWithWrongOne() {
        User user = User.createUser(0, "Kasun", "kasun@test.com", "correctPass1", "customer");
        userService.addUser(user, usersFile());

        assertNotNull(userService.validateUser("kasun@test.com", "correctPass1", usersFile()));
        assertNull(userService.validateUser("kasun@test.com", "wrongPass", usersFile()));
    }

    @Test
    void validateUser_migratesLegacyPlaintextPasswordOnSuccessfulLogin() throws IOException {
        // Simulate an old-style plaintext row written before hashing was introduced
        Files.writeString(tempDir.resolve("users.txt"), "1,Legacy,legacy@test.com,plainOldPass,customer\n");

        User result = userService.validateUser("legacy@test.com", "plainOldPass", usersFile());
        assertNotNull(result);

        List<User> all = userService.getUsers(usersFile());
        assertTrue(PasswordUtil.isHashed(all.get(0).getPassword()), "password should be hashed after migration");
    }

    @Test
    void addUser_assignsSequentialIds() {
        userService.addUser(User.createUser(0, "A", "a@test.com", "pass1", "customer"), usersFile());
        userService.addUser(User.createUser(0, "B", "b@test.com", "pass2", "customer"), usersFile());

        List<User> all = userService.getUsers(usersFile());
        assertEquals(2, all.size());
        assertEquals(1, all.get(0).getId());
        assertEquals(2, all.get(1).getId());
    }
}
