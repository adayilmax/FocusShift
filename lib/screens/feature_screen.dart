import 'package:flutter/material.dart';
import '../main.dart';

class FeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feature Screen", style: AppTextStyles.header)),
      body: Padding(
        padding: AppDimens.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              'https://via.placeholder.com/300x150',
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Image.asset(
              'assets/images/sample.png',
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              "This screen showcases both network and asset images.",
              style: AppTextStyles.subHeader,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
