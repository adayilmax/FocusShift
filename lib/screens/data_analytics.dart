import 'package:flutter/material.dart';
import 'dart:math'; // For generating random numbers

// Removed hardcoded color constants like kAppBackgroundColor
// We will use Theme colors instead.

// Renamed class to follow convention
class DataAnalytics extends StatelessWidget {
  // Added const constructor with key
  const DataAnalytics({Key? key}) : super(key: key);

  // Generate some random data for the cards
  // Kept this mock data structure
  final List<Map<String, String>> cardData = const [
    {"title": "Project Alpha", "subtitle": "Team A"},
    {"title": "Marketing Plan", "subtitle": "Sales Dept."},
    {"title": "User Research", "subtitle": "UX Team"},
    {"title": "Budget Review", "subtitle": "Finance"},
  ];

  @override
  Widget build(BuildContext context) {
    final Random random = Random(); // Instance for random numbers

    // --- Get Theme Data ---
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    // Define subtle text color based on theme
    final subtleTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    // --- End Theme Data ---

    return Scaffold(
      // Use theme scaffold background color
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // Use theme app bar background (or scaffold color for seamless)
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        // Use theme icon theme color
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Color from iconTheme
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
        // Add title back if needed, using theme text color
        title: Text(
          "Data Analytics",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            // Use theme primary or secondary color for accent icons
            icon: Icon(Icons.notifications_none_outlined, color: colorScheme.secondary),
            onPressed: () {},
          ),
          SizedBox(width: 8),
          IconButton(
            // Use theme primary or secondary color for accent icons
            icon: Icon(Icons.account_circle_outlined, color: colorScheme.secondary),
            onPressed: () {
              // Navigate to profile screen
              Navigator.pushNamed(context, '/profile');
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        children: [
          // --- Top Section ---
          Container(
            // Use theme surface or background color
            color: theme.cardColor, // Often same as card background
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Column(
              children: [
                // --- Chart Image (Using Asset) ---
                Container(
                  height: 200,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // Use a theme-aware background color
                    color: isDark ? Colors.grey[850] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/mock_images/example_chart.png', // Your asset path
                    fit: BoxFit.contain, // Changed fit to contain to see whole chart
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: colorScheme.error, size: 40,),
                              SizedBox(height: 4),
                              Text('Could not load chart', style: TextStyle(color: colorScheme.error))
                            ],
                          )
                      );
                    },
                  ),
                ),
                // --- END Chart Image ---
                SizedBox(height: 24),
                // --- Button Row ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add Focus button action
                      },
                      style: ElevatedButton.styleFrom(
                        // Use theme colors for button
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: Text('Focus', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),

          // --- Bottom Section ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align header left
              children: [
                // --- Header Row ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Use theme text style
                    Text(
                        "My Tasks",
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    TextButton(
                        onPressed: () {},
                        // Use theme subtle text color
                        child: Text("View All", style: TextStyle(color: subtleTextColor))
                    )
                  ],
                ),
                SizedBox(height: 16),

                // --- Grid with Content ---
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: cardData.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        // Use theme card color
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          // Adjust shadow based on theme
                          boxShadow: [
                            BoxShadow(
                                color: isDark ? Colors.black26 : Colors.grey.shade300,
                                blurRadius: 4,
                                offset: Offset(0, 2)
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Use theme secondary color for accent circle
                                CircleAvatar(radius: 18, backgroundColor: colorScheme.secondary.withOpacity(0.3)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cardData[index]['title']!,
                                          // Use theme text style
                                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          cardData[index]['subtitle']!,
                                          // Use theme subtle text color
                                          style: textTheme.bodySmall?.copyWith(color: subtleTextColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]
                                  ),
                                ),
                              ]),
                          Spacer(),
                          Row(
                            children: [
                              // Use theme subtle text color for icon
                              Icon(Icons.show_chart_rounded, color: subtleTextColor, size: 16),
                              SizedBox(width: 4),
                              Text(
                                  "${random.nextInt(8) + 1}% (+0.${random.nextInt(90).toString().padLeft(2,'0')}%)",
                                  // Use theme subtle text color
                                  style: textTheme.bodySmall?.copyWith(color: subtleTextColor, fontWeight: FontWeight.w500)
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}