import 'package:flutter/material.dart';

class FocusScreen extends StatefulWidget {
  @override
  _FocusScreenState createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  bool _isFocusMode = true;
  double _minutes = 25;
  String _topic = 'topic';

  @override
  Widget build(BuildContext context) {
    // Use your theme’s accent color, or AppColors.accent
    final accent = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(title: Text(_isFocusMode ? 'Focus Mode' : 'Timer Mode')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1) Toggle
            ToggleButtons(
              isSelected: [_isFocusMode, !_isFocusMode],
              borderRadius: BorderRadius.circular(30),
              selectedBorderColor: accent,
              fillColor: accent.withOpacity(0.1),
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: _isFocusMode ? accent : Colors.grey,
                ),
                Icon(
                  Icons.access_time,
                  color: !_isFocusMode ? accent : Colors.grey,
                ),
              ],
              onPressed: (idx) => setState(() => _isFocusMode = (idx == 0)),
            ),
            SizedBox(height: 32),

            // 2) Timer circle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accent, width: 5),
              ),
              child: Center(
                child: Text(
                  '${_minutes.toInt().toString().padLeft(2, '0')}:00',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 24),

            // 3) Slider
            Slider(
              value: _minutes,
              min: 1,
              max: 120,
              divisions: 119,
              label: '${_minutes.round()}m',
              onChanged: (v) => setState(() => _minutes = v),
            ),
            SizedBox(height: 16),

            // 4) Topic chip
            Chip(
              label: Text(_topic),
              backgroundColor: _isFocusMode ? accent : Colors.grey[300],
            ),

            Spacer(),

            // 5) Start button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: start your timer
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accent),
                  shape: StadiumBorder(),
                ),
                child: Text('FOCUS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
