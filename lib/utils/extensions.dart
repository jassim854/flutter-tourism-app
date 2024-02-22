import 'package:flutter/material.dart';


extension SpaceExtension on num {
  height() {
    return SizedBox(
      height: toDouble(),
    );
  }

  width() {
    return SizedBox(
      width: toDouble(),
    );
  }
}

extension NavigationExtensions on BuildContext {
  void popPage({Object? result}) {
    return Navigator.of(this).pop(result);
  }

  void multiPopPage({required int popPageCount, Object? result}) {
    switch (popPageCount) {
      case 2:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 3:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 4:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 5:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 6:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      case 7:
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        Navigator.of(this).pop(result);
        break;
      default:
        return;
    }
  }

  Future<bool> maybePopPage({Object? result}) {
    return Navigator.of(this).maybePop(result);
  }

  void navigateTo(
    Widget screen,
  ) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  void navigatepushReplacement(Widget screen) {
    Navigator.of(this).pushReplacement(MaterialPageRoute(
      builder: (context) => screen,
    ));
  }

  void navigateToRemovedUntil(Widget screen) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => route.isFirst,
    );
  }
}

extension DynanicSizeExtension on BuildContext {
  double get dynamicHeight => MediaQuery.of(this).size.height;

  double get dynamicWidth => MediaQuery.of(this).size.width;
  Size get dynamicSize => MediaQuery.of(this).size;
}

extension HideKeypad on BuildContext {
  void hideKeypad() => FocusScope.of(this).unfocus();
}

extension OmitSymbolText on String {
  // getTextAfterSymbol() {
  //   int atIndex = indexOf('-');
  //   int lastAtIndex = lastIndexOf('-');

  //   if (atIndex != -1 && atIndex == lastAtIndex) {
  //     return substring(atIndex + 1);
  //   } else {
  //     return "";
  //   }
  // }

  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  // removeSymbolGetText() {
  //   int atIndex = indexOf('-');

  //   return "${substring(0, atIndex).capitalizeFirst()} ${substring(atIndex + 1).capitalizeFirst()}";
  // }
}

extension ImageExtension on int {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}

extension HMSextension on int {
  String get mordernDurationTextWidget =>
      "${Duration(seconds: this).inHours.remainder(60).toString()}:${Duration(seconds: this).inMinutes.remainder(60).toString().padLeft(2, '0')}:${Duration(seconds: this).inSeconds.remainder(60).toString().padLeft(2, '0')}";
}

