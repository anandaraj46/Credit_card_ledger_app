import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../data/cards.dart';
import '../models/card_model.dart';
import '../database/ledger_database.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  EntryType _type = EntryType.spent;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  CardModel? _selectedCard;

  // ---------------- SAVE ENTRY ----------------
  Future<void> _saveEntry() async {
    final int? amount = int.tryParse(_amountController.text);
    final String person = _personController.text.trim();

    if (amount == null || amount <= 0 || person.isEmpty) {
      return;
    }

    // Enforce card selection for spent
    if (_type == EntryType.spent && _selectedCard == null) {
      return;
    }

    await LedgerDatabase.instance.insertEntry(
      Entry(
        type: _type,
        amount: amount,
        person: person,
        date: DateTime.now(),
        note: _noteController.text.trim(),
        card: _selectedCard?.name,
      ),
    );

    Navigator.pop(context, true);
  }

  // ---------------- ADD NEW CARD ----------------
  void _addNewCard() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Card'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Card name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    cards.add(CardModel(name: name));
                    _selectedCard = cards.last;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ENTRY TYPE
            DropdownButtonFormField<EntryType>(
              value: _type,
              items: const [
                DropdownMenuItem(
                  value: EntryType.spent,
                  child: Text('Spent'),
                ),
                DropdownMenuItem(
                  value: EntryType.received,
                  child: Text('Received'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Entry Type',
              ),
            ),

            const SizedBox(height: 16),

            // AMOUNT
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),

            const SizedBox(height: 16),

            // PERSON
            TextField(
              controller: _personController,
              decoration: const InputDecoration(
                labelText: 'Person',
              ),
            ),

            // CARD (ONLY FOR SPENT)
            if (_type == EntryType.spent) ...[
              const SizedBox(height: 16),

              DropdownButtonFormField<CardModel>(
                value: _selectedCard,
                items: cards
                    .map(
                      (card) => DropdownMenuItem<CardModel>(
                        value: card,
                        child: Text(card.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCard = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Payment Card',
                ),
              ),

              const SizedBox(height: 8),

              TextButton.icon(
                onPressed: _addNewCard,
                icon: const Icon(Icons.add),
                label: const Text('Add new card'),
              ),
            ],

            const SizedBox(height: 16),

            // NOTE
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
              ),
            ),

            const SizedBox(height: 24),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: _saveEntry,
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
