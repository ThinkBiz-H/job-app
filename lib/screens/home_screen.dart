import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'job_detail_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../utils/user_session.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> jobs = [];
  bool isLoading = true;
  Set<String> appliedJobIds = {};
  // Filter States
  String selectedExp = "";
  String selectedSalary = "";
  String selectedWorkType = "";

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    fetchJobs();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchAppliedJobs() async {
    final token = UserSession.user?["token"];
    if (token == null) return;

    try {
      final res = await http.get(
        Uri.parse("${ApiService.baseUrl}/jobs/my-applications"),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(res.body);
      final appliedJobs = data["data"] ?? [];

      appliedJobIds = appliedJobs
          .map<String>((app) => app["job"]["_id"].toString())
          .toSet();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchJobs() async {
    setState(() => isLoading = true);

    try {
      final data = await ApiService.getJobs(
        exp: selectedExp,
        salary: selectedSalary,
        workType: selectedWorkType,
      );

      data.sort((a, b) {
        final aDate = DateTime.tryParse(a["createdAt"] ?? "") ?? DateTime.now();
        final bDate = DateTime.tryParse(b["createdAt"] ?? "") ?? DateTime.now();
        return bDate.compareTo(aDate);
      });

      await fetchAppliedJobs(); // 👈 pehle applied jobs lao

      final filteredJobs = data.where((job) {
        return !appliedJobIds.contains(job["_id"]);
      }).toList();

      final latestJobs = filteredJobs.take(25).toList();

      setState(() {
        jobs = latestJobs;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void openFilter(String type) {
    List<String> options = [];
    String currentValue = "";

    if (type == "Experience") {
      options = ["All", "0 Year", "1 Year", "2 Years", "3+ Years"];
      currentValue = selectedExp;
    } else if (type == "Salary") {
      options = ["All", "10k+", "20k+", "50k+", "1L+"];
      currentValue = selectedSalary;
    } else if (type == "Work Type") {
      options = ["All", "Full Time", "Part Time", "Remote", "Hybrid"];
      currentValue = selectedWorkType;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _buildFilterSheet(type, options, currentValue),
    );
  }

  Widget _buildFilterSheet(
    String type,
    List<String> options,
    String currentValue,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1F3F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Select $type",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ...options.map((option) {
                  final isSelected = option == currentValue;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (type == "Experience")
                          selectedExp = option == "All" ? "" : option;
                        if (type == "Salary")
                          selectedSalary = option == "All" ? "" : option;
                        if (type == "Work Type")
                          selectedWorkType = option == "All" ? "" : option;
                      });
                      Navigator.pop(context);
                      fetchJobs();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.08),
                                  Colors.white.withOpacity(0.03),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatSalary(dynamic salary) {
    if (salary == null) return "Salary not specified";

    if (salary is Map) {
      return "₹${salary["min"] ?? 0} - ₹${salary["max"] ?? 0}";
    }

    return salary.toString(); // 🔥 fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Animated Header
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(),
              title: AnimatedOpacity(
                opacity: _isScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text(
                  "CareerLinker",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              // Profile Button in AppBar when scrolled
              if (_isScrolled)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildProfileAvatar(isSmall: true),
                ),
            ],
          ),

          // Job List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (jobs.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No jobs found",
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  );
                }

                final job = jobs[index];
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildJobCard(job, index),
                );
              }, childCount: isLoading ? 1 : jobs.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00D68F), Color(0xFF00875A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find Your",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Dream Job",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  _buildProfileAvatar(isSmall: false),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFF00D68F)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Search jobs by title, company...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Filter Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip(
                      "Experience",
                      selectedExp.isNotEmpty ? selectedExp : null,
                    ),
                    const SizedBox(width: 12),
                    _buildFilterChip(
                      "Salary",
                      selectedSalary.isNotEmpty ? selectedSalary : null,
                    ),
                    const SizedBox(width: 12),
                    _buildFilterChip(
                      "Work Type",
                      selectedWorkType.isNotEmpty ? selectedWorkType : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isActive = value != null;
    return GestureDetector(
      onTap: () => openFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF00D68F)
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Text(
              isActive ? value! : label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (label == "Experience") selectedExp = "";
                    if (label == "Salary") selectedSalary = "";
                    if (label == "Work Type") selectedWorkType = "";
                  });
                  fetchJobs();
                },
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar({required bool isSmall}) {
    final user = UserSession.user;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
          ],
        ),
        child: CircleAvatar(
          radius: isSmall ? 18 : 24,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: _buildAvatarContent(user, isSmall),
        ),
      ),
    );
  }

  Widget _buildAvatarContent(dynamic user, bool isSmall) {
    try {
      final img = user?["profileImage"];

      if (img != null && img.toString().contains("base64")) {
        final base64Str = img.split(",").last;
        return ClipOval(
          child: Image.memory(
            base64Decode(base64Str),
            width: isSmall ? 36 : 48,
            height: isSmall ? 36 : 48,
            fit: BoxFit.cover,
          ),
        );
      }

      if (img != null && img.toString().startsWith("http")) {
        return ClipOval(
          child: Image.network(
            img,
            width: isSmall ? 36 : 48,
            height: isSmall ? 36 : 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.person, size: isSmall ? 18 : 24),
          ),
        );
      }
    } catch (e) {
      print("Image error: $e");
    }

    return Icon(Icons.person, size: isSmall ? 18 : 24, color: Colors.white);
  }

  Widget _buildJobCard(dynamic job, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
            );

            fetchJobs(); // 🔥 back aate hi refresh
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Badge
                if (job["isFeatured"] == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.whatshot, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "Urgently Hiring",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Job Title & Company
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.business_center,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (job["title"] ?? "Job Title").toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (job["company"] ?? "Company").toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Job Details
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      Icons.location_on,
                      (job["location"] ?? "Location").toString(),
                    ),
                    _buildInfoChip(
                      Icons.currency_rupee,
                      formatSalary(job["salary"]),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag("Work from Office"),
                    _buildTag("Full Time"),
                    if (job["experience"] != null &&
                        job["experience"].toString() != "{min: 0, max: 0}")
                      _buildTag(
                        "${job["experience"]["min"] ?? 0}-${job["experience"]["max"] ?? 0} Years",
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Posted Time
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _getTimeAgo(job["createdAt"]),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF00D68F)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
      ),
    );
  }

  String _getTimeAgo(String? dateString) {
    if (dateString == null) return "Recently posted";

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return "${difference.inDays ~/ 7} weeks ago";
      } else if (difference.inDays > 0) {
        return "${difference.inDays} days ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours} hours ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes} minutes ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "Recently posted";
    }
  }
}
