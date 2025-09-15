# M&S Chat Application

[![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-blue.svg?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.0+-blue.svg?logo=dart)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-orange.svg?logo=firebase)](https://firebase.google.com/)

A modern, feature-rich Flutter chat application built with Clean Architecture principles, real-time messaging capabilities, and comprehensive user management.

## 🚀 Features

### Core Features

- **Real-time Messaging**: Socket.IO integration for instant messaging
- **User Authentication**: Secure login and registration system
- **User Management**: Complete user profile management
- **Chat Management**: Create, access, and manage chat conversations
- **Message Operations**: Send, receive, and delete messages
- **Push Notifications**: Firebase Cloud Messaging integration
- **Offline Support**: Local data storage with Hive database
- **Network State Handling**: Connectivity monitoring and error handling
- **Image Support**: Image picker and caching capabilities
- **Permission Management**: Runtime permission handling
- **Responsive Design**: Adaptive UI using Sizer package

### Technical Features

- **Clean Architecture**: Separation of concerns with presentation, domain, and data layers
- **State Management**: Provider pattern for efficient state management
- **Dependency Injection**: GetIt for service locator pattern
- **API Integration**: Dio HTTP client with custom interceptors
- **Local Storage**: Hive database for offline data persistence
- **Navigation**: Go Router for declarative routing
- **Error Handling**: Comprehensive error handling and user feedback
- **Security**: AES encryption for sensitive data
- **Performance**: Lazy loading, caching, and optimized image handling

## 📁 Project Structure

```text
lib/
├── app/                          # Application entry point
│   ├── app.dart                  # Main app widget
│   └── app_provider.dart         # Global providers
├── src/
│   ├── api/                      # API layer
│   │   ├── exception/            # API exceptions
│   │   ├── failure/              # Failure models
│   │   ├── state/                # Data state management
│   │   ├── api_client.dart       # HTTP client configuration
│   │   ├── api_interceptor.dart  # Request/response interceptors
│   │   └── endpoints.dart        # API endpoints
│   ├── config/                   # Configuration
│   │   ├── constant/             # App constants (colors, strings, assets)
│   │   └── router/               # Navigation and routing
│   ├── core/                     # Core utilities
│   │   ├── database/             # Local storage
│   │   ├── entity/               # Base entities
│   │   ├── extension/            # Dart extensions
│   │   ├── model/                # Common models
│   │   ├── services/             # Core services (network, notifications, etc.)
│   │   ├── usecase/              # Base use case classes
│   │   ├── utils/                # Utility classes
│   │   └── widgets/              # Reusable UI components
│   └── feature/                  # Feature modules
│       ├── auth/                 # Authentication feature
│       │   ├── data/             # Data layer (datasources, models, repositories)
│       │   ├── domain/           # Domain layer (entities, repositories, use cases)
│       │   └── presentation/     # Presentation layer (providers, screens)
│       ├── home/                 # Home/Chat feature
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       └── splash/               # Splash screen
├── firebase_options.dart         # Firebase configuration
├── locator.dart                  # Dependency injection setup
└── main.dart                     # Application entry point
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.7.0+
- **Language**: Dart
- **State Management**: Provider
- **Dependency Injection**: GetIt
- **HTTP Client**: Dio
- **Local Database**: Hive
- **Real-time Communication**: Socket.IO
- **Backend**: Firebase (Auth, Messaging)
- **Navigation**: Go Router
- **UI Components**: Custom widgets with Material Design
- **Image Handling**: Cached Network Image, Image Picker
- **Permissions**: Permission Handler
- **Network**: Connectivity Plus
- **Encryption**: Encrypt package
- **Responsive Design**: Sizer

## 📋 Prerequisites

Before running this project, make sure you have:

- Flutter SDK (3.7.0 or higher)
- Dart SDK (3.7.0 or higher)
- Android Studio / VS Code with Flutter extension
- Firebase project setup
- Android emulator or physical device for testing

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd chat
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android/iOS app to your Firebase project
3. Download and place the configuration files:
   - `google-services.json` in `android/app/`
   - `GoogleService-Info.plist` in `ios/Runner/`
4. Enable Firebase Authentication and Cloud Messaging

### 4. Configure Assets

```bash
flutter packages pub run flutter_assets_generator:build
```

### 5. Run the Application

```bash
flutter run
```

## 📱 Build & Deploy

### Debug Build

```bash
flutter run --debug
```

### Release Build

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Generate Native Splash

```bash
flutter pub run flutter_native_splash:create
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 🏗️ Architecture

This project follows **Clean Architecture** principles:

### Presentation Layer

- **Screens**: UI components and user interaction
- **Providers**: State management using Provider pattern
- **Widgets**: Reusable UI components

### Domain Layer

- **Entities**: Business objects
- **Use Cases**: Business logic and rules
- **Repository Interfaces**: Contracts for data access

### Data Layer

- **Models**: Data transfer objects
- **Datasources**: API and local data sources
- **Repository Implementations**: Data access logic

## 🔧 Key Services

- **Network Service**: Connectivity monitoring
- **Socket Service**: Real-time communication
- **Notification Service**: Push notifications
- **Permission Service**: Runtime permissions
- **Image Service**: Image processing and caching
- **AES Cipher Service**: Data encryption
- **Storage Service**: Local data persistence

## 🎨 UI Components

- **Custom Button**: Reusable button component
- **Custom Form Field**: Styled input fields
- **Custom Image**: Optimized image widget
- **Custom Text**: Themed text component
- **Loader**: Loading indicators
- **Message Notification**: In-app notifications
- **Permission Dialog**: Permission request dialogs

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

If you have any questions or need help with setup, please open an issue or contact the development team.

---

## Built with ❤️ using Flutter**
