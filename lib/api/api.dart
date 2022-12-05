import 'dart:convert';

import 'package:movie_app/api/DioClient.dart';
import 'Constants.dart';

class TMDB {
  Future<List<Map<String, dynamic>>> getTrending(
      {type = 'all', time = 'week'}) async {
    final result = await DioClient.client
        .get('trending/$type/$time?api_key=${Constants.apiKey}');
    return List.castFrom<dynamic, Map<String, dynamic>>(result.data['results']);
  }

  Future<Map<String, dynamic>> getConfiguration() async {
    var result =
        await DioClient.client.get('configuration?api_key=${Constants.apiKey}');
    return result.data;
  }

  Future<Map<String, dynamic>> getDetails(id, type) async {
    var result =
        await DioClient.client.get('$type/$id?api_key=${Constants.apiKey}');
    return result.data;
  }

  Future<Map<String, dynamic>> getSeason(id, season) async {
    var result = await DioClient.client
        .get('tv/$id/season/$season?api_key=${Constants.apiKey}');
    return result.data;
  }

  Future<List<Map<String, dynamic>>> discover(type) async {
    var result = await DioClient.client
        .get('discover/$type?api_key=${Constants.apiKey}');

    return List.castFrom<dynamic, Map<String, dynamic>>(result.data['results']);
  }

  Future<Map<String, dynamic>> getImages(id, type) async {
    var result = await DioClient.client
        .get('$type/$id/images?api_key=${Constants.apiKey}');
    return jsonDecode(result.data);
  }
}
