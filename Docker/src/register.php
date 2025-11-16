 <?php
// register.php

// 1. التحقق من طريقة الطلب
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    die("Method Not Allowed");
}

// 2. أخذ المدخلات وتنظيفها
$username = trim($_POST['username'] ?? '');
$password = $_POST['password'] ?? '';

// 3. التحقق من المدخلات
if (empty($username) || empty($password)) {
    die("<h3 style='color:red'>Error: Username and password are required.</h3>");
}

if (strlen($username) < 3) {
    die("<h3 style='color:red'>Error: Username must be at least 3 characters.</h3>");
}

if (strlen($password) < 6) {
    die("<h3 style='color:red'>Error: Password must be at least 6 characters.</h3>");
}

// 4. إعداد اعتماد قاعدة البيانات من المتغيرات البيئية (زي ما عرفتها في الـDeployment)
$host = getenv('DB_SERVERNAME') ?: 'mysql';
$dbname = getenv('DB_DBNAME') ?: 'azzadb';
$dbuser = getenv('DB_USERNAME') ?: 'root';
$dbpass = getenv('DB_PASSWORD') ?: 'root';

try {
    // 5. الاتصال بقاعدة البيانات باستخدام PDO (آمن ضد SQL Injection)
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $dbuser, $dbpass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);

    // 6. التحقق من تكرار الـusername
    $stmt = $pdo->prepare("SELECT id FROM users WHERE username = ?");
    $stmt->execute([$username]);
    if ($stmt->fetch()) {
        die("<h3 style='color:orange'>Error: Username already exists. Please choose another.</h3>");
    }

    // 7. تشفير الباسورد (استخدام password_hash — الأفضل أمانًا)
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // 8. إدخال المستخدم الجديد
    $stmt = $pdo->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    $stmt->execute([$username, $hashedPassword]);

    // 9. رسالة نجاح
    echo "<h3 style='color:green'>✅ Registration successful!</h3>";
    echo "<p>Welcome, <strong>" . htmlspecialchars($username) . "</strong>!</p>";
    echo "<p><a href='/login.html'>Go to Login</a></p>";

} catch (PDOException $e) {
    if ($e->getCode() == 23000) { // 23000 = Duplicate entry
        die("<h3 style='color:orange'>Error: Username already exists. Please choose another.</h3>");
    } else {
        error_log("DB Error in register.php: " . $e->getMessage());
        die("<h3 style='color:red'>❌ Registration failed. Please try again later.</h3>");
    }
}

?>
 