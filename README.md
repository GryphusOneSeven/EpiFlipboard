# EpiFlipboard# EpiFlipboard

EpiFlipboard is a Flutter news reader application inspired by Flipboard.  
It allows users to sign in (Google Sign-In), browse articles by topics, search for content, and view article details in a modern dark interface.

## Features

- **Authentication**  
  - Sign in with Google (`google_sign_in`)  
  - Secure storage of token / session (`flutter_secure_storage` and `AuthStorage`)

- **News feed**  
  - Home page with a list of articles  
  - Navigation by **topics** / categories  
  - Article detail page (`ArticlePage`)  
  - Additional pages: `Search`, `Feed`, `Subscriptions`, `Notifications`, `Profile` (depending on what is implemented in `lib/pages`)

- **API integration**  
  - Fetching articles via `NewsAPI` / custom backend  
  - Configuration handled in `config/newsApi.dart` and `api/backend_url.dart`

- **UI / UX**  
  - Custom dark theme inspired by Netflix (red #E50914, dark backgrounds)  
  - Navigation with named routes (`/login`, `/home`, `/topic`, `/article`)  
  - Splash loader while checking the session (via `FutureBuilder` in `main.dart`)

- **Tests**  
  - Unit tests for the `Article` model (`test/article_model_test.dart`)  
  - Uses `flutter_test` and `mocktail` for mocks  

## Project architecture

- **`lib/main.dart`**  
  Application entry point.  
  - Flutter initialization  
  - Login state check (`AuthStorage.isLoggedIn()`)  
  - Initial page selection (Login or Home)  
  - Dark theme and route configuration.

- **`lib/pages/`**  
  - `login.dart`: login screen  
  - `home.dart`: main page / article feed  
  - `topic.dart`: articles by topic  
  - `article.dart`: article detail page  
  - `search.dart`, `feed.dart`, `subscriptions.dart`, `results.dart`, `notifications.dart`, `profile.dart`: other app screens.

- **`lib/services/`**  
  - `auth_service.dart`: authentication logic (Google Sign-In, backend, etc.)  
  - `auth_storage.dart`: login state persistence (secure storage)  
  - `newsAPI.dart`: access to the news API.

- **`lib/config/`**  
  - `newsApi.dart`: news API configuration  
  - `secrets.dart`: keys or secrets (should not be committed in plain text in production).

- **`lib/models/`**  
  - `articleResult.dart`: article data model (with `Article.fromJson`).

- **`test/`**  
  - `article_model_test.dart`: unit tests for the `Article` model.

## Requirements

- **Flutter** SDK (version compatible with `sdk: ^3.9.2`)  
- **Dart** (included with Flutter)  
- An IDE or editor (Android Studio, VS Code, Cursor, …)  
- Internet access for the news API and Google Sign-In

## Installation & run

1. **Clone the repository**

   ```bash
   git clone <REPO_URL>
   cd EpiFlipboard/epiflipboard
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure secrets / APIs**

   - Fill in `lib/config/newsApi.dart` with the NewsAPI key (or equivalent).  
   - Fill in `lib/config/secrets.dart` with the required keys (Google Sign-In, backend, etc.).  
   - Check backend configuration in `lib/api/backend_url.dart`.

4. **Run the application**

   - On an emulator or a connected device:

     ```bash
     flutter run
     ```

   - To run unit tests:

     ```bash
     flutter test
     ```

## Useful scripts

- **Run the app in debug**

  ```bash
  flutter run
  ```

- **Run all tests**

  ```bash
  flutter test
  ```

- **Upgrade dependencies**

  ```bash
  flutter pub upgrade
  ```

## Epitech context / School project

This project was created as part of an Epitech school project.  
It demonstrates:

- The use of **Flutter** to build a modern mobile application.  
- Integration of external APIs (NewsAPI / custom backend).  
- Authentication with Google and secure session management.  
- Writing simple unit tests around the data model.

## Possible improvements

- Add more tests (services, pages, integration).  
- Offline mode / caching of articles.  
- Multi-language support (FR/EN).  
- Advanced feed customization (favorites, recommendations, etc.).

## License

To be defined by the repository owner (for example MIT, GPL, etc.).