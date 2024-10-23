<?php
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $fullname = $_POST['fullname'];
    $email = $_POST['email'];
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT); 

    // Check if user already exists
    $check_user_query = "SELECT * FROM users WHERE email='$email' OR username='$username'";
    $result = $conn->query($check_user_query);

    if ($result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "User already exists"]);
    } else {
        $insert_query = "INSERT INTO users (username, fullname, email, password) VALUES ('$username', '$fullname', '$email', '$password')";
        if ($conn->query($insert_query) === TRUE) {
            $user_id = $conn->insert_id; 
            $insert_login_details = "INSERT INTO login_details (user_id) VALUES ('$user_id')";
            $conn->query($insert_login_details);
            echo json_encode(["status" => "success", "message" => "User registered successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to register user"]);
        }
    }
}
?>
