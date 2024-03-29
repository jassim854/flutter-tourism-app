import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_routes.dart';
import 'package:flutter_tourism_app/utils/theme.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/booking_/car_view.dart';
import 'package:flutter_tourism_app/view/on_board_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:flutter_tourism_app/view/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>  ProviderScope(child: MyApp()))));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key,e});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cultural Guides by SMCCU',
      builder: EasyLoading.init(
        builder: (context, child) {
          EasyLoading.instance
            ..indicatorType = EasyLoadingIndicatorType.ring
            ..loadingStyle = EasyLoadingStyle.custom
            ..indicatorSize = 40
            ..radius = 10
            ..textColor = AppColor.textBlackColor
            ..backgroundColor = AppColor.surfaceBackgroundBaseDarkColor
            ..indicatorColor = AppColor.surfaceBrandDarkColor
            ..maskColor = AppColor.surfaceBrandDarkColor
            ..userInteractions = false
            ..dismissOnTap = false;

          return Container(
            child: child,
          );
        },
      ),
      initialRoute: SplashView.routeName,
      onGenerateRoute: AppRoutes.generateRoute,
      theme: appThemes(),
    );
  }
}
