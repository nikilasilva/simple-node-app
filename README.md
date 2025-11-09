# 🧑‍💻 Node.js & MySQL User App

A simple full-stack web application built with **Node.js** and **Express** that connects to a **MySQL** database.  
Users can view a list of users from the database and add new users through a web form.

---

## ⚙️ Getting Started

Follow these steps to get a copy of the project up and running on your local machine.

---

### 1️⃣ Prerequisites

Make sure you have the following installed:

- [Node.js](https://nodejs.org/) and npm  
- [MySQL](https://www.mysql.com/) server

---

### 2️⃣ Project Setup

Clone the repository (or create your own project folder):

```bash
git clone https://github.com/nikilasilva/simple-node-app.git
cd simple-node-app


Install dependencies:

```bash
npm install
```

---

### 3️⃣ Database Setup

Log into MySQL with a user that has permission to create databases (like `root`).

Run the provided SQL script to create the database (`terraform_demo`) and the `users` table:

```bash
mysql -u root -p < create_db.sql
```

> 💡 This will prompt you for your MySQL root password.

(Optional) — Add some initial test data:

```sql
USE terraform_demo;

INSERT INTO users (name, email, phone)
VALUES ('John Doe', 'john@example.com', '77-676-7676');

INSERT INTO users (name, email, phone)
VALUES ('Jane Smith', 'jane@example.com', '77-878-7878');
```

---

### 4️⃣ Environment Variables

Create a file named `.env` in the root of your project and add the following:

```env
DB_HOST="localhost"
DB_USER="root"
DB_PASS="YOUR_MYSQL_PASSWORD"
DB_NAME="terraform_demo"
TABLE_NAME="users"
PORT=3000
```

> 🔒 Replace `YOUR_MYSQL_PASSWORD` with your actual MySQL password.

---

### 5️⃣ Running the Application

**For Development (with automatic restart):**

```bash
npm run dev
```

**For Production:**

```bash
npm start
```

Then open your browser and go to:

👉 [http://localhost:3000](http://localhost:3000)

---
