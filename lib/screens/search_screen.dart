// import 'package:flutter/material.dart';
// import 'result_screen.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController searchController = TextEditingController();

//   String selectedExp = "Select Experience";
//   String selectedLocation = "Select Location";

//   List<String> expList = List.generate(16, (i) => "$i Years");

//   List<String> locations = [
//     "Delhi",
//     "Mumbai",
//     "Noida",
//     "Bangalore",
//     "Hyderabad",
//     "Chennai",
//     "Kolkata",
//     "Pune",
//     "Ahmedabad",
//     "Jaipur",
//     "Lucknow",
//   ];

//   bool showExpDropdown = false;
//   bool showLocationDropdown = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6F8),

//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // 🔙 BACK
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.arrow_back),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 5),

//                   // ================= JOB INPUT =================
//                   boxInput(
//                     child: TextField(
//                       controller: searchController,
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Search job title...",
//                         icon: Icon(Icons.search),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // ================= EXPERIENCE =================
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             showExpDropdown = !showExpDropdown;
//                             showLocationDropdown = false;
//                           });
//                         },
//                         child: inputBox(selectedExp, Icons.work),
//                       ),

//                       if (showExpDropdown)
//                         dropdownList(expList, (val) {
//                           setState(() {
//                             selectedExp = val;
//                             showExpDropdown = false;
//                           });
//                         }),
//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   // ================= LOCATION =================
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             showLocationDropdown = !showLocationDropdown;
//                             showExpDropdown = false;
//                           });
//                         },
//                         child: inputBox(selectedLocation, Icons.location_on),
//                       ),

//                       if (showLocationDropdown)
//                         dropdownList(locations, (val) {
//                           setState(() {
//                             selectedLocation = val;
//                             showLocationDropdown = false;
//                           });
//                         }),
//                     ],
//                   ),

//                   const SizedBox(height: 15),

//                   // 🔍 SEARCH BUTTON
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ResultScreen(
//                             query: searchController.text.trim(),
//                             exp: selectedExp,
//                             location: selectedLocation,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Search",
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔹 UI HELPERS
//   Widget inputBox(String text, IconData icon) {
//     return boxInput(
//       child: Row(
//         children: [
//           Icon(icon),
//           const SizedBox(width: 10),
//           Text(text),
//           const Spacer(),
//           const Icon(Icons.arrow_drop_down),
//         ],
//       ),
//     );
//   }

//   Widget boxInput({required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: child,
//     );
//   }

//   Widget dropdownList(List<String> list, Function(String) onTap) {
//     return Container(
//       height: 200,
//       margin: const EdgeInsets.only(top: 5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ListView.builder(
//         itemCount: list.length,
//         itemBuilder: (_, i) {
//           return ListTile(title: Text(list[i]), onTap: () => onTap(list[i]));
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  String selectedExp = "Experience";
  String selectedLocation = "Location";
  String selectedJobType = "Job Type";

  final List<String> expList = List.generate(
    16,
    (i) => i == 0 ? "Fresher" : "$i Years",
  );

  final List<String> locations = [
    "All Locations",
    "Delhi NCR",
    "Mumbai",
    "Bangalore",
    "Hyderabad",
    "Chennai",
    "Kolkata",
    "Pune",
    "Ahmedabad",
    "Jaipur",
    "Lucknow",
    "Chandigarh",
    "Remote",
  ];

  final List<String> jobTypes = [
    "All Types",
    "Full Time",
    "Part Time",
    "Remote",
    "Hybrid",
    "Contract",
    "Internship",
  ];

  String? selectedExpValue;
  String? selectedLocationValue;
  String? selectedJobTypeValue;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation = AlwaysStoppedAnimation(1.0);
  late Animation<Offset> _slideAnimation;

  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  final List<String> recentSearches = [
    "Flutter Developer",
    "React Native",
    "UI/UX Designer",
    "Backend Engineer",
  ];

  final List<String> trendingJobs = [
    "AI Engineer",
    "Data Scientist",
    "Cloud Architect",
    "DevOps Engineer",
  ];

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = searchController.text.trim();
    if (query.isEmpty &&
        selectedExp == "Experience" &&
        selectedLocation == "Location") {
      _showSnackBar(
        "Please enter a job title or select filters",
        isError: true,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          query: query,
          exp: selectedExp == "Experience" ? "" : selectedExp,
          location: selectedLocation == "Location" ? "" : selectedLocation,
        ),
      ),
    );
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

  void _clearFilters() {
    setState(() {
      selectedExp = "Experience";
      selectedLocation = "Location";
      selectedJobType = "Job Type";
      selectedExpValue = null;
      selectedLocationValue = null;
      selectedJobTypeValue = null;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              child: Column(
                children: [
                  // Top Bar
                  Row(
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
                      const Spacer(),
                      Text(
                        "Search Jobs",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      if (_isSearchFocused ||
                          selectedExp != "Experience" ||
                          selectedLocation != "Location" ||
                          selectedJobType != "Job Type")
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(
                      0,
                      _isSearchFocused ? -5 : 0,
                      0,
                    ),
                    child: Container(
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
                      child: TextField(
                        controller: searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Search by job title, company...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF00D68F),
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        onSubmitted: (_) => _performSearch(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Section
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: FadeTransition(
                  opacity: _animationController,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Title
                        const Text(
                          "Filter by",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Filter Chips
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterChip(
                                icon: Icons.work_outline,
                                label: selectedExp,
                                options: expList,
                                onSelected: (value) {
                                  setState(() {
                                    selectedExp = value;
                                    selectedExpValue = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFilterChip(
                                icon: Icons.location_on_outlined,
                                label: selectedLocation,
                                options: locations,
                                onSelected: (value) {
                                  setState(() {
                                    selectedLocation = value;
                                    selectedLocationValue = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildFilterChip(
                          icon: Icons.work_history_outlined,
                          label: selectedJobType,
                          options: jobTypes,
                          onSelected: (value) {
                            setState(() {
                              selectedJobType = value;
                              selectedJobTypeValue = value;
                            });
                          },
                        ),

                        const SizedBox(height: 32),

                        // Search Button
                        _buildSearchButton(),

                        const SizedBox(height: 32),

                        // Recent Searches
                        if (recentSearches.isNotEmpty && !_isSearchFocused)
                          _buildRecentSearches(),

                        const SizedBox(height: 24),

                        // Trending Jobs
                        if (!_isSearchFocused) _buildTrendingSection(),

                        const SizedBox(height: 24),

                        // Popular Locations
                        if (!_isSearchFocused) _buildPopularLocations(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return GestureDetector(
      onTap: () {
        _showFilterBottomSheet(icon, label, options, onSelected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                label != "Experience" &&
                    label != "Location" &&
                    label != "Job Type"
                ? const Color(0xFF00D68F).withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF00D68F)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color:
                      label != "Experience" &&
                          label != "Location" &&
                          label != "Job Type"
                      ? Colors.white
                      : Colors.grey.shade400,
                  fontWeight:
                      label != "Experience" &&
                          label != "Location" &&
                          label != "Job Type"
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(
    IconData icon,
    String currentLabel,
    List<String> options,
    Function(String) onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
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
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFF00D68F)),
                  const SizedBox(width: 12),
                  Text(
                    "Select ${currentLabel.split(' ').first}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: options.length,
                itemBuilder: (_, index) {
                  final option = options[index];
                  final isSelected =
                      (currentLabel == option) ||
                      (currentLabel == "Experience" &&
                          option == "Fresher" &&
                          index == 0);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF00D68F), Color(0xFF00875A)],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.05),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D68F), Color(0xFF00875A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
        onPressed: _performSearch,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Find Jobs",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Searches",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                _showSnackBar("Recent searches cleared", isError: false);
              },
              child: const Text(
                "Clear",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: recentSearches.map((search) {
            return GestureDetector(
              onTap: () {
                searchController.text = search;
                _performSearch();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.history,
                      size: 14,
                      color: Color(0xFF00D68F),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      search,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Trending Jobs 🔥",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: trendingJobs.map((job) {
            return GestureDetector(
              onTap: () {
                searchController.text = job;
                _performSearch();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade900.withOpacity(0.3),
                      Colors.orange.shade800.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.shade700.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      job,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularLocations() {
    final popularLocations = locations
        .where((l) => l != "All Locations")
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Locations 📍",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: popularLocations.map((location) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedLocation = location;
                  selectedLocationValue = location;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFF00D68F),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
