import 'package:flutter/material.dart';
import '../data/dummy_entries.dart';
import '../models/entry.dart';
import 'spent_entry_detail_screen.dart';
import '../data/cards.dart';
import '../utils/clear_utils.dart';

class SpentScreen extends StatelessWidget {
  const SpentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spentEntries = dummyEntries
        .where((e) => e.type == EntryType.spent)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amount Spent'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _confirmClearAll(context);
              } else if (value == 'clear_by_card') {
                _selectCardToClear(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear all transactions'),
              ),
              PopupMenuItem(
                value: 'clear_by_card',
                child: Text('Clear by card'),
              ),
            ],
          ),
        ],
      ),
      body: spentEntries.isEmpty
          ? const Center(
              child: Text('No spent entries'),
            )
          : ListView.builder(
              itemCount: spentEntries.length,
              itemBuilder: (context, index) {
                final entry = spentEntries[index];

                return ListTile(
                  leading:
                      const Icon(Icons.arrow_upward, color: Colors.red),
                  title: Text('₹ ${entry.amount}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.person),
                      if (entry.card != null)
                        Text(
                          entry.card!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  trailing: Text(
                    '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SpentEntryDetailScreen(entry: entry),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  // ---------------- CLEAR ALL ----------------
  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all transactions'),
        content: const Text(
          'This will permanently delete ALL transactions. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              clearAllEntries(dummyEntries);
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // ---------------- CLEAR BY CARD ----------------
  void _selectCardToClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear by card'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: cards.map((card) {
              return ListTile(
                title: Text(card.name),
                onTap: () {
                  clearEntriesByCard(dummyEntries, card.name);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
