import 'package:flutter/material.dart';

class create_adssp extends StatelessWidget {
  const create_adssp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Your cart is empty.'),
      ),
    );
  }
}
