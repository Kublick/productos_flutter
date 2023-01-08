import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-60358-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;

  ProductsService() {
    loadProducts();
  }

// <List<Product>>
  Future<List<Product>> loadProducts() async {
    isLoading = true;

    notifyListeners();

    final url = Uri.https(_baseUrl, '/products.json');

    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }
}
