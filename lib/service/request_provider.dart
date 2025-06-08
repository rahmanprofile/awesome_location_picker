import 'dart:convert'; // For decoding JSON responses
import 'package:http/http.dart'
    as http; // HTTP package to make network requests
import '../model/awesome_city.dart'; // Model class for City data
import '../model/awesome_country.dart'; // Model class for Country data
import '../model/awesome_state.dart'; // Model class for State data

class RequestProvider {
  // Base URL of the API server - all API requests will use this as the root URL
  static const String baseUrl = 'https://chat.jobkar.in';

  // Private named constructor to enforce singleton pattern
  const RequestProvider.__();

  // Singleton instance getter
  // This ensures only one instance of RequestProvider is used throughout the app
  static RequestProvider get instance => RequestProvider.__();

  /// Fetches the list of countries from the API.
  ///
  /// Makes a GET request to `https://chat.jobkar.in/countries`.
  /// Parses the JSON response, extracts the list of country data,
  /// and converts each JSON object into an AwesomeCountry model.
  ///
  /// Returns a `Future<List<AwesomeCountry>>` that completes with the list of countries.
  /// Throws an Exception if the request fails or JSON parsing fails.
  Future<List<Country>> fetchCountries() async {
    try {
      // Make the GET HTTP request to the countries endpoint
      final response = await http.get(
        Uri.parse('$baseUrl/countries'), // Construct the full URL
        headers: {
          // Headers to allow cross-origin requests and specify content type
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
          "Content-Type": "application/json",
        },
      );

      // Check if the HTTP status code indicates success (200 OK)
      if (response.statusCode == 200) {
        // Decode the JSON response body to a Dart Map
        final List data = json.decode(response.body)['data'];

        // Map each JSON object in the list to an AwesomeCountry instance
        return data.map((e) => Country.fromJson(e)).toList();
      } else {
        // If server returned an error status, throw an exception with message
        throw Exception('Failed to load countries');
      }
    } catch (err) {
      // Catch and rethrow any errors (network, parsing, etc)
      throw Exception(err);
    }
  }

  /// Fetches the list of states for a given country ID.
  ///
  /// Makes a GET request to `https://chat.jobkar.in/states/{countryId}`.
  /// Parses the JSON response, extracts the list of state data,
  /// and converts each JSON object into an AwesomeState model.
  ///
  /// Returns a `Future<List<AwesomeState>>` that completes with the list of states.
  /// Throws an Exception if the request fails.
  Future<List<States>> fetchStates(int countryId) async {
    // Make the GET HTTP request to the states endpoint with countryId path parameter
    final response = await http.get(
      Uri.parse('$baseUrl/states/$countryId'), // Construct URL with countryId
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Content-Type": "application/json",
      },
    );

    // Check for success status code
    if (response.statusCode == 200) {
      // Parse JSON and convert list to model objects
      final List data = json.decode(response.body)['data'];
      return data.map((e) => States.fromJson(e)).toList();
    } else {
      // Throw error if response is not successful
      throw Exception('Failed to load states');
    }
  }

  /// Fetches the list of cities for a given state ID.
  ///
  /// Makes a GET request to `https://chat.jobkar.in/cities/{stateId}`.
  /// Parses the JSON response, extracts the list of city data,
  /// and converts each JSON object into an AwesomeCity model.
  ///
  /// Returns a `Future<List<AwesomeCity>>` that completes with the list of cities.
  /// Throws an Exception if the request fails.
  Future<List<Cities>> fetchCities(int stateId) async {
    // Make GET request to cities endpoint with stateId path parameter
    final response = await http.get(
      Uri.parse('$baseUrl/cities/$stateId'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Content-Type": "application/json",
      },
    );

    // Check if the response was successful
    if (response.statusCode == 200) {
      // Decode JSON and convert list to AwesomeCity instances
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Cities.fromJson(e)).toList();
    } else {
      // Throw error if the request failed
      throw Exception('Failed to load cities');
    }
  }
}
