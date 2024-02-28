import 'package:dio/dio.dart';
import 'package:flutter_tourism_app/utils/netwrk_end_points.dart';

class NetworkHelper {
  late Dio dio;

  NetworkHelper() {
    dio = Dio(BaseOptions(
           baseUrl: "http://188.166.150.139:8800/",
   
      // baseUrl: "https://picsum.photos/",
      // headers: {
      //   'Content-Type': 'application/json',
      //   // "Authorization": "Bearer ${BearerToken.getToken}",
      //   // if (AppLanguage.getLanguageCode != null)
      //   //   "Accept-Language": AppLanguage.getLanguageCode,
      // },
    ));
  }
  Future<Response> getDummyListApi({required Map<String, dynamic> data}) async {
    return await dio.get(NetworkEndPoints.dummyListApi, queryParameters: data);
  }

  Future<Response> getDummyDetail({required String id}) async {
    return await dio.get(
      "${NetworkEndPoints.dummyDetailApi}id/info",

    );
  }
  Future<Response> getAllCountryApi() async {
    return await dio.get(
      NetworkEndPoints.getAllCountriesEndPoint,
    );
  }
  Future<Response> getAllTourGuidesApi() async {
    return await dio.get(
      NetworkEndPoints.getAllTourGuideEndPoint,
    );
  }
  Future<Response> getCountryWiseTourGuideApi({required Map<String,dynamic> payLoad}) async {
    return await dio.get(
      NetworkEndPoints.getCountryWiseGuidEndPoint,
      data: payLoad
    );
  }
  Future<Response> getATourGuideApi({required Map<String,dynamic>payload}) async {
    return await dio.get(
      NetworkEndPoints.getTourGuideByIdEndPoint,
      data: payload
    );
  }

  Future<Response> postCreateBookingApi({required Map<String,dynamic>payLoad}) async {
    return await dio.post(
      NetworkEndPoints.postBookingEndPoint,
      data: payLoad,
    );
  }
    Future<Response> getUserBookingApi() async {
    return await dio.get(
      NetworkEndPoints.getUserBookingEndPoint,
    );
  }
     Future<Response> getBookingDetailApi() async {
    return await dio.get(
      NetworkEndPoints.getBookingDetailEndPoint,
    );
  }
}
