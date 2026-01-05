import 'package:flutter/material.dart';
import '../models/entry.dart';

class SpentEntryDetailScreen extends StatelessWidget {
  final Entry entry;

  const SpentEntryDetailScreen({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spent Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Amount', '₹ ${entry.amount}'),
            _row('Person', entry.person),
            _row('Card', entry.card ?? '—'),
            _row('Date',
                '${entry.date.day}/${entry.date.month}/${entry.date.year}'),
            if (entry.note != null && entry.note!.isNotEmpty)
              _row('Note', entry.note!),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
