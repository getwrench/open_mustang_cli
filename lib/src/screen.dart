import 'dart:io';

import 'utils.dart';

class Screen {
  /// [screenDir] is the directory path in  `lib/src/screens`
  static Future<void> create(
    String screenDir,
    List<String>? customScreenImports,
    String? errorWidget,
    String? progressWidget,
  ) async {
    String assetName = Utils.pathToClass(screenDir);
    String assetFilename = Utils.class2File(assetName);
    String path =
        '${Utils.defaultScreenPrefix}/$screenDir/${assetFilename}_screen.dart';

    bool exists = await File(path).exists();
    if (!exists) {
      File file = File(path);
      await file.writeAsString(_template(
        assetName,
        assetFilename,
        customScreenImports,
        errorWidget,
        progressWidget,
      ));
      print('  Created $path');
      return;
    }

    print('$path exists, skipping operation..');
  }

  static String _template(
    String assetName,
    String assetFilename,
    List<String>? customScreenImports,
    String? errorWidget,
    String? progressWidget,
  ) {
    String customScreenImportsStr =
        customScreenImports?.map((e) => "import '$e';").toList().join('\n') ??
            '';
    String modelVar = Utils.classNameToVar(assetName);
    String progressWidgetStr = progressWidget ?? 'CircularProgressIndicator()';
    String errorWidgetStr =
        errorWidget ?? "Text(state?.$modelVar.errorMsg ?? 'Unknown error')";

    return '''
import 'package:flutter/material.dart';
import 'package:mustang_widgets/mustang_widgets.dart';
import 'package:flutter/scheduler.dart';
$customScreenImportsStr

import '${assetFilename}_service.service.dart';
import '${assetFilename}_state.state.dart';

class ${assetName}Screen extends StatelessWidget {
    const ${assetName}Screen({
      Key? key,
    }) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      return StateProvider<${assetName}State>(
        state: ${assetName}State(context: context),
        child: Builder(
          builder: (BuildContext context) {
            ${assetName}State? state = StateConsumer<${assetName}State>().of(context);
            SchedulerBinding.instance?.addPostFrameCallback(
              (_) => ${assetName}Service().memoizedGetData(),
            );
  
            if (state?.$modelVar.busy ?? false) {
              return const $progressWidgetStr; 
            }
  
            if (state?.$modelVar.errorMsg.isNotEmpty ?? false) {
              $errorWidgetStr;
            }
  
            return _body(state, context);
          },
        ),
      );
    }
  
    Widget _body(${assetName}State? state, BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('$assetName'),
        ),
        body: RefreshIndicator(
          onRefresh: () => ${assetName}Service().getData(showBusy: false),
          child: const Text('Generated screen'),
        ),
      );
    }
}
    ''';
  }
}
