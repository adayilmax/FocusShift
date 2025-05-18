import 'package:flutter/material.dart';

/// A reusable TaskItem widget displaying time, label, and overlapping avatars.
class TaskItem extends StatelessWidget {
  final String time;
  final String label;
  final int profileCount;
  final Color primaryColor;

  const TaskItem({
    super.key,
    required this.time,
    required this.label,
    required this.profileCount,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generalTextColor = isDark ? Colors.white : Colors.black;
    const double avatarRadius = 10.0;
    const double overlap = 8.0;
    final double avatarDiameter = avatarRadius * 2;
    final int validCount = profileCount < 0 ? 0 : profileCount;
    final double stackWidth = validCount == 0
        ? 0
        : avatarDiameter + (validCount - 1) * (avatarDiameter - overlap);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              time,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: generalTextColor) ??
                  TextStyle(color: generalTextColor),
            ),
          ),
          const SizedBox(width: 12),
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (validCount > 0)
                    SizedBox(
                      width: stackWidth,
                      height: avatarDiameter,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: List.generate(validCount, (index) {
                          final left = index * (avatarDiameter - overlap);
                          return Positioned(
                            left: left,
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
          ),
        ],
      ),
    );
  }
}
