import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';
import 'package:flutter_tourism_app/model/network_model/country_model.dart';
import 'package:flutter_tourism_app/model/network_model/dummy_model.dart';
import 'package:flutter_tourism_app/model/network_model/tour_guide_model.dart';
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
        return await compute(_convertDummyModelResponseList, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  List<DummyModel> _convertDummyModelResponseList(Response<dynamic> response) {
    return List.from(response.data.map((e) => DummyModel.fromJson(e)));
  }
   Future<List<CountryModel>?> getAllcountriesRequest(context,
     ) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response =
          await networkHelper.getAllCountryApi();
      if (response.statusCode == 200) {
        return await compute(_convertCountryModelResponseList, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  List<CountryModel> _convertCountryModelResponseList(Response<dynamic> response) {
    return List.from(response.data.map((e) => CountryModel.fromJson(e)));
  }
     Future<List<TourGuidModel>?> getCountryWiseTourGuideRequest(context,{required Map<String,dynamic>payload}
     ) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response =
          await networkHelper.getCountryWiseTourGuideApi(payLoad: payload);
      if (response.statusCode == 200) {
        return await compute(_convertTourGuideResponseList, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  List<TourGuidModel> _convertTourGuideResponseList(Response<dynamic> response) {
    return List.from(response.data.map((e) => TourGuidModel.fromJson(e)));
  }
}
