import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../model/awesome_city.dart';
import '../model/awesome_country.dart';
import '../model/awesome_state.dart';

class RequestProvider {
  static const String baseUrl = 'http://chat.jobkar.in';

  const RequestProvider.__();
  static RequestProvider get instance => RequestProvider.__();

  /// Fetch Countries
  Future<List<AwesomeCountry>> fetchCountries() async {
   try {
     final response = await http.get(
         Uri.parse('http://chat.jobkar.in/countries'),
         headers: {
           "Content-Type": "application/json"
         }
     );

     log('response: ${response.body}');
     if (response.statusCode == 200) {
       final List data = json.decode(response.body)['data'];
       return data.map((e) => AwesomeCountry.fromJson(e)).toList();
     } else {
       throw Exception('Failed to load countries');
     }
   } catch (err, st) {
     log('view issue..: $st');
     throw Exception(err);
   }
  }

  /// Fetch States by country_id
  Future<List<AwesomeState>> fetchStates(int countryId) async {
    final response = await http.get(Uri.parse('$baseUrl/states/$countryId'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => AwesomeState.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load states');
    }
  }

  /// Fetch Cities by state_id
  Future<List<AwesomeCity>> fetchCities(int stateId) async {
    final response = await http.get(Uri.parse('$baseUrl/cities/$stateId'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => AwesomeCity.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
