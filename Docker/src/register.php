<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $servername = $_ENV['DB_SERVERNAME'] ?? 'mysql';
    $username = $_ENV['DB_USERNAME'] ?? 'appuser';
    $password = $_ENV['DB_PASSWORD'] ?? 'AppU$erP@ss!2025';
    $dbname = $_ENV['DB_DBNAME'] ?? 'azzadb_new';

    try {
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8mb4", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // ✅ أنشئ الجدول لو مش موجود (في أول مرة بس)
        $pdo->exec("
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(50) NOT NULL UNIQUE,
                password_hash VARCHAR(255) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ");

        // ✅ تحقق من تكرار اليوزرنيم (Input Validation)
        $check = $pdo->prepare("SELECT id FROM users WHERE username = ?");
        $check->execute([$_POST['username']]);
        if ($check->fetch()) {
            die("❌ Username already exists. Please choose another.");
        }

        // ✅ INSERT مع اسم العمود الصحيح
        $stmt = $pdo->prepare("INSERT INTO users (username, password_hash) VALUES (?, ?)");
        $stmt->execute([
            $_POST['username'],
            password_hash($_POST['password'], PASSWORD_DEFAULT)
        ]);

        echo "✅ Registration successful! <a href='/'>Go to Home</a>";
        exit;

    } catch(PDOException $e) {
        error_log("DB Error in register.php: " . $e->getMessage());
        echo "❌ Registration failed. Please try again.";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <meta charset="utf-8">
</head>
<body>
<h2>Register</h2>
<form method="POST">
    <input type="text" name="username" placeholder="Username" required minlength="3" maxlength="50"><br><br>
    <input type="password" name="password" placeholder="Password" required minlength="6"><br><br>
    <button type="submit">Register</button>
</form>
<br>
<a href="/">⬅️ Home</a>
</body>
</html>
