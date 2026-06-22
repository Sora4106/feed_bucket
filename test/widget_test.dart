import 'package:feed_bucket/app_state.dart';
import 'package:feed_bucket/components/app_branding.dart';
import 'package:feed_bucket/flutter_flow/flutter_flow_theme.dart';
import 'package:feed_bucket/flutter_flow/internationalization.dart';
import 'package:feed_bucket/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App boots and shows the localized home title',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    FFAppState.reset();

    await FlutterFlowTheme.initialize();
    await FFLocalizations.initialize();

    final appState = FFAppState();
    await appState.initializePersistedState();

    await tester.pumpWidget(
      ChangeNotifierProvider<FFAppState>.value(
        value: appState,
        child: MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppBranding.appName), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
