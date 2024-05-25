// api_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRepository {
  Future<List<String>> fetchUniqueCategories() async {
    try {
      // Attempt to fetch data from the API
      final response = await http.get(Uri.parse('https://dummyjson.com/products'));

      // Log the status code of the response for debugging purposes
      print('Response Status Code: ${response.statusCode}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        var jsonResponse = jsonDecode(response.body);

        // Extract the products from the response
        var products = jsonResponse['products'] as List<dynamic>;

        // Collect all categories from the products and cast them to String
        var allCategories = products.map((product) => product['category'] as String).toList();

        // Convert the iterable to a list to remove duplicates
        var uniqueCategories = allCategories.toSet().toList();

        // Log the extracted unique categories for debugging purposes
        print('Extracted Unique Categories: $uniqueCategories');

        // Return the unique categories
        return uniqueCategories;
      } else {
        // Throw an exception if the request was not successful
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Catch any exceptions thrown during the process
      print('Error fetching unique categories: $e');
      // Optionally, rethrow the exception to be handled by the caller
      rethrow;
    }
  }

   Future<List<dynamic>> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var products = jsonResponse['products'] as List<dynamic>;
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  } catch (e) {
    print('Error fetching products: $e');
    rethrow;
  }
}

}
