import 'package:flutter/material.dart';

import 'core/app_store.dart';
import 'core/theme.dart';
import 'features/auth/auth_pages.dart';
import 'features/discover/discover_pages.dart';
import 'features/giving/giving_pages.dart';
import 'features/profile/profile_pages.dart';

class FillloApp extends StatelessWidget {
  final AppStore store;
  final String? initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  const FillloApp({
    super.key,
    required this.store,
    this.initialRoute,
    this.navigatorKey,
  });
  @override
  Widget build(BuildContext context) => AppScope(
    store: store,
    child: MaterialApp(
      title: 'Filllo',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      navigatorKey: navigatorKey,
      initialRoute:
          initialRoute ??
          (store.signedIn
              ? '/home'
              : store.onboarded
              ? '/welcome'
              : '/onboarding'),
      onGenerateRoute: (settings) {
        final page = switch (settings.name) {
          '/onboarding' => const OnboardingPage(),
          '/welcome' => const WelcomePage(),
          '/signin' => const AuthPage(),
          '/signup' => const AuthPage(signUp: true),
          '/verify' => const VerifyPage(),
          '/forgot' => const ForgotPage(),
          '/fundraise-for' => const FundraiseForPage(),
          '/fundraise-details' => const FundraiseDetailsPage(),
          '/home' => const MainShell(),
          '/search' => const SearchPage(),
          '/category' => const CampaignListPage(),
          '/nearby' => const CampaignListPage(nearby: true),
          '/organization' => const OrganizationPage(),
          '/details' => const DetailsPage(),
          '/gift' => const GiftPage(),
          '/custom-gift' => const CustomGiftPage(),
          '/summary' => const SummaryPage(),
          '/payment' => const WalletPage(payment: true),
          '/receipt' => const ReceiptPage(),
          '/wallet' => const WalletPage(),
          '/profile' => const ProfilePage(),
          '/profile-details' => const ProfileDetailsPage(),
          '/history' => const HistoryPage(),
          '/recurring' => const HistoryPage(recurring: true),
          '/support' => const SupportPage(),
          _ => const MainShell(),
        };
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => page,
        );
      },
    ),
  );
}
