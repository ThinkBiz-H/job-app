// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   bool isOtpStep = false;
//   bool showPassword = false;
//   bool isLoading = false;

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final phoneController = TextEditingController();

//   List<String> otp = ["", "", "", "", "", ""];

//   final String baseUrl = "https://job-portal-fullstack-production.up.railway.app/api ";

//   // 🔥 REGISTER + SEND OTP
//   Future<void> handleRegister() async {
//     if (nameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         phoneController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("All fields required ❌")));
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       // 🔥 1. REGISTER
//       final res = await http.post(
//         Uri.parse("$baseUrl/auth/register"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "name": nameController.text.trim(),
//           "email": emailController.text.trim(),
//           "password": passwordController.text.trim(),
//           "phone": phoneController.text.trim(),
//         }),
//       );

//       final data = jsonDecode(res.body);
//       print("REGISTER: $data");

//       if (data["success"] == true) {
//         // 🔥 2. SEND OTP
//         final otpRes = await http.post(
//           Uri.parse("$baseUrl/otp/send"),
//           headers: {"Content-Type": "application/json"},
//           body: jsonEncode({"phone": phoneController.text.trim()}),
//         );

//         final otpData = jsonDecode(otpRes.body);
//         print("OTP: $otpData");

//         if (otpData["success"] == true) {
//           setState(() {
//             isOtpStep = true;
//           });

//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(const SnackBar(content: Text("OTP Sent ✅")));
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data["message"] ?? "Register Failed ❌")),
//         );
//       }
//     } catch (e) {
//       print("ERROR: $e");
//     }

//     setState(() => isLoading = false);
//   }

//   // 🔥 VERIFY OTP
//   Future<void> handleVerifyOtp() async {
//     final enteredOtp = otp.join();

//     if (enteredOtp.length != 6) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter valid OTP ❌")));
//       return;
//     }

//     final res = await http.post(
//       Uri.parse("$baseUrl/otp/verify"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "phone": phoneController.text.trim(),
//         "otp": enteredOtp,
//       }),
//     );

//     final data = jsonDecode(res.body);
//     print("VERIFY: $data");

//     if (data["success"] == true) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Account Verified ✅")));

//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Invalid OTP ❌")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             margin: const EdgeInsets.all(20),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1)),
//               ],
//             ),
//             child: isOtpStep ? otpUI() : registerUI(),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔥 REGISTER UI
//   Widget registerUI() {
//     return Column(
//       children: [
//         const Text(
//           "Create Account",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),

//         input("Name", nameController),
//         input("Email", emailController),

//         TextField(
//           controller: passwordController,
//           obscureText: !showPassword,
//           decoration: InputDecoration(
//             hintText: "Password",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 showPassword ? Icons.visibility : Icons.visibility_off,
//               ),
//               onPressed: () {
//                 setState(() => showPassword = !showPassword);
//               },
//             ),
//           ),
//         ),

//         const SizedBox(height: 15),
//         input("Phone", phoneController),

//         const SizedBox(height: 20),

//         ElevatedButton(
//           onPressed: isLoading ? null : handleRegister,
//           child: isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text("Create Account"),
//         ),
//       ],
//     );
//   }

//   // 🔥 OTP UI
//   Widget otpUI() {
//     return Column(
//       children: [
//         const Text(
//           "Verify OTP",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(6, (index) {
//             return SizedBox(
//               width: 40,
//               child: TextField(
//                 maxLength: 1,
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(counterText: ""),
//                 onChanged: (val) {
//                   otp[index] = val;
//                 },
//               ),
//             );
//           }),
//         ),

//         const SizedBox(height: 20),

//         ElevatedButton(
//           onPressed: handleVerifyOtp,
//           child: const Text("Verify OTP"),
//         ),
//       ],
//     );
//   }

//   Widget input(String hint, TextEditingController ctrl) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextField(
//         controller: ctrl,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   bool isOtpStep = false;
//   bool showPassword = false;
//   bool isLoading = false;

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final phoneController = TextEditingController();

//   List<String> otp = ["", "", "", "", "", ""];

//   final String baseUrl = "https://job-portal-fullstack-production.up.railway.app/api ";

//   Future<void> handleRegister() async {
//     if (nameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         phoneController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("All fields required ❌")));
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       final res = await http.post(
//         Uri.parse("$baseUrl/auth/register"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "name": nameController.text.trim(),
//           "email": emailController.text.trim(),
//           "password": passwordController.text.trim(),
//           "phone": phoneController.text.trim(),
//         }),
//       );

//       final data = jsonDecode(res.body);

//       if (data["success"] == true) {
//         final otpRes = await http.post(
//           Uri.parse("$baseUrl/otp/send"),
//           headers: {"Content-Type": "application/json"},
//           body: jsonEncode({"phone": phoneController.text.trim()}),
//         );

//         final otpData = jsonDecode(otpRes.body);

//         if (otpData["success"] == true) {
//           setState(() => isOtpStep = true);

//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(const SnackBar(content: Text("OTP Sent ✅")));
//         }
//       }
//     } catch (e) {
//       print(e);
//     }

//     setState(() => isLoading = false);
//   }

//   Future<void> handleVerifyOtp() async {
//     final enteredOtp = otp.join();

//     final res = await http.post(
//       Uri.parse("$baseUrl/otp/verify"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "phone": phoneController.text.trim(),
//         "otp": enteredOtp,
//       }),
//     );

//     final data = jsonDecode(res.body);

//     if (data["success"] == true) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FC),
//       body: Stack(
//         children: [
//           // 🔥 TOP BAR
//           Positioned(
//             top: 40,
//             left: 20,
//             right: 20,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Career Linker",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF00522D),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//           ),

//           // 🔥 MAIN
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
//             child: SingleChildScrollView(
//               child: isOtpStep ? otpUI() : registerUI(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🔥 REGISTER UI
//   Widget registerUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Create Account",
//           style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 6),
//         const Text("Join our professional community"),

//         const SizedBox(height: 20),

//         cardInput("Full Name", nameController, Icons.person),
//         cardInput("Email", emailController, Icons.email),
//         cardInput("Phone", phoneController, Icons.phone),

//         TextField(
//           controller: passwordController,
//           obscureText: !showPassword,
//           decoration: InputDecoration(
//             hintText: "Password",
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 showPassword ? Icons.visibility : Icons.visibility_off,
//               ),
//               onPressed: () {
//                 setState(() => showPassword = !showPassword);
//               },
//             ),
//           ),
//         ),

//         const SizedBox(height: 20),

//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF00522D),
//             minimumSize: const Size(double.infinity, 55),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//           onPressed: isLoading ? null : handleRegister,
//           child: isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text("Get Verification Code"),
//         ),
//       ],
//     );
//   }

//   // 🔥 OTP UI
//   Widget otpUI() {
//     return Column(
//       children: [
//         const Text(
//           "Verify Identity",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),

//         const SizedBox(height: 20),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(6, (i) {
//             return SizedBox(
//               width: 45,
//               child: TextField(
//                 maxLength: 1,
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   counterText: "",
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 onChanged: (val) => otp[i] = val,
//               ),
//             );
//           }),
//         ),

//         const SizedBox(height: 20),

//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF00522D),
//             minimumSize: const Size(double.infinity, 55),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//           onPressed: handleVerifyOtp,
//           child: const Text("Verify Account"),
//         ),
//       ],
//     );
//   }

//   Widget cardInput(String hint, TextEditingController ctrl, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextField(
//         controller: ctrl,
//         decoration: InputDecoration(
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.grey.shade100,
//           prefixIcon: Icon(icon),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  bool isOtpStep = false;
  bool showPassword = false;
  bool isLoading = false;
  bool isOtpLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  List<String> otp = ["", "", "", "", "", ""];
  List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  final String baseUrl =
      "https://job-portal-fullstack-production.up.railway.app/api ";

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
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
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
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      _showSnackBar("All fields required ❌", isError: true);
      return;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      _showSnackBar("Please enter a valid email address 📧", isError: true);
      return;
    }

    if (phoneController.text.trim().length < 10) {
      _showSnackBar("Please enter a valid phone number 📱", isError: true);
      return;
    }

    if (passwordController.text.trim().length < 6) {
      _showSnackBar("Password must be at least 6 characters 🔒", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "phone": phoneController.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        final otpRes = await http.post(
          Uri.parse("$baseUrl/otp/send"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"phone": phoneController.text.trim()}),
        );

        final otpData = jsonDecode(otpRes.body);

        if (otpData["success"] == true) {
          setState(() => isOtpStep = true);
          _showSnackBar("OTP Sent Successfully ✅", isError: false);
        } else {
          _showSnackBar("Failed to send OTP ❌", isError: true);
        }
      } else {
        _showSnackBar(
          data["message"] ?? "Registration failed ❌",
          isError: true,
        );
      }
    } catch (e) {
      _showSnackBar("Network error. Please try again 🌐", isError: true);
    }

    setState(() => isLoading = false);
  }

  Future<void> handleVerifyOtp() async {
    final enteredOtp = otp.join();

    if (enteredOtp.length != 6) {
      _showSnackBar("Please enter the 6-digit OTP 🔐", isError: true);
      return;
    }

    setState(() => isOtpLoading = true);

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/otp/verify"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phoneController.text.trim(),
          "otp": enteredOtp,
        }),
      );

      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        _showSnackBar("Account verified successfully! 🎉", isError: false);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      } else {
        _showSnackBar("Invalid OTP. Please try again ❌", isError: true);
      }
    } catch (e) {
      _showSnackBar(
        "Verification failed. Check your connection 🌐",
        isError: true,
      );
    }

    setState(() => isOtpLoading = false);
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

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _handleOtpChange(String value, int index) {
    setState(() {
      otp[index] = value;
    });

    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Stack(
        children: [
          // Animated Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [Color(0xFF1A1F3F), Color(0xFF0A0E27)],
                stops: [0.3, 1.0],
              ),
            ),
          ),

          // Decorative Blur Circles
          ...List.generate(3, (index) {
            final positions = [
              [MediaQuery.of(context).size.width - 50, -80.0, 280.0],
              [-100.0, MediaQuery.of(context).size.height * 0.5, 220.0],
              [
                MediaQuery.of(context).size.width - 150,
                MediaQuery.of(context).size.height - 100,
                180.0,
              ],
            ];
            return Positioned(
              top: positions[index][1],
              left: positions[index][0],
              child: Container(
                width: positions[index][2],
                height: positions[index][2],
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.green.shade800.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // Logo
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "CareerLinker",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 48), // Spacer for balance
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: isOtpStep ? _buildOtpUI() : _buildRegisterUI(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterUI() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "Create Account",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Join our professional community",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 40),

          // Form Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildInputField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person_outline,
                    hint: "John Doe",
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: emailController,
                    label: "Email Address",
                    icon: Icons.email_outlined,
                    hint: "john@example.com",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: phoneController,
                    label: "Phone Number",
                    icon: Icons.phone_outlined,
                    hint: "+91 98765 43210",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: passwordController,
                    label: "Password",
                    icon: Icons.lock_outline,
                    hint: "••••••••",
                    obscureText: !showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () =>
                          setState(() => showPassword = !showPassword),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isLoading
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.green.shade600.withOpacity(0.4),
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
                      onPressed: isLoading ? null : handleRegister,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              "Get Verification Code",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Terms & Conditions
          Center(
            child: Text(
              "By signing up, you agree to our Terms of Service\nand Privacy Policy",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpUI() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated OTP Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade600.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const Text(
              "Verify Your Identity",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter the 6-digit code sent to\n${phoneController.text}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 40),

            // OTP Input Fields
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: otp[index].isNotEmpty
                                ? const Color(0xFF00D68F)
                                : Colors.white.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: TextEditingController(text: otp[index]),
                          focusNode: otpFocusNodes[index],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) => _handleOtpChange(value, index),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Verify Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isOtpLoading
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.green.shade600.withOpacity(0.4),
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
                      onPressed: isOtpLoading ? null : handleVerifyOtp,
                      child: isOtpLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              "Verify Account",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Resend OTP
                  TextButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      try {
                        final otpRes = await http.post(
                          Uri.parse("$baseUrl/otp/send"),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "phone": phoneController.text.trim(),
                          }),
                        );
                        final otpData = jsonDecode(otpRes.body);
                        if (otpData["success"] == true) {
                          _showSnackBar(
                            "OTP resent successfully 📨",
                            isError: false,
                          );
                        }
                      } catch (e) {
                        _showSnackBar("Failed to resend OTP", isError: true);
                      }
                      setState(() => isLoading = false);
                    },
                    child: Text(
                      "Didn't receive the code? Resend",
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String hint = "",
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: Colors.green.shade400),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
