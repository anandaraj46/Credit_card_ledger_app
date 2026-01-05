enum EntryType { spent, received }

class Entry {
  final EntryType type;
  final int amount;
  final String person;
  final DateTime date;
  final String? note;
  final String? card;
  Entry({
    required this.type,
    required this.amount,
    required this.person,
    required this.date,
    this.note,
    this.card,
  });
}
