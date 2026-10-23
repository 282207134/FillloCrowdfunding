import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filllo/core/app_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('donation and profile persist across a reload', () async {
    final store = await AppStore.load();
    store.name = 'A Kind Person';
    store.email = 'kind@example.com';
    store.amount = 60.25;
    store.frequency = 'Monthly';
    store.message = 'Stay strong';
    store.selectedCard = 1;
    final gift = await store.donate();
    final restored = await AppStore.load();
    expect(restored.name, 'A Kind Person');
    expect(restored.donations.single.id, gift.id);
    expect(restored.donations.single.amount, 60.25);
    expect(restored.donations.single.frequency, 'Monthly');
    expect(restored.donations.single.message, 'Stay strong');
    expect(restored.donations.single.card, contains('Mastercard'));
    expect(restored.totalGiving, 60.25);
  });
  test(
    'invalid or excessive amounts are rejected without creating gifts',
    () async {
      final store = AppStore();
      for (final value in [0.0, -1.0, double.nan, double.infinity, 12980.01]) {
        store.amount = value;
        await expectLater(store.donate(), throwsStateError);
        expect(store.donations, isEmpty);
      }
    },
  );
}
