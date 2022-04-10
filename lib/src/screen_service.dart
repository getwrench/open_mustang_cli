import 'dart:io';

import 'utils.dart';

class ScreenService {
  /// [screenDir] is the directory path in  `lib/src/screens`
  static Future<void> create(String screenDir) async {
    String assetName = Utils.pathToClass(screenDir);
    String assetFilename = Utils.class2File(assetName);
    String path =
        '${Utils.defaultScreenPrefix}/$screenDir/${assetFilename}_service.dart';
    bool exists = await File(path).exists();
    if (!exists) {
      File file = File(path);
      await file.writeAsString(_template(assetName, assetFilename));
      print('  Created $path');
      return;
    }
    print('$path exists, skipping operation..');
  }

  static String _template(String assetName, String assetFilename) {
    String modelVar = Utils.classNameToVar(assetName);
    String modelFileName = Utils.class2File(assetName);
    String pkgName = Utils.pkgName();

    return '''
import 'package:mustang_core/mustang_core.dart';
import '$pkgName/src/models/$modelFileName.model.dart';

import '${assetFilename}_service.service.dart';

@screenService 
abstract class \$${assetName}Service {
  Future<void> memoizedGetData() {
    $assetName $modelVar = MustangStore.get<$assetName>() ?? $assetName();
    if ($modelVar.clearScreenCache) {
      clearMemoizedScreen(reload: false);
      $modelVar = $modelVar.rebuild(
        (b) => b..clearScreenCache = false,
      );
      updateState1($modelVar, reload: false);
    }
    return memoizeScreen(getData);
  }
  
  Future<void> getData({
    bool showBusy = true,
  }) async {
    $assetName $modelVar = MustangStore.get<$assetName>() ?? $assetName();
    if (showBusy) {
      $modelVar = $modelVar.rebuild(
        (b) => b
          ..busy = true
          ..errorMsg = '',
      );
      updateState1($modelVar);
    }
    // Add API calls here, if any
    $modelVar = $modelVar.rebuild((b) => b..busy = false);
    updateState1($modelVar);
  }

  void clearCacheAndReload({bool reload = true}) {
    clearMemoizedScreen(reload: reload);
  }
}
    ''';
  }
}
