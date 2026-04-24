import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/user_session.dart';
import 'EditProfileScreen.dart';
import 'applied_jobs_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  PlatformFile? pickedFile;
  bool isUploading = false;
  bool isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

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

    loadProfile(); // 👈 ADD THIS
  }

  Future<void> loadProfile() async {
    try {
      final token = UserSession.user?["token"];

      final res = await http.get(
        Uri.parse("https://job-portal-web-979y.onrender.com/api/auth/profile"),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data["success"] == true) {
        setState(() {
          UserSession.user = data["user"];
        });
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.single;
      });
    }
  }

  void openLocalResume() async {
    if (pickedFile == null) return;

    final bytes = pickedFile!.bytes;
    if (bytes != null) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${pickedFile!.name}');
      await file.writeAsBytes(bytes);

      await OpenFile.open(file.path);
    }
  }

  Future<void> uploadResume() async {
    final token = UserSession.user?["token"];
    if (pickedFile == null || token == null) {
      _showSnackBar("Please select a file first", isError: true);
      return;
    }

    setState(() => isUploading = true);

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://job-portal-web-979y.onrender.com/api/auth/upload-resume",
        ),
      );

      request.headers["Authorization"] = "Bearer $token";
      request.files.add(
        http.MultipartFile.fromBytes(
          "resume",
          pickedFile!.bytes!,
          filename: pickedFile!.name,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      if (data["success"] == true) {
        setState(() {
          UserSession.user?["resume"] = data["resume"];
          UserSession.user?["resumeOriginalName"] = data["originalName"];
          pickedFile = null;
        });
        _showSnackBar("Resume Uploaded Successfully ✅", isError: false);
      } else {
        _showSnackBar("Upload failed", isError: true);
      }
    } catch (e) {
      _showSnackBar("Network error", isError: true);
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<String?> _showInputDialog(
    String title, {
    String hint = "Enter value",
  }) async {
    String value = "";
    return showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1F3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  autofocus: true,
                  onChanged: (val) => value = val,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade400,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D68F),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, value),
                        child: const Text("Add"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final user = UserSession.user;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E27),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text("No Data Available", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    final profile = (user["jobseekerProfile"] ?? {}) as Map<String, dynamic>;
    final skills = List<Map<String, dynamic>>.from(profile["skills"] ?? []);
    final experience = List<Map<String, dynamic>>.from(
      profile["experience"] ?? [],
    );
    final education = List<Map<String, dynamic>>.from(
      profile["educationDetails"] ?? [],
    );
    final certifications = List<Map<String, dynamic>>.from(
      profile["certifications"] ?? [],
    );
    final languages = List<Map<String, dynamic>>.from(
      profile["languages"] ?? [],
    );

    String? backendResume =
        user["resume"] ?? user["jobseekerProfile"]?["resume"];
    String? resumeName = user["resumeOriginalName"];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(user),
                const SizedBox(height: 24),

                // Edit Button
                _buildEditButton(user),
                const SizedBox(height: 24),

                // Basic Info
                _buildSection("Basic Information", Icons.person_outline),
                _buildInfoCard([
                  _infoRow("Full Name", user["name"]),
                  _infoRow("Email", user["email"]),
                  _infoRow("Phone", user["phone"]),
                  _infoRow("Location", user["location"]),
                  _infoRow("Gender", user["gender"]),
                  _infoRow(
                    "Date of Birth",
                    user["dateOfBirth"] != null
                        ? user["dateOfBirth"].toString().split("T")[0]
                        : "",
                  ),
                ]),
                const SizedBox(height: 20),

                // Skills
                _buildEditableSection(
                  title: "Skills",
                  icon: Icons.code,

                  // ✅ FIX 1: TYPE SAFE
                  items: skills.map((e) => e["name"].toString()).toList(),

                  onAdd: () async {
                    final newSkill = await _showInputDialog(
                      "Add Skill",
                      hint: "e.g., Flutter, React",
                    );

                    if (newSkill != null && newSkill.isNotEmpty && mounted) {
                      setState(() {
                        skills.add({"name": newSkill});
                        UserSession.user?["jobseekerProfile"]["skills"] =
                            skills;
                      });
                    }
                  },

                  // ✅ KEEP THIS (optional, for reuse)
                  onDelete: (index) {
                    setState(() {
                      skills.removeAt(index);
                      UserSession.user?["jobseekerProfile"]["skills"] = skills;
                    });
                  },

                  // 🔥 MAIN FIX
                  chipBuilder: (skill, index) => Chip(
                    label: Text(
                      skill.toString(), // ✅ EXTRA SAFE
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF00D68F),
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),

                    // ❌ ERROR WALA REMOVE
                    // onDeleted: () => onDelete(index),

                    // ✅ FINAL FIX
                    onDeleted: () {
                      setState(() {
                        skills.removeAt(index);
                        UserSession.user?["jobseekerProfile"]["skills"] =
                            skills;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Experience
                _buildSection("Work Experience", Icons.work_outline),
                if (experience.isEmpty)
                  _buildEmptyState("No experience added yet")
                else
                  ...experience.map((exp) => _buildExperienceCard(exp)),
                const SizedBox(height: 20),

                // Education
                _buildSection("Education", Icons.school),
                if (education.isEmpty)
                  _buildEmptyState("No education added yet")
                else
                  ...education.map((edu) => _buildEducationCard(edu)),
                const SizedBox(height: 20),

                // Certifications
                _buildSection("Certifications", Icons.verified),
                if (certifications.isEmpty)
                  _buildEmptyState("No certifications added yet")
                else
                  ...certifications.map(
                    (cert) => _buildCertificationCard(cert),
                  ),
                const SizedBox(height: 20),

                // Languages
                _buildEditableSection(
                  title: "Languages",
                  icon: Icons.language,
                  items: languages
                      .map((e) => "${e["language"]} (${e["proficiency"]})")
                      .toList(),
                  onAdd: () async {
                    final newLang = await _showInputDialog(
                      "Add Language",
                      hint: "e.g., English (Fluent)",
                    );
                    if (newLang != null && newLang.isNotEmpty && mounted) {
                      setState(() {
                        languages.add({
                          "language": newLang.split("(")[0].trim(),
                          "proficiency": newLang.contains("(")
                              ? newLang.split("(")[1].replaceAll(")", "").trim()
                              : "Basic",
                        });
                        UserSession.user?["jobseekerProfile"]["languages"] =
                            languages;
                      });
                    }
                  },
                  onDelete: (index) {
                    setState(() {
                      languages.removeAt(index);
                      UserSession.user?["jobseekerProfile"]["languages"] =
                          languages;
                    });
                  },
                  chipBuilder: (lang, index) => Chip(
                    label: Text(
                      lang.toString(), // ✅ safe
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),

                    // ❌ OLD (ERROR)
                    // onDeleted: () => onDelete(index),

                    // ✅ FIX
                    onDeleted: () {
                      setState(() {
                        languages.removeAt(index);
                        UserSession.user?["jobseekerProfile"]["languages"] =
                            languages;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Applications Button
                _buildApplicationsButton(),
                const SizedBox(height: 20),

                // Resume Section
                _buildSection("Resume", Icons.description_outlined),
                _buildResumeSection(backendResume),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
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
      title: const Text(
        "My Profile",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              _showSnackBar("Settings coming soon", isError: false);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(Map user) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D68F), Color(0xFF00875A)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D68F).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: _profileImage(user),
          ),
          const SizedBox(height: 12),
          Text(
            user["name"] ?? "User",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            user["email"] ?? "",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _profileImage(Map user) {
    try {
      final img = user["profileImage"];
      if (img != null && img.toString().contains("base64")) {
        final base64Str = img.split(",").last;
        return CircleAvatar(
          radius: 60,
          backgroundColor: Colors.transparent,
          backgroundImage: MemoryImage(base64Decode(base64Str)),
        );
      }
    } catch (_) {}

    return const CircleAvatar(
      radius: 60,
      backgroundColor: Colors.white24,
      child: Icon(Icons.person, size: 50, color: Colors.white),
    );
  }

  Widget _buildEditButton(Map user) {
    return Center(
      child: Container(
        width: 200,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00D68F), Color(0xFF00875A)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D68F).withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () async {
            final updatedUser = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
            );
            if (updatedUser != null && mounted) {
              setState(() {
                UserSession.user = updatedUser;
              });
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text(
                "Edit Profile",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00D68F), size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required VoidCallback onAdd,
    required Function(int) onDelete,
    required Widget Function(String, int) chipBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSection(title, icon),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "Add",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          _buildEmptyState("No $title added yet")
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .asMap()
                .entries
                .map((entry) => chipBuilder(entry.value, entry.key))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> rows) {
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
      child: Column(children: rows),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(Map<String, dynamic> exp) {
    return Container(
      width: double.infinity, // 👈 ye add karna hai
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exp["position"] ?? "Position",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exp["company"] ?? "Company",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "${exp["startDate"] != null ? exp["startDate"].toString().split("T")[0] : ""} - "
            "${exp["endDate"] != null ? exp["endDate"].toString().split("T")[0] : "Present"}",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          if (exp["description"] != null) ...[
            const SizedBox(height: 8),
            Text(
              exp["description"],
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEducationCard(Map<String, dynamic> edu) {
    return Container(
      width: double.infinity, // 👈 ye add kiya
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            edu["degree"] ?? "Degree",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            edu["college"] ?? "College",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "${edu["field"] ?? ""} • ${edu["batch"] ?? ""}",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationCard(Map<String, dynamic> cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cert["name"] ?? "Certification",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cert["issuer"] ?? "Issuer",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          if (cert["url"] != null && cert["url"].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final url = Uri.parse(cert["url"]);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                "View Certificate",
                style: TextStyle(color: const Color(0xFF00D68F), fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildApplicationsButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D68F), Color(0xFF00875A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D68F).withOpacity(0.3),
            blurRadius: 10,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AppliedJobsScreen()),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 20),
            SizedBox(width: 8),
            Text(
              "View My Applications",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeSection(String? backendResume) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          if (backendResume != null && backendResume.isNotEmpty)
            _buildExistingResume(backendResume)
          else if (pickedFile != null)
            _buildLocalResume()
          else
            _buildNoResume(),
          if (isUploading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D68F)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExistingResume(String backendResume) {
    final user = UserSession.user;
    String? resumeName = user?["resumeOriginalName"];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),

              // ✅ FIXED PART (NO CONST)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resumeName ?? "Resume.pdf", // 👈 ORIGINAL NAME
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      "Uploaded document",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              // 👁 VIEW
              IconButton(
                icon: const Icon(Icons.visibility, color: Color(0xFF00D68F)),
                onPressed: () async {
                  final url =
                      "https://job-portal-web-979y.onrender.com/uploads/resumes/$backendResume"; // ✅ FIXED URL
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),

              // 🔄 RE-UPLOAD
              IconButton(
                icon: const Icon(Icons.upload, color: Color(0xFF00D68F)),
                onPressed: () async {
                  await pickResume();
                  await uploadResume();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocalResume() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickedFile!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Ready to upload",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.visibility, color: Color(0xFF00D68F)),
                onPressed: openLocalResume,
              ),
              IconButton(
                icon: const Icon(Icons.cloud_upload, color: Color(0xFF00D68F)),
                onPressed: uploadResume,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoResume() {
    return Column(
      children: [
        const Icon(Icons.description_outlined, size: 48, color: Colors.grey),
        const SizedBox(height: 8),
        const Text(
          "No Resume Uploaded",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D68F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () async {
            await pickResume();
            await uploadResume();
          },
          icon: const Icon(Icons.upload),
          label: const Text("Upload Resume"),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade600, size: 32),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
