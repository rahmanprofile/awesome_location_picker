import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/awesome_city.dart';
import '../model/awesome_country.dart';
import '../model/awesome_state.dart';

class RequestProvider {
  static const String baseUrl = 'https://chat.jobkar.in';

  const RequestProvider.__();
  static RequestProvider get instance => RequestProvider.__();

  Future<List<AwesomeCountry>> fetchCountries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/countries'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        return data.map((e) => AwesomeCountry.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<List<AwesomeState>> fetchStates(int countryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/states/$countryId'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => AwesomeState.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load states');
    }
  }

  Future<List<AwesomeCity>> fetchCities(int stateId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cities/$stateId'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => AwesomeCity.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
