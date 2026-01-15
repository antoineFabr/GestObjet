import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => "ApiException: $message (code: $statusCode)";
}

class ApiClient {
  final String baseUrl = "https://gestobjet-b5ewbzgxhcd4dzd2.switzerlandnorth-01.azurewebsites.net/api";

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(uri, headers: _headers);

      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      print(response.body);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null
      );
      print(response.body);
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        _getMessageFromStatusCode(response.statusCode),
        statusCode: response.statusCode,
      );
    }
  }
}

ApiException _handleError(dynamic error) {
  if (error is SocketException) {
    return ApiException("pas de connexion a internet ou serveur introuvable");
  } else if (error is FormatException) {
    return ApiException("Format de réponse incorrecte (pas du json)");
  } else if (error is ApiException) {
    return error;
  } else {
    return ApiException("Une erreur inattendue est survenue: $error");
  }
}

String _getMessageFromStatusCode(int code) {
  switch (code) {
    case 400:
      return "Requête invalide.";
    case 401:
      return "Non autorisé. Connectez-vous.";
    case 403:
      return "Accès interdit.";
    case 404:
      return "Ressource introuvable.";
    case 500:
      return "Erreur interne du serveur.";
    default:
      return "Erreur inconnue ($code).";
  }
}
