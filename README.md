# JobBoard – Flutter Mobile App

A job board app for Android built with Flutter (Material 3). Job seekers browse, search, save and apply for jobs; employers post jobs and manage applicants.

## Features

- **Authentication**: login and registration with form validation, separate seeker and employer roles, splash screen and auth gate
- **Jobs**: home list with search/filter, job cards, a details page, and loading skeletons
- **Saved jobs and applications**: save jobs, apply, and track application status
- **Employer side**: post jobs, view applicants, change application status
- **Profile and resume** screens, plus in-app notifications
- **Light and dark themes**

## Architecture

The app is organized by feature, with each feature split into domain, data and presentation layers. Screens depend on repository interfaces (`AuthRepository`, `JobRepository`), not on a concrete data source. The current build uses mock implementations, so connecting a real REST API means adding an API-backed repository, with no changes to the screens.

## Run it

```bash
flutter pub get
flutter run
```

Build an Android APK:

```bash
flutter build apk --release
```

## Screenshots

_Coming soon._

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