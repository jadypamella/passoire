<?php
// Include database connection
include 'db_connect.php';

// Function to hash passwords
function hashPassword($password) {
    return sha1($password);
}

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $login = $_POST['login'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $password_confirm = $_POST['password_confirm'];

    // Validate passwords
    if ($password !== $password_confirm) {
        $error = "Passwords do not match. Please try again.";
    } elseif (!preg_match('/^(?=.*[\W_])(?=.*\d)(?=.*[A-Z]).{8,}$/', $password)) {
        // Password must be at least 8 characters long and include at least one special character, one digit, and one uppercase letter
        $error = "Password must be at least 8 characters long and include at least one special character, one digit, and one uppercase letter.";
    } else {
        // Check if the login or email already exists using prepared statements
        $stmt = $conn->prepare("SELECT id FROM users WHERE login = ? OR email = ?");
        $stmt->bind_param("ss", $login, $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $error = "Login or email already exists. Please choose a different one.";
        } else {
            // Insert into the users table
            $pwhash = hashPassword($password);
            $stmt = $conn->prepare("INSERT INTO users (login, email, pwhash) VALUES (?, ?, ?)");
            $stmt->bind_param("sss", $login, $email, $pwhash);
            $stmt->execute();

            // Get the newly created user ID
            $user_id = $stmt->insert_id;

            // Insert into the userinfos table
            $stmt = $conn->prepare("INSERT INTO userinfos (userid, birthdate, location, bio, avatar) VALUES (?, '', '', '', '')");
            $stmt->bind_param("i", $user_id);
            $stmt->execute();

            $error = "Registration successful! You can now log in.";
        }
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Passoire: A simple file hosting server</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./style/w3.css">
    <link rel="stylesheet" href="./style/w3-theme-blue-grey.css">
    <link rel="stylesheet" href="./style/css/fontawesome.css">
    <link href="./style/css/brands.css" rel="stylesheet" />
    <link href="./style/css/solid.css" rel="stylesheet" />
    <style>
        html, body, h1, h2, h3, h4, h5 {font-family: "Open Sans", sans-serif}
        .center-c {
            margin-bottom: 25px;
            padding-bottom: 25px;
        }
        
        form {
            width: 100%;
            max-width: 400px;
            margin: 0 auto;
        }
        label {
            display: block;
            margin-bottom: 10px;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body class="w3-theme-l5">
<?php include 'navbar.php'; ?>

<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">

    <!-- The Grid -->
    <div class="w3-row">
        <div class="w3-col m12">

        <div class="w3-card w3-round">
            <div class="w3-container w3-center center-c">
                    <h2>Sign Up</h2>
                
                <?php if (isset($error)): ?>
                  <p class="error"><?php echo htmlspecialchars($error); ?></p>
              <?php endif; ?>

                <form method="POST" action="signup.php">
                    <!-- Login -->
                    <label for="login">Login:</label>
                    <input type="text" id="login" name="login" required>

                    <!-- Email -->
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>

                    <!-- Password -->
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>

                    <!-- Confirm Password -->
                    <label for="password_confirm">Confirm Password:</label>
                    <input type="password" id="password_confirm" name="password_confirm" required>

                    <!-- Submit Button -->
                    <button type="submit" class="w3-button w3-theme w3-margin">Sign Up</button>
                </form>
            </div>
            </div>
            </div>
            </div>
            </div>
</body>
</html>
