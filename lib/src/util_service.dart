import 'dart:io';

import 'package:path/path.dart' as p;

import 'utils.dart';

class UtilService {
  static Future<void> create(String utilFileName) async {
    String path = '${Utils.defaultUtilsPrefix}/$utilFileName';
    String utilsDir = p.dirname(path);
    bool exists = await Directory(utilsDir).exists();
    if (!exists) {
      await Directory(utilsDir).create(recursive: true);
      print('  Created $utilsDir');
    }

    exists = await File(path).exists();
    if (!exists) {
      File file = File(path);
      await file.writeAsString(_template());
      print('  Created $path');
      return;
    }
    print('$path exists, skipping operation..');
  }

  static String _template() {
    String pkgName = Utils.pkgName();
    String appSerializer = 'app_serializer';

    return '''
// GENERATED CODE - DO NOT MODIFY BY HAND

import 'dart:convert';

import '$pkgName/src/models/serializers.dart' as $appSerializer;
import 'package:mustang_core/mustang_core.dart';

class MustangUtils {
  // Saves the object in WrenchStore and also persists to disk
  static Future<void> saveAndPersist<T>(T t) async {
    WrenchStore.update(t);
    await WrenchStore.persistObject(
      '\$T',
      jsonEncode($appSerializer.serializers.serialize(t)),
    );
  }
}
    ''';
  }
}
