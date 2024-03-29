import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/on_board_view.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends ConsumerStatefulWidget {
  static const routeName="/splashView";
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
   String firstRouteName="";
  @override
  void initState() {
    checkIsFirst();
    Future.delayed(Duration(seconds: 2),(){
context.navigatepushReplacementNamed(firstRouteName);
    });
    // TODO: implement initState
    super.initState();
  }
checkIsFirst()async{
   
 SharedPreferences preferences;  preferences=await SharedPreferences.getInstance();
  bool? value=  preferences.getBool("isFirstTime");
  if (value==false) {
    firstRouteName=  SelectCountryView.routeName;
  }else{
firstRouteName=OnBoardView.routeName;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundColor,
      body: Center(
        child: AnimatedSize(duration: Duration(
        seconds: 1
        
        ),
        child: Padding(
   padding: const EdgeInsets.only(
                  left: 20, right: 20, ),
          child: SvgPicture.asset(AppAssets.appLogo),
        ),
        ),
      ),
    );
  }
}