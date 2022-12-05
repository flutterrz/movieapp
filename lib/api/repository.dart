import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/Configuration.dart';
import 'package:movie_app/model/Season.dart';
import 'package:movie_app/model/TMDBImage.dart';

import '../model/Movie.dart';

class TMDBRepository {
  final TMDB _client = TMDB();

  Future<List<Movie>> getTrending({type = 'all', time = 'week'}) async {
    return (await _client.getTrending(type: type, time: time))
        .map((item) => Movie.fromJson(item))
        .toList();
  }

  Future<Configuration> getConfiguration() async {
    return Configuration.fromJson(await _client.getConfiguration());
  }

  Future<Movie> getDetails(id, type) async {
    return Movie.fromJson(await _client.getDetails(id, type),
        medialType: type, details: true);
  }

  Future<Season> getSeason(id, season) async {
    return Season.fromJson(await _client.getSeason(id, season));
  }

  Future<List<Movie>> discover(type) async {
    return (await _client.discover(type))
        .map((item) => Movie.fromJson(item, medialType: type))
        .toList();
  }

  Future<TMDBImages> getImages(id, type) async {
    return TMDBImages.fromJson(await _client.getImages(id, type));
  }
}
