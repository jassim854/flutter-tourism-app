import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/car_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/car_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/select_country_provider.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';

class CarView extends ConsumerStatefulWidget {
  static const routeName='/carView';
  const CarView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CarViewState();
}

class _CarViewState extends ConsumerState<CarView> {
  @override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_) { 
      callApi();
  });
    // TODO: implement initState
    super.initState();
  }
callApi()async{
  ref.read(isLoadingProvider.notifier).state=true;
  await ref.read(apiServiceProvider).getCarListdRequest(context,payload: {
    "country":ref.read(selectedCountryProvider)
  }).then((value) {
    if (value!=null) {
   
      ref.read(carListDataProvider.notifier).addValue(value);
          ref.read(isLoadingProvider.notifier).state=false;
    }else{
          ref.read(isLoadingProvider.notifier).state=false;
    }
  });
}
  @override
  Widget build(BuildContext context) {
    List<CarModel>? carData=ref.watch(carListDataProvider);
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundColor,
      appBar: AppBarWidget(title: "Book your Car"),
body: ref.watch(isLoadingProvider)? Center(child: CupertinoActivityIndicator(radius: 30),): Column(
  children: [

    Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: cacheNetworkWidget(context, imageUrl: carData?[index].imagePath??""),
          ),
          title: Text(carData?[index].carName??"",style: AppTypography.label16MD,),
          subtitle:  Text("${carData?[index].price} ${carData?[index].currency}",style: AppTypography.label16MD,),
        );
      }, separatorBuilder: (context, index) {
        return Divider();
      }, itemCount: carData?.length??0),
    ),

CustomElevatedButton(onPressed: (){},title: "Done",)

  ],
),
    );
  }
}