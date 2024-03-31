<?php
        echo "hi";
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $username = $_POST["username"];
            $password = $_POST["password"];

            $validUser = "user";
            $validPassword = "password123";
            if ($username === $validUser && $password == $validPassword) {
                echo "Welcome, $username!";
            } else {
                echo "Invalid username or password. Please try again.";
            }
        }
        ?>