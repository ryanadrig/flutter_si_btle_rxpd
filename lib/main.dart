import 'package:flutter/material.dart';
import 'root.dart';

void main() {
  runApp(const SI_BTLE_RXPD());
}

class SI_BTLE_RXPD extends StatelessWidget {
  const SI_BTLE_RXPD({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Root(),
    );
  }
}


