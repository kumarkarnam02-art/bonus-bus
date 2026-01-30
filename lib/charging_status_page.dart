import 'package:flutter/material.dart';

class ChargingStatusPage extends StatelessWidget {
  final double batteryPercentage;

  const ChargingStatusPage({super.key, required this.batteryPercentage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging Status'),
        backgroundColor: const Color(0xFF00C853),
      ),
      body: Center(
        child: Text('Battery Percentage: ${batteryPercentage.toInt()}%'),
      ),
    );
  }
}
