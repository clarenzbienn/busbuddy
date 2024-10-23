<?php
header('Content-Type: application/json');

// Database configuration
$host = 'localhost';
$db_name = 'flutter_auth';
$username = 'root';
$password = '';

try {
    // Create a new PDO instance
    $pdo = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Get the request body
    $data = json_decode(file_get_contents("php://input"));

    // Check if any of the selected seats are already reserved
    $placeholders = str_repeat('?,', count($data->seats) - 1) . '?';
    $stmt = $pdo->prepare("SELECT seat FROM reserved_seats WHERE bus_number = ? AND departure = ? AND seat IN ($placeholders)");
    $stmt->execute(array_merge([$data->busNumber, $data->departure], $data->seats));

    $reservedSeats = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    if (!empty($reservedSeats)) {
        echo json_encode([
            'error' => 'Some seats are already reserved',
            'reserved_seats' => $reservedSeats
        ]);
        exit;
    }

    // Reserve the seats
    $pdo->beginTransaction();

    foreach ($data->seats as $seat) {
        $stmt = $pdo->prepare("INSERT INTO reserved_seats (bus_number, departure, seat, user_id, terminal, destination, base_fare, service_class) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$data->busNumber, $data->departure, $seat, $data->userId, $data->terminal, $data->destination, $data->totalFare, $data->serviceClass]);
    }

    $pdo->commit();

    echo json_encode(['message' => 'Reservation successful']);
} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    echo json_encode(['error' => $e->getMessage()]);
}
?>
