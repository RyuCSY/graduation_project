import 'package:flutter/material.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('오픈 라이선스', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: ['flutter', 'dart', 'material-design']
            .map((str) => Container(
                  padding: const EdgeInsets.all(11.0),
                  margin: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(1))),
                  ),
                  child: Text(
                    '${str.substring(0, 1).toUpperCase()}${str.substring(1)}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
