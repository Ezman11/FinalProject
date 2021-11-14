import 'dart:convert';

import 'package:http/http.dart' as http;


class Api {
  static const BASE_URL = 'https://digimon-api.herokuapp.com/api';


  Future<dynamic> fetch(String endPoint,  {Map<String, dynamic>? params,}) async {
    var url = Uri.parse('$BASE_URL/$endPoint');

    final response = await http.get(url);


    if (response.statusCode == 200) {

      List<dynamic> jsonBody = json.decode(response.body);

      return jsonBody;

    } else {
      throw 'Server connection failed!';
    }
  }
}