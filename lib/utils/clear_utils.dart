import '../models/entry.dart';

void clearAllEntries(List<Entry> entries) {
  entries.clear();
}

void clearEntriesByCard(List<Entry> entries, String cardName) {
  entries.removeWhere(
    (e) => e.type == EntryType.spent && e.card == cardName,
  );
}
