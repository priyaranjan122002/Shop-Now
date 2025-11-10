import 'package:flutter/material.dart';
import 'package:shop/components/buy_full_ui_kit.dart';

class KidsScreen extends StatelessWidget {
  const KidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kids Collection"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // 👈 back icon visible
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 👈 back karega
        ),
        elevation: 0,
      ),
      body: const BuyFullKit(images: ["assets/screens/Kids.png"]),
    );
  }
}
