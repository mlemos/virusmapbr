import 'package:ansicolor/ansicolor.dart';

// Logger helper class
// Use it to print log messages on the console.
// Messages are colored accordingly to the method used.
//
// Examples:
// Logger.red("You log message is here.");
// Logger.error("Error message is here.");

class Logger {

  static Map<String,int> colors = {
    "black": 8,
    "red": 9,
    "green": 10,
    "yellow": 11,
    "blue": 12,
    "magenta": 13,
    "cyan": 14,
    "white": 15,
  };

  static Map<String,String> levels = {
    "debug" : "blue",
    "info" : "green",
    "warn": "yellow",
    "error": "red",
    "fatal": "magenta",
  };

  static black(String msg) {
    _write(msg, "black", " ");
  }

  static red(String msg) {
    _write(msg, "red", " ");
  }

  static green(String msg) {
    _write(msg, "green", " ");
  }

  static yellow(String msg) {
    _write(msg, "yellow", " ");
  }

  static blue(String msg) {
    _write(msg, "blue", " ");
  }

  static magenta(String msg) {
    _write(msg, "magenta", " ");
  }

  static cyan(String msg) {
    _write(msg, "cyan", " ");
  }

  static white(String msg) {
    _write(msg, "white", " ");
  }

  static debug(String msg) {
    _write(msg, levels["debug"], "D");
  }

  static info(String msg) {
    _write(msg, levels["info"], "I");
  }

  static warn(String msg) {
    _write(msg, levels["warn"], "W");
  }

  static error(String msg) {
    _write(msg, levels["error"], "E");
  }

  static fatal(String msg) {
    _write(msg, levels["fatal"], "F");
  }

  static void _write(String msg, String color, String header) {
    AnsiPen pen = AnsiPen();
    pen
      ..reset()
      ..black()
      ..xterm(colors[color], bg:true);
    final ansiHeader = pen(header);

    pen
      ..reset()
      ..xterm(colors[color]);
    final now = "[${DateTime.now()}]";
    
    final output = ansiHeader + " " + pen(now) + " " + pen(msg);
    
    print(output);    
  }
}
