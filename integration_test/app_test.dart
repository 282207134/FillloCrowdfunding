import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:filllo/app.dart';
import 'package:filllo/core/app_store.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('complete gift flow and screenshot every screen', (tester) async {
    // Keep scripted text edits deterministic instead of racing Android's IME.
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    tester.testTextInput.register();
    addTearDown(tester.testTextInput.unregister);
    final store = AppStore();
    final nav = GlobalKey<NavigatorState>();
    final captureKey = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: captureKey,
        child: FillloApp(
          store: store,
          initialRoute: '/onboarding',
          navigatorKey: nav,
        ),
      ),
    );
    await tester.runAsync(() async {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      await Future.wait(
        manifest
            .listAssets()
            .where((path) => path.startsWith('assets/images/'))
            .map(
              (path) => precacheImage(AssetImage(path), nav.currentContext!),
            ),
      );
    });
    await tester.pumpAndSettle();
    Future<void> shot(String name) async {
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      // Capture the current Flutter layer tree; native PixelCopy can lag a frame.
      final boundary =
          captureKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      binding.reportData ??= {};
      final captures = binding.reportData!.putIfAbsent(
        'captures',
        () => <Map<String, String>>[],
      ) as List;
      captures.add({
        'name': name,
        'png': base64Encode(png!.buffer.asUint8List()),
      });
    }

    Future<void> page(String route, String name) async {
      nav.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
      await shot(name);
    }

    await shot('01-onboarding');
    await tester.tap(find.text('Next'));
    await shot('02-onboarding');
    await tester.tap(find.text('Next'));
    await shot('03-onboarding');
    await tester.tap(find.text('Get Started'));
    await shot('04-welcome');
    await page('/signup', '05-signup');
    await page('/verify', '06-verification');
    await page('/signin', '07-signin');
    await tester.enterText(find.byKey(const Key('email')), 'demo@filllo.app');
    await tester.enterText(find.byKey(const Key('password')), 'Filllo123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in'));
    await shot('08-home');
    expect(store.signedIn, isTrue);
    await tester.drag(find.byType(ListView).first, const Offset(0, -640));
    await shot('09-home-more');
    await page('/category', '10-causes');
    await page('/nearby', '11-nearby');
    await page('/organization', '12-organization');
    await page('/details', '13-details');
    await tester.tap(find.text('Give'));
    await shot('14-select-gift');
    await tester.tap(find.text(r'$35'));
    await tester.tap(find.text('Give'));
    await shot('15-gift-summary');
    await tester.tap(find.text('Set Recurring'));
    await shot('16-recurring-sheet');
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'Together we rebuild.',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await shot('17-payment');
    await tester.tap(find.text('Pay Now'));
    await shot('18-receipt');
    expect(store.donations.length, 1);
    expect(store.donations.first.amount, 35);
    expect(store.donations.first.frequency, 'Weekly');
    expect(store.donations.first.message, 'Together we rebuild.');
    await page('/custom-gift', '19-custom-gift');
    await page('/search', '20-search');
    await tester.enterText(find.byType(TextField).first, 'Hurricane');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await shot('21-search-results');
    await tester.enterText(find.byType(TextField).first, 'no-matching-cause');
    await tester.pumpAndSettle();
    expect(find.text('No matching causes'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('No matching causes'), findsOneWidget);
    await shot('22-search-empty');
    await page('/profile', '23-profile');
    await tester.drag(find.byType(ListView).first, const Offset(0, -240));
    await shot('24-profile-menu');
    await tester.tap(find.text('Reminders'));
    await shot('25-reminders');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    await page('/profile-details', '26-profile-details');
    await page('/wallet', '27-wallet');
    await tester.tap(find.text('Credit or debit card'));
    await shot('28-add-card');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    await page('/history', '29-history');
    await page('/recurring', '30-recurring-gifts');
    await page('/fundraise-for', '31-fundraise-for');
    await page('/fundraise-details', '32-fundraise-details');
    await tester.tap(find.text('Animals'));
    await shot('33-category-sheet');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    await page('/support', '34-support');
    await page('/forgot', '35-reset-password');
    store.donations.clear();
    await page('/history', '36-history-empty');
    await page('/home', '37-home-final');
  });
}
