import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';
import 'package:flutter_tourism_app/model/network_model/a_tour_guide_model.dart';
import 'package:flutter_tourism_app/model/network_model/country_model.dart';
import 'package:flutter_tourism_app/model/network_model/dummy_model.dart';
import 'package:flutter_tourism_app/model/network_model/tour_guide_model.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/model/network_model/user_detail_booking_model.dart';
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

  Future<List<CountryModel>?> getAllcountriesRequest(
    context,
  ) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response = await networkHelper.getAllCountryApi();
      if (response.statusCode == 200) {
        return await compute(_convertCountryModelResponseList, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  List<CountryModel> _convertCountryModelResponseList(
      Response<dynamic> response) {
    return List.from(response.data.map((e) => CountryModel.fromJson(e)));
  }

  Future<List<TourGuidModel>?> getCountryWiseTourGuideRequest(context,
      {required Map<String, dynamic> payload}) async {
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

  List<TourGuidModel> _convertTourGuideResponseList(
      Response<dynamic> response) {
    return List.from(response.data.map((e) => TourGuidModel.fromJson(e)));
  }

  Future<List<ATourGuideModel>?> getATourGuideRequest(context,
      {required Map<String, dynamic> payload}) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response =
          await networkHelper.getATourGuideApi(payload: payload);
      if (response.statusCode == 200) {
        return await compute(_convertATourGuideResponseList, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  List<ATourGuideModel> _convertATourGuideResponseList(
      Response<dynamic> response) {
    List<Map<String, dynamic>> newData = [];

    newData.add({
      "id": response.data[0]["id"],
      "name": response.data[0]["name"],
      "description": response.data[0]["description"],
      "location": response.data[0]["location"],
      "status": response.data[0]["status"],
      "images": List<String>.from(response.data[0]["images"].map((x) => x)),
      "similarTourGuides": List<dynamic>.from(
          response.data[1]["similar_tour_guides"].map((x) => x)),
    });
    return List.from(newData.map((e) => ATourGuideModel.fromJson(e)));
    // return List.from(response.data.map((e) => ATourGuideModel.fromJson(e[0])));
  }

  Future<String?> postBookRequest(context,
      {required Map<String, dynamic> payload}) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response =
          await networkHelper.postCreateBookingApi(payLoad: payload);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode==400) {
           BaseHelper.showSnackBar(context, "Tour guide is already booked for this time slot on this day.");
      }else{
         BaseHelper.showSnackBar(context, e.message);
      }
   
    }
    return null;
  }


  Future<List<UserBookedModel>?> getUserBookedRequest(context,
      {required Map<String, dynamic> payload}) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response =
          await networkHelper.getUserBookingApi(payLoad: payload);
      if (response.statusCode == 200) {
        return await compute(_convertUserBookeResponseList, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }
  List<UserBookedModel> _convertUserBookeResponseList(
      Response<dynamic> response) {
    return List.from(response.data.map((e) => UserBookedModel.fromJson(e)));
  }
  Future<UserDetailBookedModel?> getUserDetailBookedRequest(context,
      {required Map<String, dynamic> payload}) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();
      Response<dynamic> response =
          await networkHelper.getBookingDetailApi(payLoad: payload);
      if (response.statusCode == 200) {
            return UserDetailBookedModel.fromJson(response.data);
        // return await compute(_convertUserDetailBookeResponse, response);
      }
    } on DioException catch (e) {
      BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }
  UserDetailBookedModel _convertUserDetailBookeResponse(
      Response<dynamic> response) {
    return UserDetailBookedModel.fromJson(response.data);
  }

}
