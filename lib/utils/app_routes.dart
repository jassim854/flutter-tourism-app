import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/model/network_model/dummy_model.dart';
import 'package:flutter_tourism_app/model/network_model/tour_guide_model.dart';

import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/booking_/booking_detail_view.dart';
import 'package:flutter_tourism_app/view/booking_/booking_view.dart';
import 'package:flutter_tourism_app/view/home_/book_view.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';

import 'package:flutter_tourism_app/view/on_board_view.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case OnBoardView.routeName:
        return MaterialPageRoute(builder: ((context) => const OnBoardView()));
      case AppBottomNavigationBar.routeName:
        return MaterialPageRoute(
            builder: ((context) => const AppBottomNavigationBar()));
      case HomeView.routeName:
        return MaterialPageRoute(builder: ((context) => const HomeView()));
      case SelectCountryView.routeName:
        return MaterialPageRoute(
            builder: ((context) => const SelectCountryView()));
      case HomeDetailView.routeName:
        return MaterialPageRoute(builder: ((context) {
          TourGuidModel data = setting.arguments as TourGuidModel;
          return HomeDetailView(
            data: data,
          );
        }));
      case BookingView.routeName:
        return MaterialPageRoute(builder: ((context) => const BookingView()));
      // case BookingDetailView.routeName:
      //   return MaterialPageRoute(
      //       builder: ((context) => const BookingDetailView()));
   case BookView.routeName:
        return MaterialPageRoute(builder: ((context) {
 
          return BookView(
      
          );
        }));
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
