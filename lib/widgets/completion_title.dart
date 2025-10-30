import 'package:flutter/material.dart';

class CompletionTile extends StatelessWidget {
  final String date;
  const CompletionTile({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(date),
    );
  }
}