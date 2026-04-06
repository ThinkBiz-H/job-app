// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../utils/user_session.dart';

// class JobDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> job;

//   const JobDetailScreen({super.key, required this.job});

//   @override
//   State<JobDetailScreen> createState() => _JobDetailScreenState();
// }

// class _JobDetailScreenState extends State<JobDetailScreen> {
//   Map<String, dynamic> job = {};
//   bool isLoading = true;
//   bool applying = false;
//   bool hasApplied = false;
//   bool showQuestions = false;
//   bool isSubmittingAnswers = false;
//   Map answers = {};
//   @override
//   void initState() {
//     super.initState();
//     checkIfApplied(); // 🔥 pehle ye
//     fetchJobDetail();
//   }

//   String salaryText() {
//     final s = job['salary'];
//     if (s == null) return "";
//     return "₹ ${s['min']} - ₹ ${s['max']}";
//   }

//   Widget sectionTitle(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.black, // 🔥 force black
//         ),
//       ),
//     );
//   }

//   Future<void> handleApply() async {
//     final token = UserSession.user?["token"];

//     if (token == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login first ❌")));
//       return;
//     }

//     // Screening questions check
//     if ((job["screeningQuestions"] ?? []).isNotEmpty && !isSubmittingAnswers) {
//       setState(() => showQuestions = true);
//       return;
//     }

//     try {
//       setState(() => applying = true);

//       final formattedAnswers = answers.entries.map((e) {
//         return {"questionId": e.key, "answer": e.value};
//       }).toList();

//       final res = await http.post(
//         Uri.parse("https://job-portal-fullstack-production.up.railway.app/api/api/jobs/${job["_id"]}/apply"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({"answers": formattedAnswers}),
//       );

//       print("STATUS: ${res.statusCode}");
//       print("BODY: ${res.body}");

//       final data = jsonDecode(res.body);

//       // 🔥 MAIN FIX HERE
//       if (data["success"] == true || data["message"] == "Already applied") {
//         setState(() => hasApplied = true);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data["message"] ?? "🎉 Applied Successfully")),
//         );
//       } else {
//         // optional error
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data["message"] ?? "Something went wrong ❌")),
//         );
//       }
//     } catch (e) {
//       print("ERROR: $e");

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Server error ❌")));
//     } finally {
//       setState(() {
//         applying = false;
//         isSubmittingAnswers = false;
//       });
//     }
//   }

//   Future<void> checkIfApplied() async {
//     final token = UserSession.user?["token"];

//     if (token == null) return;

//     final res = await http.get(
//       Uri.parse("https://job-portal-fullstack-production.up.railway.app/api/api/jobs/my-applications"),
//       headers: {"Authorization": "Bearer $token"},
//     );

//     final data = jsonDecode(res.body);

//     final appliedJobs = data["data"] ?? [];

//     bool found = appliedJobs.any((app) {
//       return app["job"]["_id"].toString() == widget.job["_id"].toString();
//     });

//     if (found) {
//       setState(() => hasApplied = true);
//     }
//   }

//   Future<void> fetchJobDetail() async {
//     try {
//       final id = widget.job["_id"];
//       final data = await ApiService.getJobById(id);

//       job = data ?? widget.job;

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print("ERROR: $e");

//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget bullet(List? list) {
//     if (list == null) return const SizedBox();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: list
//           .map((e) => Text("• $e", style: const TextStyle(color: Colors.black)))
//           .toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey[100],

//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         actions: const [
//           Icon(Icons.share, color: Colors.green),
//           SizedBox(width: 10),
//         ],
//       ),

//       // 🔥 FULL SCREEN TEXT BLACK
//       body: Stack(
//         children: [
//           DefaultTextStyle(
//             style: const TextStyle(color: Colors.black),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ================= TOP =================
//                   Text(
//                     job['title'],
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(job['company']),
//                   const SizedBox(height: 6),
//                   Text("📍 ${job['location']}"),
//                   const SizedBox(height: 6),
//                   Text("💰 ${salaryText()} monthly"),

//                   const SizedBox(height: 16),

//                   // Salary Card
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       children: [row("Annual LPA", "${salaryText()} LPA")],
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // Chips
//                   Wrap(
//                     children: [
//                       chip("Work from Office"),
//                       chip("Full Time"),
//                       chip("Any experience"),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Highlights
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.blue.shade100),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Job highlights",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text("🔥 Urgently hiring"),
//                         Text("⚡ Fast HR reply"),
//                       ],
//                     ),
//                   ),

//                   // ================= DETAILS =================
//                   sectionTitle("Job description"),
//                   Text(job['description'] ?? ""),

//                   sectionTitle("Experience"),
//                   Text("${job['experience']?['min']} yrs"),

//                   sectionTitle("Job role"),
//                   const Text("Software Development"),

//                   sectionTitle("Skills"),
//                   bullet(job['skillsRequired']),

//                   sectionTitle("Responsibilities"),
//                   bullet(job['responsibilities']),

//                   sectionTitle("Requirements"),
//                   bullet(job['requirements']),

//                   const SizedBox(height: 20),

//                   // ================= COMPANY =================
//                   sectionTitle("About company"),
//                   Text("Name: ${job['company']}"),
//                   const SizedBox(height: 6),
//                   Text("Location: ${job['location']}"),

//                   const SizedBox(height: 80),
//                 ],
//               ),
//             ),
//           ),
//           if (showQuestions)
//             Container(
//               color: Colors.black54,
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.all(20),
//                   color: Colors.white,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text("Answer Questions"),

//                       ...(job["screeningQuestions"] ?? []).map((q) {
//                         return TextField(
//                           decoration: InputDecoration(labelText: q["question"]),
//                           onChanged: (v) => answers[q["_id"]] = v,
//                         );
//                       }),

//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             showQuestions = false;
//                             isSubmittingAnswers = true; // 🔥 IMPORTANT
//                           });
//                           handleApply();
//                         },
//                         child: const Text("Submit"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),

//       // ================= APPLY BUTTON =================
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(12),
//         color: Colors.white,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             padding: const EdgeInsets.all(14),
//           ),
//           onPressed: applying || hasApplied ? null : handleApply,
//           child: hasApplied
//               ? const Text("Applied ✅", style: TextStyle(color: Colors.white))
//               : applying
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text(
//                   "Apply for job",
//                   style: TextStyle(color: Colors.white),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget row(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: const TextStyle(color: Colors.black)),
//           Text(value, style: const TextStyle(color: Colors.black)),
//         ],
//       ),
//     );
//   }

//   Widget chip(String text) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8, bottom: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.black), // 🔥 fix
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/user_session.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> job = {};
  bool isLoading = true;
  bool applying = false;
  bool hasApplied = false;
  bool showQuestions = false;
  bool isSubmittingAnswers = false;
  Map<String, String> answers = {};

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    checkIfApplied();
    fetchJobDetail();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String salaryText() {
    final s = job['salary'];
    if (s == null) return "Not specified";
    return "₹${s['min']} - ₹${s['max']}";
  }

  double getAnnualLPA() {
    final s = job['salary'];
    if (s == null) return 0;
    final avg = (s['min'] + s['max']) / 2;
    return (avg * 12) / 100000;
  }

  Future<void> handleApply() async {
    final token = UserSession.user?["token"];

    if (token == null) {
      _showSnackBar("Please login to apply", isError: true);
      return;
    }

    final questions = job["screeningQuestions"] ?? [];
    if (questions.isNotEmpty && !isSubmittingAnswers && !showQuestions) {
      setState(() => showQuestions = true);
      return;
    }

    setState(() => applying = true);

    try {
      final formattedAnswers = answers.entries.map((e) {
        return {"questionId": e.key, "answer": e.value};
      }).toList();

      final res = await http.post(
        Uri.parse(
          "https://job-portal-fullstack-production.up.railway.app/api/jobs/${job["_id"]}/apply",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"answers": formattedAnswers}),
      );

      final data = jsonDecode(res.body);

      if (data["success"] == true || data["message"] == "Already applied") {
        setState(() => hasApplied = true);
        _showSnackBar(
          data["message"] ?? "🎉 Applied Successfully!",
          isError: false,
        );
        if (showQuestions) {
          setState(() => showQuestions = false);
        }
      } else {
        _showSnackBar(data["message"] ?? "Something went wrong", isError: true);
      }
    } catch (e) {
      print("ERROR: $e");
      _showSnackBar("Network error. Please try again", isError: true);
    } finally {
      setState(() {
        applying = false;
        isSubmittingAnswers = false;
      });
    }
  }

  Future<void> checkIfApplied() async {
    final token = UserSession.user?["token"];
    if (token == null) return;

    try {
      final res = await http.get(
        Uri.parse(
          "https://job-portal-fullstack-production.up.railway.app/api/jobs/my-applications",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(res.body);
      final appliedJobs = data["data"] ?? [];

      bool found = appliedJobs.any((app) {
        return app["job"]["_id"].toString() == widget.job["_id"].toString();
      });

      if (found && mounted) {
        setState(() => hasApplied = true);
      }
    } catch (e) {
      print("Error checking applied status: $e");
    }
  }

  Future<void> fetchJobDetail() async {
    try {
      final id = widget.job["_id"];
      final data = await ApiService.getJobById(id);

      if (mounted) {
        setState(() {
          job = data ?? widget.job;
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E27),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D68F)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSalaryCard(),
                    const SizedBox(height: 20),
                    _buildTags(),
                    const SizedBox(height: 20),
                    _buildHighlights(),
                    const SizedBox(height: 24),
                    _buildSection(
                      "Job Description",
                      job['description'] ?? "No description provided",
                    ),
                    _buildSection(
                      "Experience Required",
                      "${job['experience']?['min'] ?? 0} - ${job['experience']?['max'] ?? 0} years",
                    ),
                    _buildSection("Job Role", "Software Development"),
                    _buildBulletSection(
                      "Skills Required",
                      job['skillsRequired'],
                    ),
                    _buildBulletSection(
                      "Responsibilities",
                      job['responsibilities'],
                    ),
                    _buildBulletSection("Requirements", job['requirements']),
                    const SizedBox(height: 24),
                    _buildCompanyInfo(),
                  ],
                ),
              ),
            ),
          ),

          // Screening Questions Modal
          if (showQuestions) _buildScreeningQuestionsModal(),
        ],
      ),
      bottomNavigationBar: _buildApplyButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF00D68F)),
            onPressed: () {
              _showSnackBar("Share feature coming soon", isError: false);
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Logo Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D68F), Color(0xFF00875A)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.business_center,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            job['title'] ?? "Job Title",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.business, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Text(
                job['company'] ?? "Company Name",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Text(
                job['location'] ?? "Location",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard() {
    final annualLPA = getAnnualLPA();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00D68F).withOpacity(0.15),
            const Color(0xFF00875A).withOpacity(0.05),
          ],
          stops: const [0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00D68F).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildInfoRow("Monthly Salary", salaryText()),
          const Divider(color: Colors.white24, height: 16),
          _buildInfoRow("Annual CTC", "₹${annualLPA.toStringAsFixed(1)} LPA"),
          if (job['salary']?['bonus'] != null) ...[
            const Divider(color: Colors.white24, height: 16),
            _buildInfoRow("Performance Bonus", job['salary']['bonus']),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade400)),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF00D68F),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTag("Work from Office"),
        _buildTag("Full Time"),
        _buildTag(
          job['experience']?['min'] != null
              ? "${job['experience']['min']}+ years"
              : "Any experience",
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildHighlights() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade900.withOpacity(0.2),
            Colors.orange.shade800.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade700.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Job Highlights",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHighlightItem("🔥", "Urgently hiring"),
          const SizedBox(height: 8),
          _buildHighlightItem("⚡", "Fast HR reply"),
          if (job['isFeatured'] == true)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildHighlightItem("⭐", "Featured position"),
            ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey.shade300, fontSize: 13)),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(color: Colors.grey.shade400, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildBulletSection(String title, List? items) {
    if (items == null || items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "•",
                  style: TextStyle(color: Color(0xFF00D68F), fontSize: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: TextStyle(color: Colors.grey.shade400, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Company",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business,
                  color: Color(0xFF00D68F),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['company'] ?? "Company Name",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      job['location'] ?? "Location",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (job['companyDescription'] != null) ...[
            const SizedBox(height: 12),
            Text(
              job['companyDescription'],
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScreeningQuestionsModal() {
    final questions = job["screeningQuestions"] ?? [];
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, double value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1F3F), Color(0xFF0A0E27)],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Screening Questions",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please answer these questions to apply",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: questions.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final q = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${idx + 1}. ${q["question"]}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Type your answer...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                maxLines: 3,
                                onChanged: (value) {
                                  answers[q["_id"]] = value;
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade400,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          setState(() => showQuestions = false);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D68F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showQuestions = false;
                            isSubmittingAnswers = true;
                          });
                          handleApply();
                        },
                        child: const Text(
                          "Submit Answers",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: hasApplied
                ? LinearGradient(
                    colors: [Colors.grey.shade700, Colors.grey.shade600],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: (applying || hasApplied)
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF00D68F).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: (applying || hasApplied) ? null : handleApply,
            child: hasApplied
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Applied Successfully",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : applying
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "Apply Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
