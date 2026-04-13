import 'dart:async';

import 'package:flutter/foundation.dart';

import 'bootstrap.dart';

void main() {
  runZonedGuarded(
    () async {
      try {
        await bootstrap();
      } catch (error, stackTrace) {
        debugPrint('Bootstrap failed: $error');
        debugPrint('$stackTrace');
      }
    },
    (error, stackTrace) {
      debugPrint('Uncaught error: $error');
      debugPrint('$stackTrace');
    },
  );
}
