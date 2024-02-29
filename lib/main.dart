import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_routes.dart';
import 'package:flutter_tourism_app/utils/theme.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/on_board_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   String firstRouteName="";
 SharedPreferences preferences;  preferences=await SharedPreferences.getInstance();
  bool? value=  preferences.getBool("isFirstTime");
  if (value==false) {
    firstRouteName=  SelectCountryView.routeName;
  }else{
firstRouteName=OnBoardView.routeName;
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>  ProviderScope(child: MyApp(firstRouteName: firstRouteName,)))));
}

class MyApp extends StatelessWidget {
  final String firstRouteName;
  const MyApp({super.key, required this.firstRouteName});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tourist App',
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
      initialRoute: firstRouteName,
      onGenerateRoute: AppRoutes.generateRoute,
      theme: appThemes(),
    );
  }
}
