import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  final double balance;

  const WalletPage({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EV Wallet'),
        backgroundColor: const Color(0xFF00C853),
      ),
      body: Center(
        child: Text('Wallet Balance: ₹${balance.toStringAsFixed(2)}'),
      ),
    );
  }
}
