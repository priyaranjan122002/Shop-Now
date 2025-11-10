import 'package:flutter/material.dart';
import 'package:shop/components/buy_full_ui_kit.dart';

class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("On Sale"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const BuyFullKit(
        images: ["assets/screens/On sales.png"],
      ),
    );
  }
}
