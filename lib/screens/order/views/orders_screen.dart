import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        "id": "ORD001",
        "status": "Delivered",
        "total": "₹2,499",
        "date": "25 Oct 2025",
        "products": [
          {"name": "Nike Shoes", "quantity": 1, "price": "₹2,499"},
        ]
      },
      {
        "id": "ORD002",
        "status": "Shipped",
        "total": "₹999",
        "date": "22 Oct 2025",
        "products": [
          {"name": "Black T-Shirt", "quantity": 1, "price": "₹999"},
        ]
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ExpansionTile(
              title: Text("${order["id"]} - ${order["status"]}"),
              subtitle: Text("${order["date"]}\nTotal: ${order["total"]}"),
              children: (order["products"] as List).map((prod) {
                return ListTile(
                  title: Text(prod["name"]),
                  subtitle: Text("Qty: ${prod["quantity"]}"),
                  trailing: Text(prod["price"]),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
