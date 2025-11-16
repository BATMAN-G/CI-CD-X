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

