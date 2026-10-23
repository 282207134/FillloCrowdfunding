import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await integrationDriver(
    responseDataCallback: (data) async {
      for (final capture in data?['captures'] as List? ?? []) {
        final file = File('docs/screenshots/${capture['name']}.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(base64Decode(capture['png'] as String));
      }
    },
  );
}
