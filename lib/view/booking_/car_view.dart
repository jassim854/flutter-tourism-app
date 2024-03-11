// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_tourism_app/model/network_model/car_model.dart';
// import 'package:flutter_tourism_app/network/api_service.dart';
// import 'package:flutter_tourism_app/provider/car_provider.dart';
// import 'package:flutter_tourism_app/provider/genearl_providers.dart';
// import 'package:flutter_tourism_app/provider/select_country_provider.dart';
// import 'package:flutter_tourism_app/utils/app_colors.dart';
// import 'package:flutter_tourism_app/utils/app_typography.dart';
// import 'package:flutter_tourism_app/utils/extensions.dart';
// import 'package:flutter_tourism_app/view/home_/book_view.dart';
// import 'package:flutter_tourism_app/widgets/book_bottom_sheet.dart';
// import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
// import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
// import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CarView extends ConsumerStatefulWidget {
//   static const routeName='/carView';
//   final Map<String,dynamic> data;
//   const CarView(this.data, {super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _CarViewState();
// }

// class _CarViewState extends ConsumerState<CarView> {
//   @override
//   void initState() {
//   WidgetsBinding.instance.addPostFrameCallback((_) { 
//       callApi();
//   });
//     // TODO: implement initState
//     super.initState();
//   }
// callApi()async{
//   ref.read(isLoadingProvider.notifier).state=true;
//   await ref.read(apiServiceProvider).getCarListdRequest(context,payload: {
//     "country":ref.read(selectedCountryProvider)?.countryName
//   }).then((value) {
//     if (value!=null) {
   
//       ref.read(carListDataProvider.notifier).addValue(value);
//           ref.read(isLoadingProvider.notifier).state=false;
//     }else{
//           ref.read(isLoadingProvider.notifier).state=false;
//     }
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     List<CarModel>? carData=ref.watch(carListDataProvider);
//     double amount=ref.watch(totalAmountProvider);
//     CarModel? selectedCar=ref.watch(selectedCarProvider);
//     return Scaffold(
//       backgroundColor: AppColor.surfaceBackgroundColor,
//       appBar:  AppBarWidget(
//         onTap: (){
//           context.maybePopPage();
//         },
    
//         title: "Book your Car"),
// body: ref.watch(isLoadingProvider)? const Center(child: CupertinoActivityIndicator(radius: 30),): carData?.length==0? Center(child: Text("No car available",style: AppTypography.title24XL,)):Column(
//   children: [

//     Expanded(
//       child: ListView.separated(
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: (){
// ref.read(selectedCarProvider.notifier).state=carData[index];
      
        
//             },
//             child: CarCardWidget(name: carData![index].carName, totalAmount: amount.toString(), image: carData![index].imagePath, perHourAmount: carData![index].price, currencyIn: carData[index].currency, data: widget.data,  selectedCar: selectedCar,)
            
//             );
//         // return ListTile(
//         //   selected: selectedCar!=null,
//         //   selectedTileColor: selectedCar?.carName==carData?[index].carName?Colors.green.withOpacity(0.5):null,
//         //   onTap: (){
//         //     ref.read(selectedCarProvider.notifier).state=carData![index];
//         // ref.read(totalAmountProvider.notifier).state=    calculateTotalAmount(double.parse(carData[index].price), widget.data["start_time"], widget.data["end_time"]);
//         //   },
//         //   leading: CircleAvatar(
//         //     child: cacheNetworkWidget(context, imageUrl: carData?[index].imagePath??""),
//         //   ),
//         //   trailing: amount!=0? Column(
//         //     crossAxisAlignment: CrossAxisAlignment.end,
//         //  mainAxisAlignment: MainAxisAlignment.center,
//         //     children: [
//         //       const Text("Total Amount"),
//         //       Text("${amount.toStringAsFixed(0)} ${carData?[index].currency} ")
//         //     ],
//         //   ):null,
//         //   title: Text(carData?[index].carName??"",style: AppTypography.label16MD,),
//         //   subtitle:  Text("${carData?[index].price} ${carData?[index].currency} per/hour",style: AppTypography.label16MD,),
//         // );
//       }, separatorBuilder: (context, index) {
//         return const Divider();
//       }, itemCount: carData?.length??0),
//     ),
// Padding(
// padding: const EdgeInsets.all(20),
//   child: Row(
//     children: [
//       Expanded(child: CustomElevatedButton(onPressed: (){
//         context.popPage();
//       },title:"Back" ,)),
//      if(selectedCar!=null)...[ 20.width(),
//   Expanded(child: CustomElevatedButton(onPressed: ()async{
//     Map<String,dynamic>newData=widget.data;
//     newData.addAll({
//       "book_car":"True",
//       "car_id":selectedCar.id
//     });
//         //  confirmBookingSheetWidget(context,
//         //                                   selectedDate: DateFormat("yyyy-MM-dd").parse(newData["date"]),
//         //                                   selectedFromTime: DateFormat("H:m:s").parse(newData["start_time"]),
//         //                                   selectedToTime: DateFormat("H:m:s").parse(newData["end_time"]),
//         //                                   name: widget.data["username"]);
//         await ref
//                                       .read(apiServiceProvider)
//                                       .postBookRequest(context,
//                                           payload: newData)
//                                       .then((value) async {
//                                     if (value
//                                             ?.toLowerCase()
//                                             .contains("booked") ??
//                                         false) {
//                                       SharedPreferences pre =
//                                           await SharedPreferences.getInstance();
//                                       pre.setString(
//                                         "email",
//                                     widget.data["user_email"]
//                                       );
                                    
//                                       confirmBookingSheetWidget(context,
//                                           selectedDate: DateFormat("yyyy-MM-dd").parse(newData["date"]),
//                                           selectedFromTime: DateFormat("H:m:s").parse(newData["start_time"]),
//                                           selectedToTime: DateFormat("H:m:s").parse(newData["end_time"]),
//                                           name: widget.data["username"]);
//                                     } else {
//                                       context.popPage();
//                                     }
//                                   });
                              
//   }, title:"Confirm Booking" ,))]
//     ],
//   ),
// )


//   ],
// ),
//     );
//   }
// }

// class CarCardWidget extends StatelessWidget {
//   Map<String,dynamic> data;
//   CarModel? selectedCar;

//   final String name ,totalAmount,image,perHourAmount,currencyIn;
//    CarCardWidget({super.key,  this.selectedCar, required this.data, required this.name, required this.totalAmount, required this.image, required this.perHourAmount,  required this.currencyIn});
// double calculateTotalAmount(double perHourRate, String startTime, String endTime) {
//   // Parse start time and end time
//   List<int> start = startTime.split(':').map(int.parse).toList();
//   List<int> end = endTime.split(':').map(int.parse).toList();

//   // Convert hours, minutes, and seconds to seconds
//   int startInSeconds = start[0] * 3600 + start[1] * 60 + start[2];
//   int endInSeconds = end[0] * 3600 + end[1] * 60 + end[2];

//   // Calculate total time in seconds
//   int totalTimeInSeconds = endInSeconds - startInSeconds;

//   // Calculate total amount
//   double totalAmount = (totalTimeInSeconds / 3600) * perHourRate;

//   return totalAmount;
// }
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       color: AppColor.surfaceBackgroundColor,
//       surfaceTintColor: AppColor.surfaceBackgroundColor,
//       child: Stack(

//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       color: AppColor.surfaceBackgroundBaseDarkColor,
//                       border: Border.all(
//                           width: 0.1, color: AppColor.surfaceBrandPrimaryColor),
//                       borderRadius: BorderRadius.circular(16)),
//                   height: 200,
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: cacheNetworkWidget(context,
//                           imageUrl: image, fit: BoxFit.cover)),
//                 ),
//                 8.height(),
              
//                 // const RattingWiget(),
//                 // 8.height(),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                           Text(
//                   name,
//                   style: AppTypography.label18LG,
//                 ),
//                 8.height(),
//                         Row(
//                           children: [
                            
//                         Text(
//                            currencyIn,
//                               style: AppTypography.label14SM.copyWith(color: AppColor.textBrandSecondaryColor),
//                             ),
//                             8.width(),
//                             // const Icon(Icons.location_on_outlined),
//                             // 8.width(),
//                             Text(
//                           "$perHourAmount per/hour",
//                               style: AppTypography.paragraph16LG,
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
          
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end  ,
//                       children: [
//                         Text("TotalAmount",  style: AppTypography.label14SM,),
//                         15.height(),
                
                        
          
//                         Text("${calculateTotalAmount(double.parse(perHourAmount),data["start_time"], data["end_time"]).toStringAsFixed(0)} $currencyIn",  style: AppTypography.paragraph16LG,)
//                       ],
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//        if(selectedCar!=null&&selectedCar?.carName==name)
//         Row(
//           children: [
//             Icon(Icons.check_circle,color: AppColor.surfaceBrandPrimaryColor,),
//           ],
//         )
        
//         ],
//       ),
//     );
//   }
// }