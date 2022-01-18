import 'dart:io';

import 'package:args/args.dart';
import 'package:open_mustang_cli/src/app_model.dart';
import 'package:open_mustang_cli/src/args.dart';
import 'package:open_mustang_cli/src/aspect.dart';
import 'package:open_mustang_cli/src/screen.dart';
import 'package:open_mustang_cli/src/screen_directory.dart';
import 'package:open_mustang_cli/src/screen_service.dart';
import 'package:open_mustang_cli/src/screen_state.dart';
import 'package:open_mustang_cli/src/util_service.dart';
import 'package:open_mustang_cli/src/utils.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class OpenMustangCli {
  // mustang config file
  static const String configFile = 'mustang.yaml';
  // Keys in mustang-cli.yaml
  static const String serializerKey = 'serializer';
  static const String screenKey = 'screen';
  static const String screenImportsKey = 'imports';
  static const String screenErrorWidgetKey = 'error_widget';
  static const String screenProgressWidgetKey = 'progress_widget';

  static void run(List<String> args) async {
    // Read configuration file, if exists
    String? userHomeDir = Utils.homeDir();
    String configFilePath = '';
    if (userHomeDir != null) {
      configFilePath = p.join(userHomeDir, configFile);
    }

    String? customSerializer;
    List<String>? customScreenImports;
    String? errorWidget;
    String? progressWidget;
    if (configFilePath.isNotEmpty && File(configFilePath).existsSync()) {
      File configFile = File(configFilePath);
      String rawConfig = await configFile.readAsString();

      dynamic yamlConfig = loadYaml(rawConfig);
      if (yamlConfig[serializerKey] != null) {
        customSerializer = yamlConfig[serializerKey];
      }

      if (yamlConfig[screenKey] != null) {
        YamlList? tempScreenImports = yamlConfig[screenKey][screenImportsKey];
        if (tempScreenImports != null) {
          customScreenImports =
              tempScreenImports.map((e) => e.toString()).toList();
        }
        errorWidget = yamlConfig[screenKey][screenErrorWidgetKey];
        progressWidget = yamlConfig[screenKey][screenProgressWidgetKey];
      }
    }

    ArgParser parser = Args.parser();
    try {
      ArgResults parsedArgs = parser.parse(args);

      if (parsedArgs.arguments.isEmpty) {
        print(parser.usage);
        exitCode = 2;
        return;
      }

      // if arg -a/--aspect exists
      String aspectFile = parsedArgs['aspect'] ?? '';
      if (aspectFile.isNotEmpty) {
        print('Creating aspect file for the screen...');
        await Aspect.create(aspectFile);
      }

      // if arg -s/--screen exists
      String screenDir = parsedArgs['screen'] ?? '';
      if (screenDir.isNotEmpty) {
        print('Creating screen files...');
        screenDir = screenDir.toLowerCase().replaceAll('-', '_');
        await ScreenDirectory.create(screenDir);
        await ScreenState.create(screenDir);
        await ScreenService.create(screenDir);
        await Screen.create(
          screenDir,
          customScreenImports,
          errorWidget,
          progressWidget,
        );
        print('Creating model for the screen...');
        await AppModel.create(screenDir);
      }

      // if arg -m/--model exists
      String modelFile = parsedArgs['model'] ?? '';
      if (modelFile.isNotEmpty) {
        await AppModel.create(modelFile);
      }

      // if arg -u/--util exists
      bool utilFlag = parsedArgs['util'] ?? false;
      if (utilFlag) {
        print('Creating utils file for the project');
        String utilFileName = 'mustang_utils.dart';
        await UtilService.create(utilFileName, customSerializer);
      }

      // if arg -d/--clean exists
      bool cleanFlag = parsedArgs['clean'] ?? false;
      if (cleanFlag) {
        Utils.runProcess('flutter', [
          'pub',
          'run',
          'build_runner',
          'clean',
        ]);
      }

      // if arg -b/--build exists
      bool buildFlag = parsedArgs['build'] ?? false;
      if (buildFlag) {
        Utils.runProcess('flutter', [
          'pub',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs',
        ]);
        return;
      }

      // if arg -w/--watch exists
      bool watchFlag = parsedArgs['watch'] ?? false;
      if (watchFlag) {
        Utils.runProcess('flutter', [
          'pub',
          'run',
          'build_runner',
          'watch',
          '--delete-conflicting-outputs'
        ]);
        return;
      }
    } catch (e) {
      exitCode = 2;
      print(e.toString());
      print(parser.usage);
    }
  }
}
