import 'package:integration_test/integration_test.dart';

// Import all flow tests
import 'flows/auth_flow_test.dart' as auth_flow;
import 'flows/navigation_flow_test.dart' as navigation_flow;
import 'flows/places_flow_test.dart' as places_flow;
import 'flows/reviews_flow_test.dart' as reviews_flow;
import 'flows/content_flow_test.dart' as content_flow;
import 'flows/profile_flow_test.dart' as profile_flow;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Run all integration test groups
  auth_flow.main();
  navigation_flow.main();
  places_flow.main();
  reviews_flow.main();
  content_flow.main();
  profile_flow.main();
}
