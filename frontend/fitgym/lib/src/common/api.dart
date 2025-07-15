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

  // Add Friend (protected)
  static Future<http.Response> addFriend(String friendEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.post(
      Uri.parse('$baseUrl/addFriend'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'friend_email': friendEmail}),
    );
  }

  // Get Friends (protected)
  static Future<http.Response> getFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.get(
      Uri.parse('$baseUrl/getFriends'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  // Update user profile (protected)
  static Future<http.Response> updateProfile(String name, int age) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.put(
      Uri.parse('$baseUrl/editProfile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'age': age}),
    );
  }

  // Add Workout (protected)
  static Future<http.Response> addWorkout(Map<String, dynamic> workout) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.post(
      Uri.parse('$baseUrl/addWorkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(workout),
    );
  }

  // Complete Workout (protected)
  static Future<http.Response> completeWorkout(String workoutId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.post(
      Uri.parse('$baseUrl/completeWorkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'workout_id': workoutId}),
    );
  }

  // Update Workout (protected)
  static Future<http.Response> updateWorkout({required String id, required String notes, required String date, required String type, required List exercises}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.put(
      Uri.parse('$baseUrl/editWorkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': id,
        'notes': notes,
        'date': date,
        'type': type,
        'exercises': exercises,
      }),
    );
  }

  // Delete Workout (protected)
  static Future<http.Response> deleteWorkout(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.delete(
      Uri.parse('$baseUrl/deleteWorkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id': id}),
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

  // Get user profile (protected)
  static Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['id'] != null) {
        await prefs.setString('user_id', data['id']);
      }
      return data;
    }
    return null;
  }

  // Get user_id from storage
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // Get all workouts (protected)
  static Future<http.Response> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.get(
      Uri.parse('$baseUrl/getWorkouts'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  // Get friend's workout history by email (protected)
  static Future<http.Response> getFriendWorkoutHistoryByEmail(String friendEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return http.get(
      Uri.parse('$baseUrl/getFriendWorkoutsByEmail?friend_email=$friendEmail'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
} 