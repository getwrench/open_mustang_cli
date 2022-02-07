import 'dart:io';

import 'package:path/path.dart' as p;

import 'utils.dart';

class Aspect {
  /// [aspectFile] is the name of the file that gets created inside `/lib/aspects` directory
  static Future<void> create(String aspectFile) async {
    aspectFile = aspectFile.replaceAll('-', '_').replaceAll('.dart', '');
    // removing directories in the path, if any
    aspectFile = p.basename(aspectFile);
    String path = '${Utils.defaultAspectPrefix}/$aspectFile.dart';
    String aspectClass = Utils.pathToClass(aspectFile);

    String aspectsDir = p.dirname(path);
    bool exists = await Directory(aspectsDir).exists();
    if (!exists) {
      await Directory(aspectsDir).create(recursive: true);
      print('  Created $aspectsDir');
    }

    exists = await File(path).exists();
    if (!exists) {
      File file = File(path);
      await file.writeAsString(_template(aspectClass));
      print('  Created $path');
      return;
    }
    print('$path exists, skipping operation..');
  }

  static String _template(String aspectClass) {
    return '''
import 'package:mustang_core/mustang_core.dart';

@aspect
abstract class \$$aspectClass {
  // Uncomment below method if this is a Before or After aspect
  /*
  @invoke
  Future<void> run() async {
    // add code here
  }
  */
  
  // Uncomment below method if this is an Around aspect
  /*
  @invoke
  Future<void> run(Function sourceMethod) async {
    // add code here
    await sourceMethod();
    // add code here
  }
  */
}
    ''';
  }
}
