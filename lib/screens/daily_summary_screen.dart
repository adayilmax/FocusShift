import 'package:flutter/material.dart';

// Define the primary color used in this screen locally, if needed
// Or rely on Theme.of(context).colorScheme.primary or accentColor
const Color _kPrimaryColor = Colors.greenAccent; // Example color

class DailySummaryScreen extends StatelessWidget {
  // Add Key constructor
  const DailySummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generalTextColor = isDark ? Colors.white : Colors.black;
    final theme = Theme.of(context); // Get theme data

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: generalTextColor),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
        ),
        // Correct AppBar Title
        title: Text("Daily Summary", style: TextStyle(color: generalTextColor)),
        actions: [
          // Optional: Keep profile avatar action if needed on this screen too
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, color: Colors.grey.shade800),
            ),
          )
        ],
      ),
      // --- BODY for Daily Summary ---
      body: ListView( // Use ListView for potentially scrollable content
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Example Summary Section ---
          Text(
              'Summary for Today', // Or selected date
              style: theme.textTheme.headlineSmall?.copyWith(color: generalTextColor, fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 16),

          // Example Card for Focus Time
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined, color: theme.colorScheme.primary, size: 30),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Focus Time', style: theme.textTheme.titleMedium?.copyWith(color: generalTextColor)),
                      SizedBox(height: 4),
                      Text('3h 45m', style: theme.textTheme.headlineSmall?.copyWith(color: generalTextColor, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Example Card for Tasks Completed
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 30),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tasks Completed', style: theme.textTheme.titleMedium?.copyWith(color: generalTextColor)),
                      SizedBox(height: 4),
                      Text('5 / 8', style: theme.textTheme.headlineSmall?.copyWith(color: generalTextColor, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // You could add more summary widgets here (e.g., charts, detailed task list)
          // If you need to display tasks like in TodaysTaskScreen, you can reuse TaskItem:
          Text(
              'Completed Tasks',
              style: theme.textTheme.titleMedium?.copyWith(color: generalTextColor, fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 8),
          // Example of using the corrected TaskItem
          TaskItem(time: "8:00 AM", label: "Focus", profileCount: 1, primaryColor: _kPrimaryColor),
          TaskItem(time: "9:00 AM", label: "Study", profileCount: 2, primaryColor: _kPrimaryColor),
          // ... add more TaskItems if needed ...

        ],
      ),
    );
  }
}


// --- CORRECTED TaskItem Widget Definition ---
// It's better practice to move this to its own file (e.g., widgets/task_item.dart)
// and import it here and in todays_task_screen.dart.
// But including it here ensures this file has the fix.

class TaskItem extends StatelessWidget {
  final String time;
  final String label;
  final int profileCount;
  final Color primaryColor;

  const TaskItem({
    Key? key,
    required this.time,
    required this.label,
    required this.profileCount,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generalTextColor = isDark ? Colors.white : Colors.black;
    const labelTextColor = Colors.black;

    // --- AVATAR STACK CONFIGURATION ---
    const double avatarRadius = 10.0;
    const double avatarDiameter = avatarRadius * 2;
    const double overlap = 8.0; // How many pixels to overlap

    // Calculate width needed for the stack based on overlap
    final int validProfileCount = profileCount < 0 ? 0 : profileCount;
    final double avatarStackWidth = validProfileCount == 0
        ? 0
        : avatarDiameter + (validProfileCount - 1) * (avatarDiameter - overlap);
    // --- END AVATAR STACK CONFIGURATION ---

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
                time,
                // Use theme text style for body
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: generalTextColor) ?? TextStyle(color: generalTextColor)
            ),
          ),
          SizedBox(width: 12),
          if (label.isNotEmpty)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: labelTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (validProfileCount > 0)
                      SizedBox(
                        width: avatarStackWidth,
                        height: avatarDiameter,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: List.generate(validProfileCount, (index) {
                            final double leftOffset = index * (avatarDiameter - overlap);
                            return Positioned(
                              left: leftOffset >= 0 ? leftOffset : 0,
                              child: CircleAvatar(
                                radius: avatarRadius,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 12,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            )
          else // Empty Slot Placeholder
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Remove these local text style constants if you are consistently using Theme.of(context).textTheme
/*
const TextStyle _kHeaderStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
const TextStyle _kSubHeaderStyle = TextStyle(fontSize: 18, color: Colors.black87, fontStyle: FontStyle.italic);
const TextStyle _kBodyStyle = TextStyle(fontSize: 14);
*/