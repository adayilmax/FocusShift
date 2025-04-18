import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TodaysTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text("Today's Task"),
        actions: [CircleAvatar(child: Icon(Icons.person))],
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
                    Text('August 2023', style: AppTextStyles.header),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text('Work in Progress', style: AppTextStyles.subHeader),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final date = 15 + index;
                    final isHighlighted = date == 18;
                    final days = ['Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Column(
                      children: [
                        Container(
                          padding: isHighlighted
                              ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                              : null,
                          decoration: isHighlighted
                              ? BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: Text(
                            '$date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color:
                                  isHighlighted ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: isHighlighted
                              ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                              : null,
                          decoration: isHighlighted
                              ? BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: Text(
                            days[index],
                            style: TextStyle(
                              fontWeight: isHighlighted
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  isHighlighted ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TaskItem(time: "8:00 AM", label: "Focus", profileCount: 1),
                TaskItem(time: "9:00 AM", label: "Study", profileCount: 2),
                TaskItem(time: "11:00 AM", label: "", profileCount: 0),
                TaskItem(
                    time: "12:00 PM",
                    label: "Research, Business",
                    profileCount: 2),
                TaskItem(
                    time: "2:00 PM",
                    label: "Research, Business",
                    profileCount: 3),
                TaskItem(time: "3:00 PM", label: "", profileCount: 0),
                TaskItem(time: "4:00 PM", label: "", profileCount: 0),
                TaskItem(time: "5:00 PM", label: "", profileCount: 0),
                TaskItem(
                    time: "6:00 PM",
                    label: "Review, Business",
                    profileCount: 1),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trend Notification",
                          style: AppTextStyles.subHeader),
                      SizedBox(height: 8),
                      Text("One step at a time. You'll get there."),
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

  const TaskItem({
    required this.time,
    required this.label,
    required this.profileCount,
  });

  @override
  Widget build(BuildContext context) {
    // Define if the label should be black and bold
    final isSpecialLabel = [
      "Focus",
      "Study",
      "Research, Business",
      "Review, Business"
    ].contains(label);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(time, style: AppTextStyles.body),
          SizedBox(width: 12),
          if (label.isNotEmpty) // Only show the container if label is not empty
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isSpecialLabel ? Colors.black : Colors.white,
                        fontWeight: isSpecialLabel
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Row(
                      children: List.generate(profileCount, (index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person,
                                size: 12, color: AppColors.primary),
                          ),
                        );
                      }),
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
