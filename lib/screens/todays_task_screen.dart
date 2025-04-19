import 'package:flutter/material.dart';

// Define the primary color used in this screen locally
const Color _kPrimaryColor = Colors.greenAccent;

// Define text styles locally (or use Theme.of(context).textTheme)
const TextStyle _kHeaderStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  // Color will adapt based on theme by default, or set explicitly e.g. color: Colors.black
);
const TextStyle _kSubHeaderStyle = TextStyle(
  fontSize: 18,
  color: Colors.black87, // Keeping this specific color for the subtitle style
  fontStyle: FontStyle.italic,
);
const TextStyle _kBodyStyle = TextStyle(
  fontSize: 14,
  // Color will adapt based on theme by default
);


class TodaysTaskScreen extends StatelessWidget {
  // Add a Key to the constructor
  const TodaysTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generalTextColor = isDark ? Colors.white : Colors.black;
    final subtleTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      // Ensure AppBar background and icon colors adapt to theme
      appBar: AppBar(
        // Use theme's scaffold background color for seamless look
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0, // Remove shadow
        leading: IconButton( // Make leading icon tappable
            icon: Icon(Icons.arrow_back, color: generalTextColor),
            onPressed: () {
              // Ensure context is still valid before popping
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
        ),
        title: Text("Today's Task", style: TextStyle(color: generalTextColor)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              // Potentially use theme color for avatar background
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, color: Colors.grey.shade800),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Use header style, color adapts via theme
                    Text('August 2023', style: _kHeaderStyle.copyWith(color: generalTextColor)),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _kPrimaryColor, // Use local primary color
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 24,
                        color: Colors.black, // Ensure contrast on primary color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // Use sub-header style, color adapts via theme (or use the defined _kSubHeaderStyle)
                Text(
                    'Work in Progress',
                    style: _kSubHeaderStyle.copyWith(color: subtleTextColor) // Make it slightly less prominent
                ),
                SizedBox(height: 10), // Added spacing
                // --- Date Picker Row ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final date = 15 + index;
                    final isHighlighted = date == 18; // Example highlight
                    final days = ['Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    final textColor = isHighlighted ? Colors.black : generalTextColor; // Black on highlight, theme color otherwise

                    // Use Expanded instead of Flexible for more robust space distribution
                    return Expanded(
                      child: Padding(
                        // ##### THIS LINE IS CORRECTED #####
                        padding: const EdgeInsets.symmetric(horizontal: 2.0), // Add slight horizontal spacing
                        // ##### END CORRECTION #####
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Ensure column takes minimum space
                          children: [
                            Container(
                              // Ensure padding is non-negative
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Adjusted padding slightly
                              decoration: isHighlighted
                                  ? BoxDecoration(
                                color: _kPrimaryColor, // Use local primary color
                                borderRadius: BorderRadius.circular(12),
                              )
                                  : null,
                              child: Text(
                                '$date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor, // Use calculated text color
                                ),
                              ),
                            ),
                            SizedBox(height: 4), // Spacing between date and day
                            Text(
                              days[index],
                              style: TextStyle(
                                fontSize: 12, // Slightly smaller day text
                                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                color: isHighlighted ? Colors.black : subtleTextColor, // Black on highlight, subtle otherwise
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                // --- End Date Picker Row ---
              ],
            ),
          ),
          Expanded(
            child: ListView(
              // Ensure padding is non-negative
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust vertical padding
              children: [
                // Pass the primary color down to TaskItem
                TaskItem(time: "8:00 AM", label: "Focus", profileCount: 1, primaryColor: _kPrimaryColor),
                TaskItem(time: "9:00 AM", label: "Study", profileCount: 2, primaryColor: _kPrimaryColor),
                TaskItem(time: "11:00 AM", label: "", profileCount: 0, primaryColor: _kPrimaryColor), // Empty task slot
                TaskItem(time: "12:00 PM", label: "Research, Business", profileCount: 2, primaryColor: _kPrimaryColor),
                TaskItem(time: "2:00 PM", label: "Research, Business", profileCount: 3, primaryColor: _kPrimaryColor),
                TaskItem(time: "3:00 PM", label: "", profileCount: 0, primaryColor: _kPrimaryColor), // Empty task slot
                TaskItem(time: "4:00 PM", label: "", profileCount: 0, primaryColor: _kPrimaryColor), // Empty task slot
                TaskItem(time: "5:00 PM", label: "", profileCount: 0, primaryColor: _kPrimaryColor), // Empty task slot
                TaskItem(time: "6:00 PM", label: "Review, Business", profileCount: 1, primaryColor: _kPrimaryColor),
                SizedBox(height: 20),
                Container(
                  // Ensure padding is non-negative
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _kPrimaryColor, // Use local primary color
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use a bold style for notification title, ensure contrast
                      Text("Trend Notification",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 8),
                      // Ensure contrast for notification body
                      Text("One step at a time. You'll get there.", style: TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String time;
  final String label;
  final int profileCount;
  final Color primaryColor; // Accept primary color

  const TaskItem({
    Key? key, // Added Key
    required this.time,
    required this.label,
    required this.profileCount,
    required this.primaryColor, // Added required primaryColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generalTextColor = isDark ? Colors.white : Colors.black;
    // Label is always black for contrast on the primaryColor background
    const labelTextColor = Colors.black;

    // --- AVATAR STACK CONFIGURATION ---
    const double avatarRadius = 10.0;
    const double avatarDiameter = avatarRadius * 2;
    const double overlap = 8.0; // How many pixels to overlap

    // Calculate width needed for the stack based on overlap
    // Ensure profileCount is not negative just in case, although unlikely
    final int validProfileCount = profileCount < 0 ? 0 : profileCount;
    final double avatarStackWidth = validProfileCount == 0
        ? 0
        : avatarDiameter + (validProfileCount - 1) * (avatarDiameter - overlap);
    // --- END AVATAR STACK CONFIGURATION ---


    return Padding(
      // Ensure padding is non-negative
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align time to top
        children: [
          // Use body style, color adapts via theme
          Padding(
            // Ensure padding is non-negative
            padding: const EdgeInsets.only(top: 10.0), // Align time text with box text vertically
            child: Text(
                time,
                style: _kBodyStyle.copyWith(color: generalTextColor)
            ),
          ),
          SizedBox(width: 12),
          // --- Task Block ---
          if (label.isNotEmpty) // Only show the container if label is not empty
            Expanded(
              child: Container(
                // Ensure padding is non-negative
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor, // Use passed primary color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Flexible allows text to wrap if needed
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: labelTextColor, // Always black on primary background
                          fontWeight: FontWeight.bold, // Make labels bold
                        ),
                        overflow: TextOverflow.ellipsis, // Prevent long labels from overflowing
                      ),
                    ),

                    // --- AVATAR STACK (INSTEAD OF ROW) ---
                    if (validProfileCount > 0)
                      SizedBox(
                        width: avatarStackWidth, // Calculated width
                        height: avatarDiameter,  // Height equals avatar diameter
                        child: Stack(
                          clipBehavior: Clip.none, // Allow avatars to overflow SizedBox slightly if needed visually
                          children: List.generate(validProfileCount, (index) {
                            // Ensure offset calculation is non-negative
                            final double leftOffset = index * (avatarDiameter - overlap);
                            return Positioned(
                              // Position each avatar horizontally
                              left: leftOffset >= 0 ? leftOffset : 0, // Use calculated non-negative offset
                              // No need for top/bottom if height is fixed by SizedBox
                              child: CircleAvatar(
                                radius: avatarRadius,
                                backgroundColor: Colors.white, // White background for avatars
                                child: Icon(
                                  Icons.person,
                                  size: 12,
                                  color: primaryColor, // Icon color matches task background
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    // --- END AVATAR STACK ---

                  ],
                ),
              ),
            )
          else // --- Empty Slot Placeholder ---
            Expanded(
              child: Container(
                height: 44, // Match approximate height of filled TaskItem box
                decoration: BoxDecoration(
                  // Optionally add a subtle border or background for empty slots
                  // color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}