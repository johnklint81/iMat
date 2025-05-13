import 'package:flutter/material.dart';

class CheckoutWizard extends StatelessWidget {
  const CheckoutWizard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kassa")),
      body: Center(
        child: Text("Steg 1: Kunduppgifter / Leverans / Betalning"),
      ),
    );
  }
}
