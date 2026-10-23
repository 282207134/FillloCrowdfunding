import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Local demonstration state. Payment credentials and passwords are never stored.
class AppStore extends ChangeNotifier {
  final SharedPreferences? preferences;
  AppStore({this.preferences});
  bool onboarded = false, signedIn = false, following = false;
  String name = 'Filllo Design Agency', email = 'example@gmail.com';
  String phone = '873-456-9898', address = '321 Losh Lane, Jhorna Lake, WI';
  String reminder = 'Daily', frequency = 'One time', message = '';
  String fundraiserFor = 'Yourself',
      fundraiserTitle = '',
      fundraiserCategory = 'Animals';
  String location = 'Shibganj, Sylhet';
  double amount = 35;
  Campaign campaign = campaigns.first;
  final List<String> cards = [
    'Visa Card •••• 1982',
    'Mastercard •••• 2648',
    'AMEX Card •••• 1005',
  ];
  int selectedCard = 0;
  final List<Donation> donations = [];
  Donation? get lastDonation => donations.isEmpty ? null : donations.first;
  double get totalGiving => donations.fold(0, (sum, d) => sum + d.amount);

  static Future<AppStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final store = AppStore(preferences: prefs);
    final raw = prefs.getString('filllo_state');
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        store.onboarded = data['onboarded'] ?? false;
        store.signedIn = data['signedIn'] ?? false;
        store.name = data['name'] ?? store.name;
        store.email = data['email'] ?? store.email;
        store.phone = data['phone'] ?? store.phone;
        store.address = data['address'] ?? store.address;
        store.reminder = data['reminder'] ?? 'Daily';
        store.following = data['following'] ?? false;
        store.location = data['location'] ?? store.location;
        store.fundraiserFor = data['fundraiserFor'] ?? store.fundraiserFor;
        store.fundraiserTitle = data['fundraiserTitle'] ?? '';
        store.fundraiserCategory = data['fundraiserCategory'] ?? 'Animals';
        if (data['cards'] is List && (data['cards'] as List).isNotEmpty) {
          store.cards
            ..clear()
            ..addAll((data['cards'] as List).cast<String>());
        }
        store.donations.addAll(
          (data['donations'] as List? ?? []).map((d) => Donation.fromJson(d)),
        );
      } on FormatException {
        return AppStore(preferences: prefs);
      } on TypeError {
        return AppStore(preferences: prefs);
      }
    }
    return store;
  }

  Future<void> save() async {
    notifyListeners();
    await preferences?.setString(
      'filllo_state',
      jsonEncode({
        'onboarded': onboarded,
        'signedIn': signedIn,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'reminder': reminder,
        'following': following,
        'location': location,
        'fundraiserFor': fundraiserFor,
        'fundraiserTitle': fundraiserTitle,
        'fundraiserCategory': fundraiserCategory,
        'cards': cards,
        'donations': donations.map((d) => d.toJson()).toList(),
      }),
    );
  }

  void chooseCampaign(Campaign value) {
    campaign = value;
    amount = 35;
    frequency = 'One time';
    message = '';
    notifyListeners();
  }

  Future<Donation> donate() async {
    if (!amount.isFinite || amount <= 0 || amount > 12980) {
      throw StateError('Enter an amount between 0.01 and 12,980.');
    }
    final now = DateTime.now();
    final gift = Donation(
      id: 'FL-${now.microsecondsSinceEpoch}',
      campaignId: campaign.id,
      title: campaign.title,
      frequency: frequency,
      message: message,
      card: cards[selectedCard],
      amount: amount,
      date: now,
    );
    donations.insert(0, gift);
    await save();
    return gift;
  }
}

class AppScope extends InheritedNotifier<AppStore> {
  const AppScope({super.key, required AppStore store, required super.child})
    : super(notifier: store);
  static AppStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
