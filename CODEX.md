# CODEX

## Project Summary
Sekaijin is a Flutter mobile app to discover places, news, events, and reviews around Japanese culture. The codebase follows a clean architecture style with Riverpod for state management and GoRouter for navigation.

## Stack
- Flutter (Dart SDK ^3.10.7)
- State: flutter_riverpod
- Routing: go_router
- HTTP: dio
- Storage: flutter_secure_storage, shared_preferences
- UI helpers: cached_network_image, shimmer, flutter_svg, flutter_html
- Media: image_picker, flutter_image_compress
- Connectivity: connectivity_plus

## Architecture Map
- lib/main.dart initializes Flutter and ProviderScope.
- lib/app.dart configures MaterialApp.router with theme and routes.
- lib/core contains config, constants, utils, and error types.
- lib/domain defines entities and repository interfaces.
- lib/data contains models, remote datasources, and repository implementations.
- lib/presentation contains providers, screens, and widgets.
- lib/services contains ApiService, AuthService, interceptors, and image compression.
- docs contains API documentation and test reports.

## Data Flow
- UI widgets read/write Riverpod providers.
- Providers call repositories (domain interfaces).
- Repositories call remote datasources using Dio.
- API responses map to ApiResponse<T> with optional pagination.
- Errors are normalized into Failure types and returned as record tuples: (Failure?, Data?).

## Routing & Navigation
- Routes defined in lib/core/config/routes.dart.
- Initial route is splash (/), with auth redirect logic in GoRouter.
- Main navigation uses StatefulShellRoute with bottom tabs: home, explore, add, news, profile.
- Detail routes use slugs for places, articles, and events.

## Auth & Security
- Tokens stored in FlutterSecureStorage via AuthService.
- AuthInterceptor attaches Bearer token and clears storage on 401.
- AuthNotifier handles login/register/logout and publishes AuthState.

## Features Overview
- Auth: login, register, logout with secure storage.
- Places: list, detail, create, and user places.
- Reviews: list, create, update, delete; user reviews.
- Articles and Events: list and detail.
- Profile screens for user content.
- Home screen currently uses mock data in homeDataProvider.

## Configuration & Theming
- AppConfig holds baseUrl and Dio timeouts.
- AppTheme defines light theme and colors in AppColors.
- Validation helpers in lib/core/utils/validators.dart.

## Tests
- Unit and widget tests under test/.
- Integration flows under integration_test/.

## Common Dev Commands
- flutter pub get
- flutter run
- flutter test
- flutter test integration_test
- flutter analyze

## Key Files
- lib/core/config/routes.dart: navigation and redirects.
- lib/services/api_service.dart: Dio setup and interceptors.
- lib/services/auth_service.dart: secure token storage.
- lib/data/models/api_response.dart: response and pagination mapping.
- lib/presentation/providers/auth_provider.dart: auth state and providers.
- docs/API_SPECIFICATION.md: backend contract.

## Observations / Risks
- Splash screen currently redirects to /login without checking auth status; AuthNotifier.checkAuthStatus is not used.
- AuthService stores user JSON under StorageKeys.userId which may be a naming mismatch.
- Home provider uses mock data; API wiring may be pending.
- ApiEndpoints uses absolute URLs while Dio also has a baseUrl; this is functional but mixed usage.
