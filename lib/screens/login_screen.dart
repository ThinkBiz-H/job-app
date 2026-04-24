// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../utils/user_session.dart';
// import 'home_screen.dart';
// import 'register_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool isLoading = false;
//   bool showPassword = false;

//   void handleLogin() async {
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter email & password")));
//       return;
//     }

//     setState(() => isLoading = true);

//     final res = await ApiService.login(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//     );

//     setState(() => isLoading = false);

//     if (res != null && res["success"] == true) {
//       final data = res["data"];
//       final token = res["token"] ?? data?["token"];
//       final user = data?["user"] ?? data;

//       if (user != null && token != null) {
//         UserSession.user = {...user, "token": token};

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login Failed ❌")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(colors: [Color(0xFFE3F2FD), Colors.white]),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               margin: const EdgeInsets.all(20),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 20,
//                     color: Colors.black.withOpacity(0.1),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // 🔥 HEADER
//                   const Icon(Icons.lock, size: 50, color: Color(0xFF0F2A44)),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Welcome Back",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),

//                   // EMAIL
//                   TextField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.email),
//                       hintText: "Email",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 15),

//                   // PASSWORD
//                   TextField(
//                     controller: passwordController,
//                     obscureText: !showPassword,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.lock),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           showPassword
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                         ),
//                         onPressed: () {
//                           setState(() => showPassword = !showPassword);
//                         },
//                       ),
//                       hintText: "Password",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // LOGIN BUTTON
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0F2A44),
//                       padding: const EdgeInsets.all(15),
//                     ),
//                     onPressed: isLoading ? null : handleLogin,
//                     child: isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Sign In"),
//                   ),

//                   const SizedBox(height: 20),

//                   // 🔥 REGISTER LINK
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't have an account? "),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const RegisterScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "Register",
//                           style: TextStyle(
//                             color: Color(0xFF0F2A44),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../utils/user_session.dart';
// import 'home_screen.dart';
// import 'register_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool isLoading = false;
//   bool showPassword = false;

//   void handleLogin() async {
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter email & password")));
//       return;
//     }

//     setState(() => isLoading = true);

//     final res = await ApiService.login(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//     );

//     setState(() => isLoading = false);

//     if (res != null && res["success"] == true) {
//       final data = res["data"];
//       final token = res["token"] ?? data?["token"];
//       final user = data?["user"] ?? data;

//       if (user != null && token != null) {
//         UserSession.user = {...user, "token": token};

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login Failed ❌")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FC),
//       body: Stack(
//         children: [
//           // 🔥 BACKGROUND BLOBS
//           Positioned(
//             top: -100,
//             left: -50,
//             child: Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -100,
//             right: -50,
//             child: Container(
//               width: 250,
//               height: 250,
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           // 🔥 MAIN UI
//           Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     // 🔥 LOGO TEXT
//                     ShaderMask(
//                       shaderCallback: (bounds) => const LinearGradient(
//                         colors: [Color(0xFF00522D), Color(0xFF00A86B)],
//                       ).createShader(bounds),
//                       child: const Text(
//                         "Career Linker",
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     const Text(
//                       "Welcome Back 👋",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),

//                     const SizedBox(height: 30),

//                     // 🔥 CARD
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 20,
//                             color: Colors.black.withOpacity(0.05),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           // EMAIL
//                           TextField(
//                             controller: emailController,
//                             decoration: InputDecoration(
//                               labelText: "Email Address",
//                               filled: true,
//                               fillColor: Colors.grey.shade100,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 15),

//                           // PASSWORD
//                           TextField(
//                             controller: passwordController,
//                             obscureText: !showPassword,
//                             decoration: InputDecoration(
//                               labelText: "Password",
//                               filled: true,
//                               fillColor: Colors.grey.shade100,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   showPassword
//                                       ? Icons.visibility
//                                       : Icons.visibility_off,
//                                 ),
//                                 onPressed: () {
//                                   setState(() => showPassword = !showPassword);
//                                 },
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 10),

//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton(
//                               onPressed: () {},
//                               child: const Text("Forgot Password?"),
//                             ),
//                           ),

//                           const SizedBox(height: 10),

//                           // 🔥 LOGIN BUTTON
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF00522D),
//                               minimumSize: const Size(double.infinity, 55),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             onPressed: isLoading ? null : handleLogin,
//                             child: isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text("Login"),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // REGISTER
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Don’t have an account? "),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const RegisterScreen(),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             "Register",
//                             style: TextStyle(
//                               color: Color(0xFF00522D),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/user_session.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // void handleLogin() async {
  //   if (emailController.text.isEmpty || passwordController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text("Enter email & password"),
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: Colors.red.shade400,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //       ),
  //     );
  //     return;
  //   }

  //   setState(() => isLoading = true);

  //   final res = await ApiService.login(
  //     email: emailController.text.trim(),
  //     password: passwordController.text.trim(),
  //   );

  //   setState(() => isLoading = false);

  //   if (res != null && res["success"] == true) {
  //     final data = res["data"];
  //     final token = res["token"] ?? data?["token"];
  //     final user = data?["user"] ?? data;

  //     if (user != null && token != null) {
  //       UserSession.user = {...user, "token": token};

  //       if (!mounted) return;
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const HomeScreen()),
  //       );
  //     }
  //   } else {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text("Login Failed ❌"),
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: Colors.red.shade400,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //       ),
  //     );
  //   }
  // }

  void handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text("Enter email & password")));
      return;
    }

    setState(() => isLoading = true);

    final res = await ApiService.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (res != null && res["success"] == true) {
      final data = res["data"];
      final token = res["token"] ?? data?["token"];
      final user = data?["user"] ?? data;

      if (user != null && token != null) {
        // user session
        UserSession.user = {...user, "token": token};

        // 🔥 SAVE LOGIN
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("token", token);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text("Login Failed ❌")));
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
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [Color(0xFF1A1F3F), Color(0xFF0A0E27)],
                stops: [0.3, 1.0],
              ),
            ),
          ),

          // Decorative Blur Circles
          ...List.generate(3, (index) {
            final positions = [
              [50.0, -50.0, 300.0],
              [-80.0, MediaQuery.of(context).size.height * 0.4, 250.0],
              [
                MediaQuery.of(context).size.width - 100,
                MediaQuery.of(context).size.height - 200,
                200.0,
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
                      Colors.green.shade800.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          // Subtle Grid Pattern
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Section
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade600.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.work_outline,
                            size: 42,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Brand Name
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF00D68F), Color(0xFF4CAF50)],
                          ).createShader(bounds),
                          child: const Text(
                            "CareerLinker",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: Colors.white, // 🔥 required
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Login Card
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
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  children: [
                                    // Email Field
                                    _buildInputField(
                                      controller: emailController,
                                      label: "Email Address",
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 20),

                                    // Password Field
                                    _buildInputField(
                                      controller: passwordController,
                                      label: "Password",
                                      icon: Icons.lock_outline,
                                      obscureText: !showPassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey.shade400,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () => showPassword = !showPassword,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Forgot Password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.green.shade300,
                                        ),
                                        child: const Text(
                                          "Forgot Password?",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Login Button
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF00D68F),
                                            Color(0xFF00875A),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: isLoading
                                            ? null
                                            : [
                                                BoxShadow(
                                                  color: Colors.green.shade600
                                                      .withOpacity(0.4),
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
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : handleLogin,
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              )
                                            : const Text(
                                                "Sign In",
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
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
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

// Custom painter for subtle grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom blur filter for glassmorphism
class UIBlurFilter {
  final double sigmaX;
  final double sigmaY;

  const UIBlurFilter({required this.sigmaX, required this.sigmaY});

  ImageFilter get filter => ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY);
}
