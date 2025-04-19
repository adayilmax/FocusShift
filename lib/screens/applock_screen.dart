import 'package:flutter/material.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final barTextColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("App Lock", style: TextStyle(color: textColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: textColor),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("Focus Now", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            Text("Hour Limits", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
            const Divider(color: Colors.green),
            const SizedBox(height: 12),

            _horizontalLineItem("assets/icons/instagram.png", 3, barTextColor),
            _horizontalLineItem("assets/icons/twitter.png", 2, barTextColor),
            _horizontalLineItem("assets/icons/youtube.png", 1, barTextColor),
            _horizontalLineItem("assets/icons/controller.png", 4, barTextColor),

            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 32),
                Icon(Icons.add_circle, size: 36, color: Colors.greenAccent),
              ],
            ),

            const SizedBox(height: 32),
            Text("Last Week", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
            const Divider(color: Colors.green),
            const SizedBox(height: 12),

            _verticalBarSection(textColor),
          ],
        ),
      ),
    );
  }

  Widget _horizontalLineItem(String iconPath, int hours, Color barTextColor) {
    double maxWidth = 200;
    double lineWidth = (hours / 5.0) * maxWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 36, height: 36),
          const SizedBox(width: 16),
          Container(
            width: lineWidth,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '$hours',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: barTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalBarSection(Color textColor) {
    final data = [
      {"label": "Work", "value": 12},
      {"label": "Screen", "value": 17},
      {"label": "Sport", "value": 9},
      {"label": "Games", "value": 7},
      {"label": "Social", "value": 14},
    ];

    return SizedBox(
      height: 240,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final value = item['value'] as int;
          final label = item['label'] as String;
          final barHeight = value * 6.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 4),
              Container(
                height: barHeight,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
            ],
          );
        }).toList(),
      ),
    );
  }
}