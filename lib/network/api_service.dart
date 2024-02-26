import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';
import 'package:flutter_tourism_app/model/dummy_model.dart';
import 'package:flutter_tourism_app/network/nerwork_helper.dart';

final apiServiceProvider = Provider<ApiServices>((ref) {
  return ApiServices();
});

class ApiServices {
  Future<List<DummyModel>?> getDummyList(context,
      {required Map<String, dynamic> data}) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response =
          await networkHelper.getDummyListApi(data: data);
      if (response.statusCode == 200) {
        return await compute(_convertResponseList, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  List<DummyModel> _convertResponseList(Response<dynamic> response) {
    return List.from(response.data.map((e) => DummyModel.fromJson(e)));
  }
}
