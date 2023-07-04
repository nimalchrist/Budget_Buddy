# Budget Buddy Documentation

Welcome to the documentation for Budget Buddy, a budget management app developed with Flutter for the front end, Node.js for the back end, and MySQL for the database. This app helps users track their income, expenses, and balance effectively.

## Installation and Setup

Before running Budget Buddy, you need to set up Flutter, Node.js, and MySQL on your machine.

### Flutter

To install Flutter:

1. Visit the [Flutter website](https://flutter.dev/) and download the Flutter SDK for your operating system.

2. Extract the downloaded SDK archive to a location of your choice.

3. Add the Flutter `bin` directory to your system's `PATH` variable.

   Example (for macOS/Linux):
   ```
   export PATH="$PATH:/path/to/flutter/bin"
   ```

4. Run `flutter doctor` in your terminal to verify the installation and check for any additional dependencies.

### Node.js

To install Node.js:

1. Visit the [Node.js website](https://nodejs.org/) and download the LTS (Long Term Support) version for your operating system.

2. Run the installer and follow the instructions.

3. After installation, run `node -v` and `npm -v` in your terminal to verify the installation.

### MySQL

To install MySQL:

1. Visit the [MySQL website](https://www.mysql.com/) and download the appropriate version for your operating system.

2. Run the installer and follow the instructions.

3. Set up a MySQL user and password for your development environment.

## Project Structure

The Budget Buddy repository consists of two main folders:

1. `budget_buddy/` - Contains the Flutter project for the front end of the application.
2. `backend/` - Contains the Node.js application for the back end of the application.

The structure of each folder is as follows:

### Frontend (Flutter)

- `lib/` - Contains the main Dart code for the Flutter app.
- `lib/pages` - Holds all the pages of the application.

### Backend (Node.js)

- `src/` - Contains the main Node.js code for the back end.
- `services/` - Stores configuration files for the database and other settings.
- `models/` - Defines the data models used in the application.
- `routes/` - Handles API routes and controllers for various endpoints.
- `controllers/` - Contains the logic for handling requests and responses.

## Database Table Design

Budget Buddy utilizes a MySQL database with the following table design:

1. `users` - Stores user details, including username, password, and other relevant information.
2. `income` - Tracks the income records of users, including income amount, date, and associated user ID.
3. `expenses` - Manages the expense records of users, including expense amount, date, category, and associated user ID.
4. `balance` - Stores the current balance for each user, including the user ID and balance amount.

Feel free to explore the project's code and modify it to suit your requirements. 

---

Please note that the above content is just an example, and you should modify it to reflect your specific Flutter app, its structure, and the database table design. Adapt the instructions and explanations to match your project's configuration and requirements.
