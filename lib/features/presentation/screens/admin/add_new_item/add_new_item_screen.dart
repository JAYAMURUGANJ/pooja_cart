import 'package:flutter/material.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add New Item"),
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Add New Item Cart"),
            TextFormField(),
            ElevatedButton(
              onPressed: () {
                // Add your action here
              },
              child: const Text("Add Item"),
            ),
          ],
        ),
      ),
    );
  }
}
