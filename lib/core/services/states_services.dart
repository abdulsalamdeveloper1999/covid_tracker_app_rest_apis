import 'dart:convert';

import 'package:covid_tracker/core/models/world_states_model.dart';
import 'package:covid_tracker/core/services/utilities/app_uri.dart';
import 'package:http/http.dart' as http;

class StatesSevices {
  Future<WorldStatesModel> fetchWorldStatesApi() async {
    var response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<dynamic> fetchCountryStatesApi() async {
    // ignore: prefer_typing_uninitialized_variables
    var data;
    var response = await http.get(Uri.parse(AppUrl.countriesApi));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());

      return data;
    } else {
      throw Exception('Error');
    }
  }
}
