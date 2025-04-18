import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';

class DailySummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Summary"),
        actions: [
          Icon(Icons.menu),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("My Day"),
                Text("Work/Study"),
                Text("Screen Time"),
                Text("Sport"),
              ],
            ),
            SizedBox(height: 20),
            Text("Daily Summary", style: AppTextStyles.header),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChartWidget(),
            ),
            SizedBox(height: 16),
            Text("Sleep", style: AppTextStyles.subHeader),
            Row(
              children: [
                Icon(Icons.star, color: Colors.green),
                SizedBox(width: 4),
                Text("Excellent"),
              ],
            ),
            Row(
              children: [
                Text(
                  "7.95",
                  style: AppTextStyles.header.copyWith(fontSize: 32),
                ),
                SizedBox(width: 4),
                Text(
                  "HRS OF 8",
                  style: AppTextStyles.header,
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: SleepLineChart(),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 3.0,
        minY: 0.0,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(fontSize: 12);
                switch (value.toInt()) {
                  case 0:
                    return Text('Work/Study', style: style);
                  case 1:
                    return Text('Screen Time', style: style);
                  case 2:
                    return Text('Sport', style: style);
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 0.5,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
            axisNameWidget: Text(
              "Hours",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            axisNameSize: 20,
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 3.0,
                color: AppColors.primary,
                width: 30,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 2.0,
                color: AppColors.primary,
                width: 30,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 1.0,
                color: AppColors.primary,
                width: 30,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SleepLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(fontSize: 12);
                switch (value.toInt()) {
                  case 0:
                    return Text('Mon', style: style);
                  case 1:
                    return Text('Tue', style: style);
                  case 2:
                    return Text('Wed', style: style);
                  case 3:
                    return Text('Thu', style: style);
                  case 4:
                    return Text('Fri', style: style);
                  case 5:
                    return Text('Sat', style: style);
                  case 6:
                    return Text('Sun', style: style);
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6, // Updated to accommodate 7 days (0 to 6)
        minY: 0,
        maxY: 8,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 4),
              FlSpot(2, 2),
              FlSpot(3, 5),
              FlSpot(4, 3),
              FlSpot(5, 6),
              FlSpot(6, 4), // Added a point for the 7th day
            ],
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, 2),
              FlSpot(1, 3),
              FlSpot(2, 1),
              FlSpot(3, 4),
              FlSpot(4, 2),
              FlSpot(5, 5),
              FlSpot(6, 3), // Added a point for the 7th day
            ],
            isCurved: true,
            color: Colors.blue.withOpacity(0.5),
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
