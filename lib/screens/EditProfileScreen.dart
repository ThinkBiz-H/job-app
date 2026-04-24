// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../utils/user_session.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class EditProfileScreen extends StatefulWidget {
//   final Map user;

//   const EditProfileScreen({super.key, required this.user});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   late Map profile;

//   final nameCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final locationCtrl = TextEditingController();
//   final genderCtrl = TextEditingController();
//   final dobCtrl = TextEditingController();

//   List skills = [];
//   List experience = [];
//   List education = [];
//   List languages = [];
//   List certifications = [];
//   File? profileImage;
//   @override
//   void initState() {
//     super.initState();

//     final user = widget.user;

//     profile = Map.from(user["jobseekerProfile"] ?? {});

//     nameCtrl.text = user["name"] ?? "";
//     phoneCtrl.text = user["phone"] ?? "";
//     locationCtrl.text = user["location"] ?? "";
//     genderCtrl.text = user["gender"] ?? "";
//     dobCtrl.text = user["dateOfBirth"] ?? "";

//     skills = List.from(profile["skills"] ?? []);
//     experience = List.from(profile["experience"] ?? []);
//     education = List.from(profile["educationDetails"] ?? []);
//     languages = List.from(profile["languages"] ?? []);
//     certifications = List.from(profile["certifications"] ?? []);
//   }

//   void deleteItem(List list, int i) {
//     setState(() => list.removeAt(i));
//   }

//   /// SAVE
//   Future<void> saveProfile() async {
//     final token = UserSession.user?["token"];

//     final body = {
//       "name": nameCtrl.text,
//       "phone": phoneCtrl.text,
//       "location": locationCtrl.text,
//       "gender": genderCtrl.text,
//       "dateOfBirth": dobCtrl.text,
//       "skills": skills.map((s) => s["name"]).toList(),
//       "experience": experience,
//       "educationDetails": education,
//       "languages": languages,
//       "certifications": certifications,
//     };

//     final res = await http.put(
//       Uri.parse("https://job-portal-web-979y.onrender.com/api/users/update-profile"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer ${UserSession.user?["token"]}",
//       },
//       body: jsonEncode(body),
//     );

//     final data = jsonDecode(res.body);

//     if (res.statusCode == 200) {
//       Navigator.pop(context, data["data"]);
//     }
//   }

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         profileImage = File(picked.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         actions: [
//           IconButton(onPressed: saveProfile, icon: const Icon(Icons.save)),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: pickImage,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: profileImage != null
//                       ? FileImage(profileImage!)
//                       : null,
//                   child: profileImage == null
//                       ? const Icon(Icons.camera_alt)
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             /// BASIC
//             const Text(
//               "Basic Info",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: nameCtrl,
//               decoration: const InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: phoneCtrl,
//               decoration: const InputDecoration(labelText: "Phone"),
//             ),
//             TextField(
//               controller: locationCtrl,
//               decoration: const InputDecoration(labelText: "Location"),
//             ),
//             TextField(
//               controller: genderCtrl,
//               decoration: const InputDecoration(labelText: "Gender"),
//             ),
//             TextField(
//               controller: dobCtrl,
//               decoration: const InputDecoration(labelText: "DOB"),
//             ),

//             const SizedBox(height: 20),

//             /// SKILLS
//             _title("Skills", () {
//               setState(() => skills.add({"name": ""}));
//             }),
//             Wrap(
//               children: skills.asMap().entries.map((e) {
//                 return Chip(
//                   label: Text(e.value["name"] ?? ""),
//                   onDeleted: () => deleteItem(skills, e.key),
//                 );
//               }).toList(),
//             ),

//             /// EXPERIENCE FULL
//             _title("Experience", () {
//               setState(() {
//                 experience.add({
//                   "company": "",
//                   "position": "",
//                   "startDate": "",
//                   "endDate": "",
//                   "description": "",
//                 });
//               });
//             }),

//             ...experience.asMap().entries.map((e) {
//               return Column(
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Company"),
//                     controller: TextEditingController(text: e.value["company"]),
//                     onChanged: (v) => e.value["company"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Position"),
//                     controller: TextEditingController(
//                       text: e.value["position"],
//                     ),
//                     onChanged: (v) => e.value["position"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Start Date"),
//                     controller: TextEditingController(
//                       text: e.value["startDate"] ?? "",
//                     ),
//                     readOnly: true,
//                     onTap: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                       );

//                       if (picked != null) {
//                         setState(() {
//                           e.value["startDate"] = picked.toIso8601String();
//                         });
//                       }
//                     },
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "End Date"),
//                     controller: TextEditingController(
//                       text: e.value["endDate"] ?? "",
//                     ),
//                     readOnly: true,
//                     onTap: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                       );

//                       if (picked != null) {
//                         setState(() {
//                           e.value["endDate"] = picked.toIso8601String();
//                         });
//                       }
//                     },
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Description"),
//                     controller: TextEditingController(
//                       text: e.value["description"],
//                     ),
//                     onChanged: (v) => e.value["description"] = v,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => deleteItem(experience, e.key),
//                   ),
//                   const Divider(),
//                 ],
//               );
//             }),

//             /// EDUCATION FULL
//             _title("Education", () {
//               setState(() {
//                 education.add({
//                   "college": "",
//                   "degree": "",
//                   "field": "",
//                   "batch": "",
//                   "type": null,
//                 });
//               });
//             }),

//             ...education.asMap().entries.map((e) {
//               return Column(
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(labelText: "College"),
//                     controller: TextEditingController(text: e.value["college"]),
//                     onChanged: (v) => e.value["college"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Degree"),
//                     controller: TextEditingController(text: e.value["degree"]),
//                     onChanged: (v) => e.value["degree"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Field"),
//                     controller: TextEditingController(text: e.value["field"]),
//                     onChanged: (v) => e.value["field"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Batch"),
//                     controller: TextEditingController(text: e.value["batch"]),
//                     onChanged: (v) => e.value["batch"] = v,
//                   ),
//                   DropdownButtonFormField<String>(
//                     value:
//                         e.value["type"] != null &&
//                             [
//                               "Graduate",
//                               "Post Graduate",
//                               "Diploma",
//                               "PhD",
//                             ].contains(e.value["type"])
//                         ? e.value["type"]
//                         : null, // 🔥 important

//                     hint: const Text("Select Type"), // 🔥 important

//                     items: ["Graduate", "Post Graduate", "Diploma", "PhD"]
//                         .map(
//                           (v) => DropdownMenuItem<String>(
//                             value: v,
//                             child: Text(v),
//                           ),
//                         )
//                         .toList(),

//                     onChanged: (v) {
//                       setState(() {
//                         e.value["type"] = v;
//                       });
//                     },

//                     decoration: const InputDecoration(labelText: "Type"),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => deleteItem(education, e.key),
//                   ),
//                   const Divider(),
//                 ],
//               );
//             }),

//             /// CERTIFICATIONS
//             _title("Certifications", () {
//               setState(() {
//                 certifications.add({
//                   "name": "",
//                   "issuer": "",
//                   "credentialId": "",
//                   "url": "",
//                 });
//               });
//             }),

//             ...certifications.asMap().entries.map((e) {
//               return Column(
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Name"),
//                     controller: TextEditingController(text: e.value["name"]),
//                     onChanged: (v) => e.value["name"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Issuer"),
//                     controller: TextEditingController(text: e.value["issuer"]),
//                     onChanged: (v) => e.value["issuer"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(
//                       labelText: "Credential ID",
//                     ),
//                     controller: TextEditingController(
//                       text: e.value["credentialId"],
//                     ),
//                     onChanged: (v) => e.value["credentialId"] = v,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(labelText: "URL"),
//                     controller: TextEditingController(text: e.value["url"]),
//                     onChanged: (v) => e.value["url"] = v,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => deleteItem(certifications, e.key),
//                   ),
//                   const Divider(),
//                 ],
//               );
//             }),

//             /// LANGUAGES FULL + DROPDOWN
//             _title("Languages", () {
//               setState(() {
//                 languages.add({"language": "", "proficiency": "Basic"});
//               });
//             }),

//             ...languages.asMap().entries.map((e) {
//               return Column(
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Language"),
//                     controller: TextEditingController(
//                       text: e.value["language"],
//                     ),
//                     onChanged: (v) => e.value["language"] = v,
//                   ),
//                   DropdownButtonFormField(
//                     value: e.value["proficiency"],
//                     items: ["Basic", "Intermediate", "Fluent"]
//                         .map((v) => DropdownMenuItem(value: v, child: Text(v)))
//                         .toList(),
//                     onChanged: (v) =>
//                         setState(() => e.value["proficiency"] = v),
//                     decoration: const InputDecoration(labelText: "Proficiency"),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => deleteItem(languages, e.key),
//                   ),
//                   const Divider(),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _title(String t, VoidCallback onAdd) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           t,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         TextButton(onPressed: onAdd, child: const Text("+ Add")),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/user_session.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final Map user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late Map profile;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final dobCtrl = TextEditingController();

  List skills = [];
  List experience = [];
  List education = [];
  List languages = [];
  List certifications = [];
  File? profileImage;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    final user = widget.user;
    profile = Map.from(user["jobseekerProfile"] ?? {});

    nameCtrl.text = user["name"] ?? "";
    phoneCtrl.text = user["phone"] ?? "";
    locationCtrl.text = user["location"] ?? "";
    genderCtrl.text = user["gender"] ?? "";
    dobCtrl.text = user["dateOfBirth"] != null
        ? user["dateOfBirth"].toString().split("T")[0]
        : "";

    skills = List.from(profile["skills"] ?? []);
    experience = List.from(profile["experience"] ?? []);
    education = List.from(profile["educationDetails"] ?? []);
    languages = List.from(profile["languages"] ?? []);
    certifications = List.from(profile["certifications"] ?? []);
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    locationCtrl.dispose();
    genderCtrl.dispose();
    dobCtrl.dispose();
    super.dispose();
  }

  void deleteItem(List list, int i) {
    setState(() => list.removeAt(i));
  }

  Future<void> saveProfile() async {
    setState(() => isSaving = true);

    final body = {
      "name": nameCtrl.text,
      "phone": phoneCtrl.text,
      "location": locationCtrl.text,
      "gender": genderCtrl.text,
      "dateOfBirth": dobCtrl.text.isNotEmpty
          ? DateTime.parse(dobCtrl.text).toIso8601String()
          : null,
      "skills": skills.map((s) => s["name"]).toList(),
      "experience": experience,
      "educationDetails": education,
      "languages": languages,
      "certifications": certifications,
    };

    try {
      final res = await http.put(
        Uri.parse(
          "https://job-portal-web-979y.onrender.com/api/users/update-profile",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${UserSession.user?["token"]}",
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && mounted) {
        _showSnackBar("Profile updated successfully ✅", isError: false);
        Navigator.pop(context, data["data"]);
      } else if (mounted) {
        _showSnackBar("Failed to update profile", isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Network error", isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
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

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  Future<DateTime?> _selectDate(
    BuildContext context,
    DateTime? initialDate,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00D68F),
              onPrimary: Colors.white,
              surface: Color(0xFF1A1F3F),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              _buildProfileImageSection(),
              const SizedBox(height: 24),

              // Basic Info Section
              _buildSectionHeader("Basic Information", Icons.person_outline),
              const SizedBox(height: 16),
              _buildBasicInfoCard(),
              const SizedBox(height: 24),

              // Skills Section
              _buildEditableSection(
                title: "Skills",
                icon: Icons.code,
                items: skills,
                onAdd: () {
                  setState(() => skills.add({"name": ""}));
                },
                onDelete: (index) => deleteItem(skills, index),
                itemBuilder: (skill, index) => Chip(
                  label: Text(
                    skill["name"] ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF00D68F),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                  onDeleted: () => deleteItem(skills, index),
                ),
                editBuilder: (skill, index) => _buildEditableTextField(
                  label: "Skill Name",
                  initialValue: skill["name"],
                  onChanged: (val) => skill["name"] = val,
                ),
              ),
              const SizedBox(height: 24),

              // Experience Section
              _buildSectionHeader("Work Experience", Icons.work_outline),
              ...experience.asMap().entries.map(
                (e) => _buildExperienceCard(e.key, e.value),
              ),
              _buildAddButton(() {
                setState(() {
                  experience.add({
                    "company": "",
                    "position": "",
                    "startDate": "",
                    "endDate": "",
                    "description": "",
                  });
                });
              }),
              const SizedBox(height: 24),

              // Education Section
              _buildSectionHeader("Education", Icons.school),
              ...education.asMap().entries.map(
                (e) => _buildEducationCard(e.key, e.value),
              ),
              _buildAddButton(() {
                setState(() {
                  education.add({
                    "college": "",
                    "degree": "",
                    "field": "",
                    "batch": "",
                    "type": null,
                  });
                });
              }),
              const SizedBox(height: 24),

              // Certifications Section
              _buildSectionHeader("Certifications", Icons.verified),
              ...certifications.asMap().entries.map(
                (e) => _buildCertificationCard(e.key, e.value),
              ),
              _buildAddButton(() {
                setState(() {
                  certifications.add({
                    "name": "",
                    "issuer": "",
                    "credentialId": "",
                    "url": "",
                  });
                });
              }),
              const SizedBox(height: 24),

              // Languages Section
              _buildSectionHeader("Languages", Icons.language),
              ...languages.asMap().entries.map(
                (e) => _buildLanguageCard(e.key, e.value),
              ),
              _buildAddButton(() {
                setState(() {
                  languages.add({"language": "", "proficiency": "Basic"});
                });
              }),
              const SizedBox(height: 80),
            ],
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
        "Edit Profile",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00D68F), Color(0xFF00875A)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: isSaving ? null : saveProfile,
            icon: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.check, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
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
              child: ClipOval(
                child: profileImage != null
                    ? Image.file(
                        profileImage!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : widget.user["profileImage"] != null
                    ? Image.memory(
                        base64Decode(
                          widget.user["profileImage"].split(",").last,
                        ),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt, size: 16, color: Color(0xFF00D68F)),
                SizedBox(width: 8),
                Text(
                  "Change Photo",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.transparent,
      child: const Icon(Icons.person, size: 60, color: Colors.white),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
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
    );
  }

  Widget _buildBasicInfoCard() {
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
        children: [
          _buildTextField(nameCtrl, "Full Name", Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(
            phoneCtrl,
            "Phone Number",
            Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(locationCtrl, "Location", Icons.location_on_outlined),
          const SizedBox(height: 16),
          _buildTextField(genderCtrl, "Gender", Icons.person_outline),
          const SizedBox(height: 16),
          _buildDateField(dobCtrl, "Date of Birth", Icons.cake_outlined),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: const Color(0xFF00D68F), size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () async {
        final date = await _selectDate(
          context,
          controller.text.isNotEmpty
              ? DateTime.tryParse(controller.text)
              : null,
        );
        if (date != null) {
          setState(() {
            controller.text = date.toIso8601String().split('T')[0];
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(icon, color: const Color(0xFF00D68F), size: 20),
            suffixIcon: const Icon(
              Icons.calendar_today,
              size: 18,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableSection({
    required String title,
    required IconData icon,
    required List items,
    required VoidCallback onAdd,
    required Function(int) onDelete,
    required Widget Function(dynamic, int) itemBuilder,
    required Widget Function(dynamic, int) editBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(title, icon),
            _buildAddButton(onAdd, isSmall: true),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .asMap()
              .entries
              .map((e) => itemBuilder(e.value, e.key))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAddButton(VoidCallback onAdd, {bool isSmall = false}) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12 : 20,
          vertical: isSmall ? 6 : 10,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00D68F), Color(0xFF00875A)],
          ),
          borderRadius: BorderRadius.circular(isSmall ? 20 : 30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: isSmall ? 16 : 20, color: Colors.white),
            if (!isSmall) const SizedBox(width: 8),
            if (!isSmall)
              const Text("Add", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required String? initialValue,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
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
    );
  }

  Widget _buildExperienceCard(int index, Map exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Experience",
                style: TextStyle(
                  color: Color(0xFF00D68F),
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => deleteItem(experience, index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildEditableTextField(
            label: "Company",
            initialValue: exp["company"],
            onChanged: (val) => exp["company"] = val,
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Position",
            initialValue: exp["position"],
            onChanged: (val) => exp["position"] = val,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateFieldSimple(
                  label: "Start Date",
                  initialValue: exp["startDate"],
                  onChanged: (val) => exp["startDate"] = val,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateFieldSimple(
                  label: "End Date",
                  initialValue: exp["endDate"],
                  onChanged: (val) => exp["endDate"] = val,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Description",
            initialValue: exp["description"],
            onChanged: (val) => exp["description"] = val,
          ),
        ],
      ),
    );
  }

  Widget _buildDateFieldSimple({
    required String label,
    required String? initialValue,
    required Function(String) onChanged,
  }) {
    return GestureDetector(
      onTap: () async {
        final date = await _selectDate(
          context,
          initialValue != null ? DateTime.tryParse(initialValue) : null,
        );
        if (date != null) {
          onChanged(date.toIso8601String());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: const Color(0xFF00D68F),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                initialValue?.split('T').first ?? label,
                style: TextStyle(
                  color: initialValue != null
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard(int index, Map edu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Education",
                style: TextStyle(
                  color: Color(0xFF00D68F),
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => deleteItem(education, index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildEditableTextField(
            label: "College/University",
            initialValue: edu["college"],
            onChanged: (val) => edu["college"] = val,
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Degree",
            initialValue: edu["degree"],
            onChanged: (val) => edu["degree"] = val,
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Field of Study",
            initialValue: edu["field"],
            onChanged: (val) => edu["field"] = val,
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Batch Year",
            initialValue: edu["batch"],
            onChanged: (val) => edu["batch"] = val,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "Type",
            value: edu["type"],
            items: ["Graduate", "Post Graduate", "Diploma", "PhD"],
            onChanged: (val) => edu["type"] = val,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationCard(int index, Map cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Certification",
                style: TextStyle(
                  color: Color(0xFF00D68F),
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => deleteItem(certifications, index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildEditableTextField(
            label: "Certification Name",
            initialValue: cert["name"],
            onChanged: (val) => cert["name"] = val,
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Issuing Organization",
            initialValue: cert["issuer"],
            onChanged: (val) => cert["issuer"] = val,
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Credential ID",
            initialValue: cert["credentialId"],
            onChanged: (val) => cert["credentialId"] = val,
          ),
          const SizedBox(height: 12),
          _buildEditableTextField(
            label: "Certificate URL",
            initialValue: cert["url"],
            onChanged: (val) => cert["url"] = val,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(int index, Map lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Language",
                style: TextStyle(
                  color: Color(0xFF00D68F),
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => deleteItem(languages, index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildEditableTextField(
            label: "Language",
            initialValue: lang["language"],
            onChanged: (val) => lang["language"] = val,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "Proficiency",
            value: lang["proficiency"],
            items: ["Basic", "Intermediate", "Fluent", "Native"],
            onChanged: (val) => lang["proficiency"] = val,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value != null && items.contains(value) ? value : null,
        hint: Text(label, style: TextStyle(color: Colors.grey.shade500)),
        style: const TextStyle(color: Colors.white),
        dropdownColor: const Color(0xFF1A1F3F),
        decoration: const InputDecoration(border: InputBorder.none),
        items: items.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
