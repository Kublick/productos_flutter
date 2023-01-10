import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-60358-default-rtdb.firebaseio.com';
  final List<Product> products = [];

  late Product selectedProduct;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

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

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;

    if (product.id == null) {
      await createProduct(product);
//crear
    } else {
      // update
      updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/${product.id}.json');
    await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodeData = json.decode(resp.body);

    product.id = decodeData['name'];

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dje4i7fik/image/upload?upload_preset=wwxonarv');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('algo salio mal');
      print(response.body);
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(response.body);
    return decodedData['secure_url'];
  }
}
