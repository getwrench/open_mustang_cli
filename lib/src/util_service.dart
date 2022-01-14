import 'dart:io';

import 'package:path/path.dart' as p;

import 'utils.dart';

class UtilService {
  static Future<void> create(
    String utilFileName,
    String? customSerializer,
  ) async {
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
      await file.writeAsString(_template(customSerializer));
      print('  Created $path');
      return;
    }
    print('$path exists, skipping operation..');
  }

  static String _template(String? customSerializer) {
    String pkgName = Utils.pkgName();
    String appSerializer = 'app_serializer';
    String customSerializerStr = '';
    String jsonEncodeStr;
    if (customSerializer != null) {
      String customSerializerAlias = Utils.generateRandomString(10);
      customSerializerStr =
          "import '$customSerializer' as $customSerializerAlias;";
      jsonEncodeStr = '''jsonEncode(
          $appSerializer.serializerNames.contains('\$T')
              ? $appSerializer.serializers.serialize(t)
              : $customSerializerAlias.serializers.serialize(t))''';
    } else {
      jsonEncodeStr = '''jsonEncode($appSerializer.serializers.serialize(t))''';
    }

    return '''
// GENERATED CODE - DO NOT MODIFY BY HAND

import 'dart:convert';
import 'dart:developer';

import '$pkgName/src/models/serializers.dart' as $appSerializer;
import 'package:flutter/foundation.dart';
import 'package:mustang_core/mustang_core.dart';
$customSerializerStr

class MustangUtils {
  // Saves the object in WrenchStore and also persists to disk
  static Future<void> saveAndPersist<T>(T t) async {
    WrenchStore.update(t);
    if (kDebugMode) {
      postEvent('mustang', {
        'modelName': '\$T', 
        'modelStr': $jsonEncodeStr,
      });
    }
    await WrenchStore.persistObject(
      '\$T',
      $jsonEncodeStr,
    );
  }
}
    ''';
  }
}
