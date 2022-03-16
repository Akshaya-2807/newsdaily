import 'dart:convert';
import 'dart:core';
import 'package:newsdaily/ui/homePage.dart';

import '../model/tesla_model.dart';
import 'package:http/http.dart' as http;

class TeslaRepository {
  Future<TeslaNewsModel> data() async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=${HomePageState.type}&from=2022-02-16&sortBy=publishedAt&apiKey=2339f23b50744da5be454502d858dffb"));

    return TeslaNewsModel.fromJson(json.decode(response.body));
  }
}
