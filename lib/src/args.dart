import 'package:args/args.dart';

class Args {
  static ArgParser parser() {
    ArgParser parser = ArgParser();

    parser.addOption(
      'aspect',
      abbr: 'a',
      help: 'Creates an aspect in\n'
          '> lib/src/aspects/sample.dart\n',
      valueHelp: 'sample',
    );

    parser.addOption(
      'screen',
      abbr: 's',
      help: 'Creates screen files in\n'
          '> lib/src/screens/booking/new_user/new_user_service.dart\n'
          '> lib/src/screens/booking/new_user/new_user_state.dart\n'
          '> lib/src/screens/booking/new_user/new_user_screen.dart\n'
          'and a model in\n'
          '> lib/src/models/new_user.dart\n',
      valueHelp: 'booking/new_user',
    );

    parser.addOption(
      'model',
      abbr: 'm',
      help: 'Creates a model in\n'
          '> lib/src/models/vehicle.dart\n',
      valueHelp: 'vehicle',
    );

    parser.addFlag(
      'util',
      abbr: 'u',
      help: 'Generates util files',
      defaultsTo: false,
      negatable: false,
    );

    parser.addFlag(
      'build',
      abbr: 'b',
      help: 'Generates runtime files',
      defaultsTo: false,
      negatable: false,
    );

    parser.addFlag(
      'clean',
      abbr: 'd',
      help: 'Deletes runtime files',
      defaultsTo: false,
      negatable: false,
    );

    parser.addFlag(
      'watch',
      abbr: 'w',
      help: 'Monitors files for changes and re-generate runtime files',
      defaultsTo: false,
      negatable: false,
    );

    return parser;
  }
}
