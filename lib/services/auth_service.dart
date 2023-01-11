
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyB0VpeAmv_9PokQ57DGBZ15BUz7neB5QE0';

  Future<String?> createUser(String email, String password) async{

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, "/v1/accounts:signUp", {
      'key': _firebaseToken
    });

    print(url);

    final resp = await http.post(url, body: json.encode(authData));

    print(resp.body);

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if( decodedResp.containsKey('idToken')) {
      // Grabar en un lugar seguro
     // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }

  }

  Future<String?> login(String email, String password) async{

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, "/v1/accounts:signInWithPassword", {
      'key': _firebaseToken
    });



    final resp = await http.post(url, body: json.encode(authData));



    final Map<String, dynamic> decodedResp = json.decode(resp.body);

      print(decodedResp);
    if( decodedResp.containsKey('idToken')) {
      // Grabar en un lugar seguro
      // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }

  }



}