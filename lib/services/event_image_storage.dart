import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Copies picked event images into app storage so paths stay valid after restart.
class EventImageStorage {
  EventImageStorage._();

  static Future<String?> persistPickedImage(
    String sourcePath,
    String eventId,
  ) async {
    try {
      final source = File(sourcePath);
      if (!await source.exists()) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final eventsDir = Directory(p.join(appDir.path, 'event_images'));
      if (!await eventsDir.exists()) {
        await eventsDir.create(recursive: true);
      }

      final ext = p.extension(sourcePath);
      final dest = File(p.join(eventsDir.path, '$eventId$ext'));
      await source.copy(dest.path);
      return dest.path;
    } catch (_) {
      return null;
    }
  }
}
