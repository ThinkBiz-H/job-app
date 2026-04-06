// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import 'job_detail_screen.dart';

// class ResultScreen extends StatefulWidget {
//   final String query;
//   final String exp;
//   final String location;

//   const ResultScreen({
//     super.key,
//     required this.query,
//     required this.exp,
//     required this.location,
//   });

//   @override
//   State<ResultScreen> createState() => _ResultScreenState();
// }

// class _ResultScreenState extends State<ResultScreen> {
//   String selectedExp = "";
//   String selectedSalary = "";
//   String selectedWorkType = "";

//   Future<List<dynamic>> fetchJobs() async {
//     final response = await ApiService.getJobs(
//       query: widget.query,
//       location: widget.location,
//       exp: selectedExp.isEmpty ? widget.exp : selectedExp,
//     );

//     return response;
//   }

//   // 🔥 OPEN FILTER
//   void openFilter(String type) {
//     List<String> options = [];

//     if (type == "Experience") {
//       options = ["0 Year", "1 Year", "2 Year", "3+ Year"];
//     } else if (type == "Salary") {
//       options = ["10k+", "20k+", "50k+"];
//     } else if (type == "Education") {
//       options = ["10th", "12th", "Graduate", "Post Graduate"];
//     } else if (type == "Distance") {
//       options = ["0-5 km", "5-10 km", "10-20 km"];
//     } else if (type == "Work Type") {
//       options = ["Full Time", "Part Time"];
//     } else if (type == "Work Shift") {
//       options = ["Day Shift", "Night Shift"];
//     } else if (type == "Gender") {
//       options = ["Male", "Female", "Other"];
//     } else {
//       options = ["Option 1", "Option 2"];
//     }

//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return ListView(
//           padding: const EdgeInsets.all(20),
//           children: options.map((e) {
//             return ListTile(
//               title: Text(e),
//               trailing: Icon(Icons.arrow_forward_ios, size: 14),
//               onTap: () {
//                 setState(() {
//                   if (type == "Experience") selectedExp = e;
//                   if (type == "Salary") selectedSalary = e;
//                   if (type == "Work Type") selectedWorkType = e;
//                 });

//                 Navigator.pop(context);
//               },
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   // 🔥 FILTER BOX
//   Widget filterBox(String title) {
//     return GestureDetector(
//       onTap: () => openFilter(title),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.green),
//         ),
//         child: Center(
//           child: Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6F8),

//       body: SafeArea(
//         child: Column(
//           children: [
//             // 🔝 TOP BAR
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.arrow_back),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Text(
//                         widget.query.isEmpty ? "All Jobs" : widget.query,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // 🔥 SWIPE FILTERS
//             SizedBox(
//               height: 60,
//               child: PageView(
//                 controller: PageController(viewportFraction: 0.5),
//                 children: [
//                   filterBox("Experience"),
//                   filterBox("Top Match"),
//                   filterBox("Salary"),
//                   filterBox("Distance"),
//                   filterBox("Education"),
//                   filterBox("Work Type"),
//                   filterBox("Work Shift"),
//                   filterBox("Gender"),
//                 ],
//               ),
//             ),

//             // 📋 JOB LIST
//             Expanded(
//               child: FutureBuilder(
//                 future: fetchJobs(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return const Center(child: Text("Server Error ❌"));
//                   }

//                   final jobs = snapshot.data as List;

//                   if (jobs.isEmpty) {
//                     return const Center(child: Text("No Jobs Found ❌"));
//                   }

//                   return ListView.builder(
//                     itemCount: jobs.length,
//                     itemBuilder: (context, index) {
//                       final job = jobs[index];

//                       return InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => JobDetailScreen(job: job),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(10),
//                           padding: const EdgeInsets.all(15),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 job['title']?.toString() ?? "",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(job['company']?.toString() ?? ""),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on, size: 16),
//                                   const SizedBox(width: 5),
//                                   Text(job['location']?.toString() ?? ""),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 "₹${job['salary']?['min'] ?? 0} - ₹${job['salary']?['max'] ?? 0}",
//                               ),
//                               const SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   tag("Full Time"),
//                                   tag(
//                                     "${job['experience']?['min'] ?? 0} Years",
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget tag(String text) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(text, style: const TextStyle(fontSize: 12)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'job_detail_screen.dart';

class ResultScreen extends StatefulWidget {
  final String query;
  final String exp;
  final String location;

  const ResultScreen({
    super.key,
    required this.query,
    required this.exp,
    required this.location,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  String selectedExp = "";
  String selectedSalary = "";
  String selectedWorkType = "";
  String selectedEducation = "";
  String selectedDistance = "";
  String selectedWorkShift = "";
  String selectedGender = "";

  bool isLoading = false;
  List<dynamic> jobs = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

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

    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });

    _loadJobs();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService.getJobs(
        query: widget.query,
        location: widget.location,
        exp: selectedExp.isEmpty ? widget.exp : selectedExp,
      );

      setState(() {
        jobs = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar("Failed to load jobs", isError: true);
    }
  }

  void _applyFilters() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService.getJobs(
        query: widget.query,
        location: widget.location,
        exp: selectedExp.isEmpty ? widget.exp : selectedExp,
      );

      setState(() {
        jobs = response;
        isLoading = false;
      });
      _showSnackBar("Filters applied", isError: false);
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar("Failed to apply filters", isError: true);
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

  void _openFilter(String type, List<String> options, String currentValue) {
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
                        if (type == "Education")
                          selectedEducation = option == "All" ? "" : option;
                        if (type == "Distance")
                          selectedDistance = option == "All" ? "" : option;
                        if (type == "Work Shift")
                          selectedWorkShift = option == "All" ? "" : option;
                        if (type == "Gender")
                          selectedGender = option == "All" ? "" : option;
                      });
                      Navigator.pop(context);
                      _applyFilters();
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

  void _clearAllFilters() {
    setState(() {
      selectedExp = "";
      selectedSalary = "";
      selectedWorkType = "";
      selectedEducation = "";
      selectedDistance = "";
      selectedWorkShift = "";
      selectedGender = "";
    });
    _applyFilters();
  }

  int get _activeFiltersCount {
    int count = 0;
    if (selectedExp.isNotEmpty) count++;
    if (selectedSalary.isNotEmpty) count++;
    if (selectedWorkType.isNotEmpty) count++;
    if (selectedEducation.isNotEmpty) count++;
    if (selectedDistance.isNotEmpty) count++;
    if (selectedWorkShift.isNotEmpty) count++;
    if (selectedGender.isNotEmpty) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFF0A0E27),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              widget.query.isEmpty ? "All Jobs" : widget.query,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (_activeFiltersCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "$_activeFiltersCount",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: _clearAllFilters,
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              title: AnimatedOpacity(
                opacity: _isScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text(
                  "Search Results",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E27),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip("Experience", [
                      "All",
                      "0 Year",
                      "1 Year",
                      "2 Years",
                      "3+ Years",
                      "5+ Years",
                    ], selectedExp),
                    const SizedBox(width: 8),
                    _buildFilterChip("Salary", [
                      "All",
                      "10k+",
                      "20k+",
                      "50k+",
                      "1L+",
                      "2L+",
                    ], selectedSalary),
                    const SizedBox(width: 8),
                    _buildFilterChip("Work Type", [
                      "All",
                      "Full Time",
                      "Part Time",
                      "Remote",
                      "Hybrid",
                    ], selectedWorkType),
                    const SizedBox(width: 8),
                    _buildFilterChip("Education", [
                      "All",
                      "10th",
                      "12th",
                      "Graduate",
                      "Post Graduate",
                      "MBA",
                    ], selectedEducation),
                    const SizedBox(width: 8),
                    _buildFilterChip("Distance", [
                      "All",
                      "0-5 km",
                      "5-10 km",
                      "10-20 km",
                      "20-50 km",
                    ], selectedDistance),
                    const SizedBox(width: 8),
                    _buildFilterChip("Work Shift", [
                      "All",
                      "Day Shift",
                      "Night Shift",
                      "Flexible",
                    ], selectedWorkShift),
                    const SizedBox(width: 8),
                    _buildFilterChip("Gender", [
                      "All",
                      "Male",
                      "Female",
                      "Other",
                    ], selectedGender),
                  ],
                ),
              ),
            ),
          ),

          // Results Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${jobs.length} Jobs Found",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (!isLoading && jobs.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _showSortOptions();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.sort, size: 16),
                          SizedBox(width: 4),
                          Text("Sort"),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Job List
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D68F)),
                ),
              ),
            )
          else if (jobs.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final job = jobs[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildJobCard(job, index),
                  );
                }, childCount: jobs.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    List<String> options,
    String currentValue,
  ) {
    final isActive = currentValue.isNotEmpty;
    return GestureDetector(
      onTap: () => _openFilter(label, options, currentValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? currentValue : label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade300,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_circle, size: 14, color: Colors.white),
            ] else ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ],
          ],
        ),
      ),
    );
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
            );
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
                        Icon(Icons.whatshot, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "Urgently Hiring",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Company Icon & Title
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
                            job['title']?.toString() ?? "Job Title",
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
                            job['company']?.toString() ?? "Company",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Details
                Row(
                  children: [
                    _buildDetailChip(
                      Icons.location_on,
                      job['location']?.toString() ?? "Location",
                    ),
                    const SizedBox(width: 12),
                    _buildDetailChip(
                      Icons.currency_rupee,
                      _formatSalary(job['salary']),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag("Full Time"),
                    _buildTag(
                      job['experience'] is Map
                          ? "${job['experience']['min'] ?? 0}+ Years"
                          : job['experience']?.toString() ?? "Any",
                    ),
                  ],
                ),

                const SizedBox(height: 12),

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

  Widget _buildDetailChip(IconData icon, String text) {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Jobs Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search or filters",
            style: TextStyle(color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D68F),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _clearAllFilters,
            child: const Text("Clear Filters"),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Sort By",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            _buildSortOption("Latest First"),
            _buildSortOption("Salary: Low to High"),
            _buildSortOption("Salary: High to Low"),
            _buildSortOption("Most Relevant"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: () {
        Navigator.pop(context);
        _showSnackBar("Sorting by $label", isError: false);
      },
    );
  }

  String _formatSalary(dynamic salary) {
    if (salary == null) return "Not specified";

    if (salary is Map) {
      return "₹${salary["min"] ?? 0} - ₹${salary["max"] ?? 0}";
    }

    return salary.toString(); // 🔥 IMPORTANT
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
      }
      return "Just now";
    } catch (e) {
      return "Recently posted";
    }
  }
}
