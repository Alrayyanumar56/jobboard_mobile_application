# jobboard_mobile_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project Structure

```
lib/
├── main.dart                 # entry point, splash, auth gate, seeker navigation
├── app/theme.dart            # light/dark Material 3 themes
├── core/validators.dart      # shared form validators
├── state/app_state.dart      # global state (ChangeNotifier) + business logic
└── features/
    ├── auth/                 # login/register (domain, data, presentation)
    ├── jobs/                 # job model, repository, home, details, cards
    ├── applications/         # application model + seeker screens
    ├── employer/             # post jobs, view applicants, change status
    ├── notifications/        # notification model + screen
    ├── profile/              # resume model, profile and resume screens
    └── saved/                # saved jobs screen
```

- **domain** = models and repository interfaces
- **data** = mock implementations (swap for a real API later)
- **presentation** = screens and widgets

Demo accounts: `seeker@demo.com` / `employer@demo.com`, password `123456`.