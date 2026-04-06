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

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Map profile;

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
  @override
  void initState() {
    super.initState();

    final user = widget.user;

    profile = Map.from(user["jobseekerProfile"] ?? {});

    nameCtrl.text = user["name"] ?? "";
    phoneCtrl.text = user["phone"] ?? "";
    locationCtrl.text = user["location"] ?? "";
    genderCtrl.text = user["gender"] ?? "";
    dobCtrl.text = user["dateOfBirth"] ?? "";

    skills = List.from(profile["skills"] ?? []);
    experience = List.from(profile["experience"] ?? []);
    education = List.from(profile["educationDetails"] ?? []);
    languages = List.from(profile["languages"] ?? []);
    certifications = List.from(profile["certifications"] ?? []);
  }

  void deleteItem(List list, int i) {
    setState(() => list.removeAt(i));
  }

  /// SAVE
  Future<void> saveProfile() async {
    final token = UserSession.user?["token"];

    final body = {
      "name": nameCtrl.text,
      "phone": phoneCtrl.text,
      "location": locationCtrl.text,
      "gender": genderCtrl.text,
      "dateOfBirth": dobCtrl.text,
      "skills": skills.map((s) => s["name"]).toList(),
      "experience": experience,
      "educationDetails": education,
      "languages": languages,
      "certifications": certifications,
    };

    final res = await http.put(
      Uri.parse("https://job-portal-fullstack-production.up.railway.app/api/users/update-profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      Navigator.pop(context, data["data"]);
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          IconButton(onPressed: saveProfile, icon: const Icon(Icons.save)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : null,
                  child: profileImage == null
                      ? const Icon(Icons.camera_alt)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// BASIC
            const Text(
              "Basic Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: locationCtrl,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            TextField(
              controller: genderCtrl,
              decoration: const InputDecoration(labelText: "Gender"),
            ),
            TextField(
              controller: dobCtrl,
              decoration: const InputDecoration(labelText: "DOB"),
            ),

            const SizedBox(height: 20),

            /// SKILLS
            _title("Skills", () {
              setState(() => skills.add({"name": ""}));
            }),
            Wrap(
              children: skills.asMap().entries.map((e) {
                return Chip(
                  label: Text(e.value["name"] ?? ""),
                  onDeleted: () => deleteItem(skills, e.key),
                );
              }).toList(),
            ),

            /// EXPERIENCE FULL
            _title("Experience", () {
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

            ...experience.asMap().entries.map((e) {
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: "Company"),
                    controller: TextEditingController(text: e.value["company"]),
                    onChanged: (v) => e.value["company"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Position"),
                    controller: TextEditingController(
                      text: e.value["position"],
                    ),
                    onChanged: (v) => e.value["position"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Start Date"),
                    controller: TextEditingController(
                      text: e.value["startDate"] ?? "",
                    ),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() {
                          e.value["startDate"] = picked.toIso8601String();
                        });
                      }
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "End Date"),
                    controller: TextEditingController(
                      text: e.value["endDate"] ?? "",
                    ),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() {
                          e.value["endDate"] = picked.toIso8601String();
                        });
                      }
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Description"),
                    controller: TextEditingController(
                      text: e.value["description"],
                    ),
                    onChanged: (v) => e.value["description"] = v,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(experience, e.key),
                  ),
                  const Divider(),
                ],
              );
            }),

            /// EDUCATION FULL
            _title("Education", () {
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

            ...education.asMap().entries.map((e) {
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: "College"),
                    controller: TextEditingController(text: e.value["college"]),
                    onChanged: (v) => e.value["college"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Degree"),
                    controller: TextEditingController(text: e.value["degree"]),
                    onChanged: (v) => e.value["degree"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Field"),
                    controller: TextEditingController(text: e.value["field"]),
                    onChanged: (v) => e.value["field"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Batch"),
                    controller: TextEditingController(text: e.value["batch"]),
                    onChanged: (v) => e.value["batch"] = v,
                  ),
                  DropdownButtonFormField<String>(
                    value:
                        e.value["type"] != null &&
                            [
                              "Graduate",
                              "Post Graduate",
                              "Diploma",
                              "PhD",
                            ].contains(e.value["type"])
                        ? e.value["type"]
                        : null, // 🔥 important

                    hint: const Text("Select Type"), // 🔥 important

                    items: ["Graduate", "Post Graduate", "Diploma", "PhD"]
                        .map(
                          (v) => DropdownMenuItem<String>(
                            value: v,
                            child: Text(v),
                          ),
                        )
                        .toList(),

                    onChanged: (v) {
                      setState(() {
                        e.value["type"] = v;
                      });
                    },

                    decoration: const InputDecoration(labelText: "Type"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(education, e.key),
                  ),
                  const Divider(),
                ],
              );
            }),

            /// CERTIFICATIONS
            _title("Certifications", () {
              setState(() {
                certifications.add({
                  "name": "",
                  "issuer": "",
                  "credentialId": "",
                  "url": "",
                });
              });
            }),

            ...certifications.asMap().entries.map((e) {
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: "Name"),
                    controller: TextEditingController(text: e.value["name"]),
                    onChanged: (v) => e.value["name"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Issuer"),
                    controller: TextEditingController(text: e.value["issuer"]),
                    onChanged: (v) => e.value["issuer"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Credential ID",
                    ),
                    controller: TextEditingController(
                      text: e.value["credentialId"],
                    ),
                    onChanged: (v) => e.value["credentialId"] = v,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "URL"),
                    controller: TextEditingController(text: e.value["url"]),
                    onChanged: (v) => e.value["url"] = v,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(certifications, e.key),
                  ),
                  const Divider(),
                ],
              );
            }),

            /// LANGUAGES FULL + DROPDOWN
            _title("Languages", () {
              setState(() {
                languages.add({"language": "", "proficiency": "Basic"});
              });
            }),

            ...languages.asMap().entries.map((e) {
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: "Language"),
                    controller: TextEditingController(
                      text: e.value["language"],
                    ),
                    onChanged: (v) => e.value["language"] = v,
                  ),
                  DropdownButtonFormField(
                    value: e.value["proficiency"],
                    items: ["Basic", "Intermediate", "Fluent"]
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => e.value["proficiency"] = v),
                    decoration: const InputDecoration(labelText: "Proficiency"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(languages, e.key),
                  ),
                  const Divider(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _title(String t, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          t,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: onAdd, child: const Text("+ Add")),
      ],
    );
  }
}
