import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get cartCollection =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

  CollectionReference<Map<String, dynamic>> get ordersCollection =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders');

  double calculateTotal(List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
    double total = 0;
    for (var item in items) {
      final data = item.data();
      final price = (data['price'] ?? 0).toDouble();
      final qty = (data['quantity'] ?? 1).toInt();
      total += price * qty;
    }
    return total;
  }

  Future<void> placeOrder(List<QueryDocumentSnapshot<Map<String, dynamic>>> items) async {
    if (items.isEmpty) return;

    final products = items.map((item) => item.data()).toList();
    final totalAmount = calculateTotal(items);

    try {
      // Add order
      await ordersCollection.add({
        'products': products,
        'totalAmount': totalAmount,
        'status': 'Pending',
        'date': FieldValue.serverTimestamp(),
      });

      // Clear cart
      for (var item in items) {
        await cartCollection.doc(item.id).delete();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> updateQuantity(String docId, int newQty) async {
    if (newQty <= 0) {
      await cartCollection.doc(docId).delete();
    } else {
      await cartCollection.doc(docId).update({'quantity': newQty});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cartCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Cart is empty.'));
          }

          final cartItems = snapshot.data!.docs;
          final total = calculateTotal(cartItems);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final data = item.data();
                    final qty = (data['quantity'] ?? 1).toInt();

                    return ListTile(
                      leading: Image.network(
                        data['image'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(data['name'] ?? ''),
                      subtitle: Text('Qty: $qty'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => updateQuantity(item.id, qty - 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => updateQuantity(item.id, qty + 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => cartCollection.doc(item.id).delete(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total: ₹$total',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => placeOrder(cartItems),
                        child: const Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
