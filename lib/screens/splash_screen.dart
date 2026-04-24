// import 'package:flutter/material.dart';
// import 'login_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeIn,
//     );

//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: Curves.easeOutCubic,
//           ),
//         );

//     _animationController.forward();

//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.center,
//             radius: 1.5,
//             colors: [Color(0xFF1A1F3F), Color(0xFF0A0E27)],
//             stops: [0.3, 1.0],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Animated Background Circles
//             ...List.generate(3, (index) {
//               final positions = [
//                 [200.0, -100.0, 300.0, 0.8],
//                 [-100.0, 300.0, 250.0, 0.6],
//                 [
//                   MediaQuery.of(context).size.width - 150,
//                   MediaQuery.of(context).size.height - 200,
//                   200.0,
//                   0.4,
//                 ],
//               ];
//               return TweenAnimationBuilder(
//                 tween: Tween<double>(begin: 0, end: 1),
//                 duration: Duration(milliseconds: 2000 + (index * 500)),
//                 builder: (context, value, child) {
//                   return Positioned(
//                     top: positions[index][1] * (1 - value * 0.3),
//                     left: positions[index][0] * (1 - value * 0.2),
//                     child: Opacity(
//                       opacity: value * positions[index][3],
//                       child: Container(
//                         width: positions[index][2],
//                         height: positions[index][2],
//                         decoration: BoxDecoration(
//                           gradient: RadialGradient(
//                             colors: [
//                               Colors.green.shade800.withOpacity(0.15),
//                               Colors.transparent,
//                             ],
//                           ),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),

//             // Main Content
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Animated Logo Container
//                   FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [Color(0xFF00D68F), Color(0xFF00875A)],
//                           ),
//                           borderRadius: BorderRadius.circular(32),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF00D68F).withOpacity(0.5),
//                               blurRadius: 30,
//                               spreadRadius: 10,
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.work_outline,
//                           size: 60,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Animated Title
//                   SlideTransition(
//                     position: _slideAnimation,
//                     child: Column(
//                       children: [
//                         ShaderMask(
//   shaderCallback: (bounds) => const LinearGradient(
//     colors: [Color(0xFF00D68F), Color(0xFF4CAF50)],
//   ).createShader(bounds),
//   child: const Text(
//     "CareerLinker",
//     style: TextStyle(
//       fontSize: 42,
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//       letterSpacing: -0.5,
//       shadows: [
//         Shadow(
//           blurRadius: 20,
//           color: Color(0x5500D68F),
//         )
//       ],
//     ),
//   ),
// ),
//                         const SizedBox(height: 12),
//                         Text(
//                           "Find Your Dream Job",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey.shade400,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 80),

//                   // Loading Indicator
//                   TweenAnimationBuilder(
//                     tween: Tween<double>(begin: 0, end: 1),
//                     duration: const Duration(seconds: 2),
//                     builder: (context, value, child) {
//                       return Column(
//                         children: [
//                           SizedBox(
//                             width: 40,
//                             height: 40,
//                             child: CircularProgressIndicator(
//                               value: value,
//                               strokeWidth: 3,
//                               valueColor: const AlwaysStoppedAnimation<Color>(
//                                 Color(0xFF00D68F),
//                               ),
//                               backgroundColor: Colors.white.withOpacity(0.1),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             "Loading...",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade500,
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             // Version Text at Bottom
//             Positioned(
//               bottom: 20,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Text(
//                   "Version 1.0.0",
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF1A1F3F), Color(0xFF0A0E27)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.work,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SlideTransition(
                    position: _slideAnimation,
                    child: const Text(
                      "CareerLinker",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
