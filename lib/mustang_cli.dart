import 'dart:io';

import 'package:args/args.dart';
import 'package:mustang_cli/src/app_model.dart';
import 'package:mustang_cli/src/args.dart';
import 'package:mustang_cli/src/screen.dart';
import 'package:mustang_cli/src/screen_directory.dart';
import 'package:mustang_cli/src/screen_service.dart';
import 'package:mustang_cli/src/screen_state.dart';
import 'package:mustang_cli/src/util_service.dart';
import 'package:mustang_cli/src/utils.dart';

class MustangCli {
  static void run(List<String> args) async {
    ArgParser parser = Args.parser();
    try {
      ArgResults parsedArgs = parser.parse(args);

      if (parsedArgs.arguments.isEmpty) {
        print(parser.usage);
        exitCode = 2;
        return;
      }

      // if arg -s/--screen exists
      String screenDir = parsedArgs['screen'] ?? '';
      if (screenDir.isNotEmpty) {
        print('Creating screen files...');
        screenDir = screenDir.toLowerCase().replaceAll('-', '_');
        await ScreenDirectory.create(screenDir);
        await ScreenState.create(screenDir);
        await ScreenService.create(screenDir);
        await Screen.create(screenDir);
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
        await UtilService.create(utilFileName);
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
