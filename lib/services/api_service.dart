import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.16:5000/api";

  /* ================= COMMON HEADERS ================= */
  static Map<String, String> _headers({String? token}) {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /* ================= GET JOBS (WITH SEARCH) ================= */

  static Future<List<dynamic>> getJobs({
    String query = "",
    String location = "",
    String exp = "",
    String salary = "", // ✅ ADD
    String workType = "",
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/jobs").replace(
        queryParameters: {
          if (query.isNotEmpty) "job": query,
          if (location.isNotEmpty && location != "Select Location")
            "location": location,
        },
      );

      final response = await http.get(uri, headers: _headers());

      print("GET JOBS URL: $uri");
      print("STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true && data["data"] != null) {
          List jobs = data["data"];

          // 🔥 FRONTEND FILTER
          jobs = jobs.where((job) {
            final title = (job["title"] ?? "").toString().toLowerCase();
            final skills = (job["skillsRequired"] ?? [])
                .join(" ")
                .toLowerCase();
            final jobLocation = (job["location"] ?? "")
                .toString()
                .trim()
                .toLowerCase();

            final q = query.toLowerCase();
            final loc = location.toLowerCase();

            bool matchQuery =
                q.isEmpty || title.contains(q) || skills.contains(q);

            bool matchLocation = loc.isEmpty || jobLocation == loc;

            return matchQuery && matchLocation;
          }).toList();

          return jobs;
        }
      }
    } catch (e) {
      print("❌ GET JOBS ERROR: $e");
    }

    return [];
  }

  /* ================= GET JOB BY ID ================= */
  static Future<Map<String, dynamic>?> getJobById(String id) async {
    try {
      final url = Uri.parse("$baseUrl/jobs/$id");

      final res = await http.get(url, headers: _headers());

      print("GET JOB DETAIL: $url");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data["success"] == true) {
          return data["data"];
        }
      }
    } catch (e) {
      print("❌ JOB DETAIL ERROR: $e");
    }

    return null;
  }

  /* ================= GET PROFILE ================= */
  static Future<Map<String, dynamic>?> getProfile(String token) async {
    try {
      final url = Uri.parse("$baseUrl/users/profile"); // 🔥 FIXED

      final res = await http.get(url, headers: _headers(token: token));

      print("GET PROFILE: $url");
      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data["success"] == true) {
          return data["data"];
        }
      } else {
        print("❌ PROFILE FAILED: ${res.body}");
      }
    } catch (e) {
      print("❌ PROFILE ERROR: $e");
    }

    return null;
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("LOGIN STATUS: ${res.statusCode}");
      print("LOGIN BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data["success"] == true) {
          return data;
        }
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
    }

    return null;
  }

  /* ================= UPDATE PROFILE ================= */
  static Future<bool> updateProfile({
    required String token,
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/auth/update-jobseeker-profile");

      final res = await http.put(
        url,
        headers: _headers(token: token),
        body: jsonEncode(body),
      );

      print("UPDATE PROFILE STATUS: ${res.statusCode}");
      print("UPDATE PROFILE BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data["success"] == true;
      }
    } catch (e) {
      print("❌ UPDATE PROFILE ERROR: $e");
    }

    return false;
  }
}
