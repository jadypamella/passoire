<?php                                                                                                                   // Include database connection                                                                                          include 'db_connect.php';                                                                                                                                                                                                                       // Function to hash passwords                                                                                           function hashPassword($password) {                                                                                          return sha1($password);                                                                                             }                                                                                                                                                                                                                                               // Handle form submission                                                                                               if ($_SERVER['REQUEST_METHOD'] === 'POST') {                                                                                $login = $_POST['login'];                                                                                               $email = $_POST['email'];                                                                                               $password = $_POST['password'];                                                                                         $password_confirm = $_POST['password_confirm'];                                                                                                                                                                                                 // Validate passwords                                                                                                   if ($password !== $password_confirm) {                                                                                      $error = "<p class=\"error\">Passwords do not match. Please try again.</p>";                                        }  elseif (!preg_match('/^(?=.*[\W_]).{8}$/', $password)) {                                                                            // Password must be exactly 8 characters long and include at least one special character                      $error = "<p class=\"error\">Password must be exactly 8 characters long and include at least one special character.</p>"; }                                                                                                                else {                                                                                                                      // Check if the login or email already exists                                                                                                                                                                                                   $sql = "SELECT id FROM users WHERE login = '" . $login . "' OR email = '" . $email . "'";                                                       $result = $conn->query($sql); 

                               if ($result->num_rows > 0) {                                                                        $error = "<p class=\"error\">Login or email already exists. Please choose a different one.</p>";                    } else {                                                                                                                    // Insert into the users table                                                                                                                                                                                                                  $pwhash = hashPassword($password);                                                                                                              $sql = "INSERT INTO users (login, email, pwhash) VALUES ('" . $login . "', '" . $email . "', '" . $pwhash . "')";                                                                                                                                           $conn->query($sql);                                                                                                                                                                                         // Get the newly created user ID                                                                                                                            $user_id = $conn->insert_id;                                                                                                                                                                                // Insert into the userinfos table                                                                                                                                                                                                                                      $sql = "INSERT INTO userinfos (userid, birthdate, location, bio, avatar) VALUES (" . $user_id . ", '', '', '', '')";                                                                                                                                        $conn->query($sql);                                                                                                                                                                                         $error = "<p class=\"success\">Registration successful! You can now <a href='connexion.php'>log in</a>.</p>";                                                                                                                               }                                                                                                                   }                                                                                                                   }                                                                                                                       ?>  