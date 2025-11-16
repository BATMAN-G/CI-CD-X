# 🐳 WebApp with Docker & MySQL — Simple User Registration System

> A lightweight, containerized web application built with PHP and MySQL, featuring secure user registration using PDO and password hashing.

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Apache](https://img.shields.io/badge/Apache-2A624B?style=for-the-badge&logo=apache&logoColor=white)

---

## 🚀 Features

✅ Secure user registration with input validation  
✅ Password hashing using `password_hash()`  
✅ Database initialization via SQL script (`init.sql`)  
✅ Containerized with Docker Compose for easy deployment  
✅ Clean separation of concerns: `database/` & `src/` directories

---

## 📁 Project Structure
DEPI-Project/
├── docker-compose.yml # Define services (db + webapp)
├── database/ # MySQL service
│ ├── Dockerfile # Build MySQL image
│ └── init.sql # Initialize database schema
├── src/ # PHP web application
│ ├── Dockerfile # Build PHP-Apache image
│ ├── index.php # Welcome page
│ ├── register.html # Registration form
│ └── register.php # Handle registration logic
└── README.md # You are here!


---

## 🛠️ How to Run

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/DEPI-Project.git
   cd DEPI-Project

Start the services:
docker-compose up --build

Access the app:
Open your browser at: http://localhost:8080 
To stop the services:
bash

docker-compose down

🔐 Security Notes
Uses PDO with prepared statements to prevent SQL injection.
Passwords are hashed using password_hash() before storage.
Input validation on username (min 3 chars) and password (min 6 chars).
Environment variables used for DB credentials (configurable in docker-compose.yml).
💡 Sample Usage
Visit http://localhost:8080 → You’ll see a welcome message.
Click “Go to Register” → Fill the form.
Submit → If successful, you’ll see a green success message.
Try registering same username again → You’ll get an error.
🧩 Future Improvements
Add login functionality
Implement sessions or JWT for authentication
Add email verification
Add admin panel to view users
Add unit tests for PHP logic
🤝 Contributing
Feel free to fork this repo, make improvements, and submit a pull request!

�� License
This project is licensed under the MIT License — see the LICENSE file for details.
