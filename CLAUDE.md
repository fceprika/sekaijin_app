# CLAUDE.md

## Project Summary
Sekaijin is a Flutter mobile app to discover places, news, events, and reviews around Japanese culture. Clean architecture with Riverpod for state management and GoRouter for navigation.

## Stack
- Flutter (Dart SDK ^3.10.7)
- State: flutter_riverpod
- Routing: go_router
- HTTP: dio
- Storage: flutter_secure_storage, shared_preferences
- UI: cached_network_image, shimmer, flutter_svg, flutter_html
- Media: image_picker, flutter_image_compress
- Connectivity: connectivity_plus

## Architecture
```
lib/
├── main.dart              # Entry point, ProviderScope
├── app.dart               # MaterialApp.router, theme, routes
├── core/                  # Config, constants, utils, error types
├── domain/                # Entities and repository interfaces
├── data/                  # Models, remote datasources, repo implementations
├── presentation/          # Providers, screens, widgets
├── services/              # ApiService, AuthService, interceptors
docs/                      # API spec and test reports
test/                      # Unit and widget tests
integration_test/          # Integration flows
```

## Data Flow
UI widgets → Riverpod providers → Repositories (domain interfaces) → Remote datasources (Dio) → API.
Responses map to `ApiResponse<T>` with optional pagination. Errors are `Failure` types returned as `(Failure?, Data?)` tuples.

## Routing
- Routes: `lib/core/config/routes.dart`
- Initial route: splash (`/`) with auth redirect logic
- Bottom tabs via `StatefulShellRoute`: home, explore, add, news, profile
- Detail routes use slugs for places, articles, events

## Auth
- Tokens in `FlutterSecureStorage` via `AuthService`
- `AuthInterceptor` attaches Bearer token, clears storage on 401
- `AuthNotifier` handles login/register/logout, publishes `AuthState`

## Key Files
- `lib/core/config/routes.dart` — navigation and redirects
- `lib/services/api_service.dart` — Dio setup and interceptors
- `lib/services/auth_service.dart` — secure token storage
- `lib/data/models/api_response.dart` — response and pagination mapping
- `lib/presentation/providers/auth_provider.dart` — auth state
- `docs/API_SPECIFICATION.md` — backend API contract

## Dev Commands
```bash
flutter pub get          # Install dependencies
flutter run              # Run app
flutter test             # Run tests
flutter test integration_test  # Integration tests
flutter analyze          # Static analysis
```

## Known Issues
- Splash screen redirects to `/login` without checking auth status; `AuthNotifier.checkAuthStatus` is not used
- `AuthService` stores user JSON under `StorageKeys.userId` — possible naming mismatch
- Home provider uses mock data; API wiring may be pending
- `ApiEndpoints` uses absolute URLs while Dio also has a `baseUrl` — functional but mixed usage
