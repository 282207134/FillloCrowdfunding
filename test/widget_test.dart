import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filllo/app.dart';
import 'package:filllo/core/app_store.dart';

void main() {
  setUpAll(() async {
    final loader = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    await loader.load();
  });
  testWidgets('all routes fit narrow and standard phones', (tester) async {
    final nav = GlobalKey<NavigatorState>();
    final store = AppStore();
    await store.donate();
    const routes = [
      '/onboarding',
      '/welcome',
      '/signin',
      '/signup',
      '/verify',
      '/forgot',
      '/fundraise-for',
      '/fundraise-details',
      '/home',
      '/search',
      '/category',
      '/nearby',
      '/organization',
      '/details',
      '/gift',
      '/custom-gift',
      '/summary',
      '/payment',
      '/receipt',
      '/wallet',
      '/profile',
      '/profile-details',
      '/history',
      '/recurring',
      '/support',
    ];
    for (final size in [const Size(375, 812), const Size(320, 640)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        FillloApp(store: store, initialRoute: '/home', navigatorKey: nav),
      );
      await tester.pumpAndSettle();
      for (final route in routes) {
        nav.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$route at $size');
      }
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
  testWidgets('invalid custom gifts cannot advance', (tester) async {
    await tester.pumpWidget(
      FillloApp(store: AppStore(), initialRoute: '/custom-gift'),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('custom-amount')), '-1');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter 0.01 – 12,980.00'), findsOneWidget);
    expect(find.text('Gift Summary'), findsNothing);
  });
  testWidgets('editing an amount retains the gift message', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = AppStore()..message = 'A saved wish';
    await tester.pumpWidget(FillloApp(store: store, initialRoute: '/summary'));
    await tester.pumpAndSettle();
    expect(find.text('A saved wish'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Together we rebuild');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.ensureVisible(find.text('Edit amount'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit amount'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(r'$45'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(r'$45'));
    await tester.tap(find.text('Give'));
    await tester.pumpAndSettle();
    expect(store.amount, 45);
    expect(find.text('Together we rebuild'), findsOneWidget);
  });
  testWidgets('saved fundraiser draft reopens with its details', (
    tester,
  ) async {
    final store = AppStore()
      ..fundraiserTitle = 'Community rebuild'
      ..fundraiserCategory = 'Medical';
    await tester.pumpWidget(
      FillloApp(store: store, initialRoute: '/fundraise-details'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Community rebuild'), findsOneWidget);
    expect(find.text('Medical'), findsOneWidget);
  });
}
