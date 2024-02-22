
import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/view/on_board_view.dart';


class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case OnBoardView.routeName:
        return MaterialPageRoute(builder: ((context) => const OnBoardView()));

      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text(" No Routes "),
              ),
            );
          },
        );
    }
  }
}