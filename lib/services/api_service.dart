import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _apiKey = 'GS3OWOAevr6NZsv2XPGwow==SD1z40iXKOeUDT8L';

  Future<String> getFact() async {
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/facts'),
      headers: {'X-Api-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data[0]['fact'];
    } else {
      throw Exception('Failed to load fact');
    }
  }

  Future<String> getJoke() async {
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/jokes'),
      headers: {'X-Api-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data[0]['joke'];
    } else {
      throw Exception('Failed to load joke');
    }
  }

  Future<String> getQuote() async {
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes'),
      headers: {'X-Api-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return '${data[0]['quote']} - ${data[0]['author']}';
    } else {
      throw Exception('Failed to load quote');
    }
  }

  //api ini tidak terpakai
  Future<Map<String, double>> getCurrencyRates() async {
    final response = await http.get(
      Uri.parse('https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_7kV8JCxlE01wGg8F1uJG3V1gZCi5NFGuJZeonrFs&currencies=EUR%2CUSD%2CCAD%2CJPY%2CIDR%2CKRW'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Map<String, double> rates = {};
      data['data'].forEach((key, value) {
        rates[key] = value.toDouble();
      });
      return rates;
    } else {
      throw Exception('Failed to load currency rates');
    }
  }
}