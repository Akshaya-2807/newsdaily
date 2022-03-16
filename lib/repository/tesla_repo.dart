import 'dart:convert';
import 'dart:core';
import '../model/tesla_model.dart';
import 'package:http/http.dart' as http;

class TeslaRepository {
  Future<TeslaNewsModel> data() async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=tesla&from=2022-02-15&sortBy=publishedAt&apiKey=1076af0f6c9a4f96a2a8d2c4863eb01d"));

    return TeslaNewsModel.fromJson(json.decode(response.body));
  }
}
