import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080'; 

  // Registration
  static Future<http.Response> register(String email, String password) {
    return http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  // Login
  static Future<http.Response> login(String email, String password) {
    return http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  // Get workout history (protected)
  static Future<http.Response> getWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.get(
      Uri.parse('$baseUrl/getWorkoutHistory'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  // Save tokens
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Refresh token
  static Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      body: {'refresh_token': refreshToken},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveTokens(data['access_token'], data['refresh_token']);
    }
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }
} 