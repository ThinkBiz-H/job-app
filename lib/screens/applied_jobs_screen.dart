import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/user_session.dart';
import 'job_detail_screen.dart'; // 🔥 ADD THIS

class AppliedJobsScreen extends StatefulWidget {
  const AppliedJobsScreen({super.key});

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  List jobs = [];
  bool loading = true;
  int page = 1;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchAppliedJobs();
  }

  Future<void> fetchAppliedJobs() async {
    final token = UserSession.user?["token"];

    if (token == null) {
      print("❌ TOKEN MISSING");
      return;
    }

    final res = await http.get(
      Uri.parse(
        "https://job-portal-fullstack-production.up.railway.app/api/api/applications/me?page=$page",
      ),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(res.body);

    // 🔥 SAFE CHECK
    if (data["success"] == true) {
      final list = data["data"] ?? [];

      setState(() {
        jobs.addAll(list);
        loading = false;

        if (list.length < 10) {
          hasMore = false;
        }
      });
    } else {
      setState(() => loading = false);
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "accepted":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "shortlisted":
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Applications")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
          ? const Center(child: Text("No Applications ❌"))
          : ListView.builder(
              itemCount: jobs.length + 1,
              itemBuilder: (context, i) {
                if (i == jobs.length) {
                  return hasMore
                      ? TextButton(
                          onPressed: () {
                            page++;
                            fetchAppliedJobs();
                          },
                          child: const Text("Load More"),
                        )
                      : const SizedBox();
                }

                final app = jobs[i];
                final job = app["job"] ?? {};

                final status = app["status"] ?? "pending";

                return GestureDetector(
                  onTap: () {
                    // 🔥 JOB DETAIL OPEN
                    if (job["_id"] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailScreen(job: job),
                        ),
                      );
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITLE + STATUS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  job["title"] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                    status,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: getStatusColor(status),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          /// COMPANY + LOCATION
                          Text(
                            "${job["companyName"] ?? ""} • ${job["location"] ?? ""}",
                          ),

                          const SizedBox(height: 6),

                          /// DATE SAFE
                          Text(
                            "Applied on: ${app["appliedAt"] != null ? DateTime.parse(app["appliedAt"]).toLocal().toString().split(" ")[0] : ""}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
