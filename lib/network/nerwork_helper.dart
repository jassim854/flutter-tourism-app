import 'package:dio/dio.dart';
import 'package:flutter_tourism_app/utils/netwrk_end_points.dart';

class NetworkHelper {
  late Dio dio;

  NetworkHelper() {
    dio = Dio(BaseOptions(
      baseUrl: "https://picsum.photos/",
      headers: {
        'Content-Type': 'application/json',
        // "Authorization": "Bearer ${BearerToken.getToken}",
        // if (AppLanguage.getLanguageCode != null)
        //   "Accept-Language": AppLanguage.getLanguageCode,
      },
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
}
