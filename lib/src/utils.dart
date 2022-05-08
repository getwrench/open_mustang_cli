import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

class Utils {
  static String defaultAspectPrefix = 'lib/src/aspects';
  static String defaultScreenPrefix = 'lib/src/screens';
  static String defaultModelPrefix = 'lib/src/models';
  static String defaultUtilsPrefix = 'lib/src/utils';

  static String class2File(String className) {
    RegExp exp = RegExp(r'(?<=[0-9a-z])[A-Z]');
    return className
        .replaceAllMapped(exp, (Match m) => '_' + (m.group(0) ?? ''))
        .toLowerCase();
  }

  static String classNameToVar(String className) {
    String firstLetter = className.substring(0, 1).toLowerCase();
    return '$firstLetter${className.substring(1)}';
  }

  static String pathToClass(String path) {
    String screenDirName = p.basename(path);
    List<String> tokens = screenDirName.split('_');
    return tokens
        .map((token) {
          String firstLetter = token.substring(0, 1).toUpperCase();
          return '$firstLetter${token.substring(1)}';
        })
        .toList()
        .join('');
  }

  static void runProcess(String cmd, List<String> args) async {
    Process proc = await Process.start(
      cmd,
      args,
      runInShell: Platform.isWindows, // runInShell only in Windows
    );
    proc.stdout.transform(utf8.decoder).listen(
          (data) => stdout.write(data),
          onError: (error) => stdout.write(error),
        );
    proc.stderr.transform(utf8.decoder).listen(
          (data) => stdout.write(data),
          onError: (error) => stdout.write(error),
        );
  }

  static String pkgName() {
    return 'package:${p.basename(p.current)}';
  }

  static bool isMustangProject() {
    return File(p.absolute(Directory.current.path, 'mustang.yaml'))
        .existsSync();
  }

  static String getProjectRoot() {
    if (File(p.absolute(Directory.current.path, 'pubspec.yaml')).existsSync()) {
      return p.absolute(Directory.current.path);
    }
    return '';
  }

  static String generateRandomString(int len) {
    Random random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    return List.generate(len, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
