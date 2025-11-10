import 'package:flutter/material.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Map<String, String>> addresses = [
    {
      "name": "Rahul Sharma",
      "phone": "9876543210",
      "house": "123 MG Road",
      "city": "Bengaluru",
      "state": "Karnataka",
      "pincode": "560001",
      "type": "Home"
    },
    {
      "name": "Priya Singh",
      "phone": "9123456789",
      "house": "45 Connaught Place",
      "city": "New Delhi",
      "state": "Delhi",
      "pincode": "110001",
      "type": "Work"
    },
  ];

  // 🔹 Add new address (local for now)
  void _addAddress(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final houseCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final stateCtrl = TextEditingController();
    final pinCtrl = TextEditingController();
    String type = "Home";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Address"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name")),
                TextFormField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
                TextFormField(controller: houseCtrl, decoration: const InputDecoration(labelText: "House No / Street")),
                TextFormField(controller: cityCtrl, decoration: const InputDecoration(labelText: "City")),
                TextFormField(controller: stateCtrl, decoration: const InputDecoration(labelText: "State")),
                TextFormField(controller: pinCtrl, decoration: const InputDecoration(labelText: "Pincode"), keyboardType: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: type,
                  items: const [
                    DropdownMenuItem(value: "Home", child: Text("Home")),
                    DropdownMenuItem(value: "Work", child: Text("Work")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (val) => type = val!,
                  decoration: const InputDecoration(labelText: "Address Type"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && houseCtrl.text.isNotEmpty) {
                setState(() {
                  addresses.add({
                    "name": nameCtrl.text,
                    "phone": phoneCtrl.text,
                    "house": houseCtrl.text,
                    "city": cityCtrl.text,
                    "state": stateCtrl.text,
                    "pincode": pinCtrl.text,
                    "type": type
                  });
                });

                // 🔹 Future: Firebase saving can be added here
                // FirebaseFirestore.instance.collection('addresses').add({...});

                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final addr = addresses[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.redAccent),
              title: Text("${addr['name']} (${addr['type']})"),
              subtitle: Text(
                  "${addr['house']}, ${addr['city']}, ${addr['state']} - ${addr['pincode']}\n📞 ${addr['phone']}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addAddress(context),
        label: const Text("Add Address"),
        icon: const Icon(Icons.add_location_alt),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
