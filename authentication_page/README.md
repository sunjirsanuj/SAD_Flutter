# Zikra – Flutter Authentication App

A simple authentication application built with **Flutter** and **Provider** as part of a Flutter development assignment.

The project demonstrates basic user registration, login validation, state management, and navigation between authentication screens.

## Features

- **User Registration** – Create an account using full name, username, email, and password.
- **Login System** – Log in using registered email and password.
- **Input Validation** – Checks required fields, email format, and minimum password length.
- **Password Validation** – Requires a password of at least 6 characters.
- **State Management** – Uses Provider and ChangeNotifier to manage authentication state.
- **Navigation** – Navigate between Login, Sign Up, and Home screens.
- **Reusable Widgets** – Custom text fields, buttons, brand logo, and brand name components.

## Screenshots

Add your application screenshots here.

| Login Page | Sign Up Page | Home Page |
|:---:|:---:|:---:|
| Add screenshot | Add screenshot | Add screenshot |

To add screenshots, create a `screenshots` folder in your project and use:

```markdown
![Login Page](screenshots/login.png)
![Sign Up Page](screenshots/signup.png)
![Home Page](screenshots/home.png)
```

## Technologies Used

- Flutter
- Dart
- Provider
- Material Design

## Project Structure

```text
lib/
├── main.dart
│
├── providers/
│   └── auth_provider.dart
│
├── screens/
│   ├── login_page.dart
│   ├── signup_page.dart
│   └── home_page.dart
│
└── widgets/
    ├── brand_logo.dart
    ├── brand_name.dart
    ├── button.dart
    ├── custom_icon_text_button.dart
    └── custom_textfield.dart

assets/
└── images/
    └── google.png
```

## Getting Started

### Prerequisites

Make sure you have installed:

- Flutter SDK
- Dart SDK
- Visual Studio Code or Android Studio
- An Android emulator or physical device

### Installation

**1. Clone the repository**

```bash
git clone YOUR_REPOSITORY_URL](https://github.com/sunjirsanuj/SAD_Flutter.git)
```

**2. Navigate to the project directory**

```bash
cd authentication_page
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Run the application**

```bash
flutter run
```

## Authentication Flow

1. Open the application to access the Login page.
2. If you do not have an account, navigate to the Sign Up page.
3. Enter your full name, username, email, and password.
4. Complete registration.
5. Return to the Login page.
6. Enter your registered email and password.
7. After successful login, navigate to the Home page.

## State Management

This project uses the **Provider** package with `ChangeNotifier` to manage authentication data.

The `AuthProvider` handles:

- Storing the current user's information during the application session.
- Validating registration information.
- Checking login credentials.
- Notifying listeners when authentication state changes.

## Current Limitations

- User information is stored in memory and is not permanently saved.
- Registered accounts are lost when the application restarts.
- Google authentication is currently a UI placeholder and is not functional.
- Forgot Password functionality is not implemented.
- This project is intended for learning and assignment purposes, not production authentication.
