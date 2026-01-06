import '../models/entry.dart';
import 'undo_buffer.dart';

void clearAllEntries(List<Entry> entries) {
  undoBuffer.save(entries);
  entries.clear();
}

void clearEntriesByCard(List<Entry> entries, String cardName) {
  final toDelete = entries
      .where((e) => e.type == EntryType.spent && e.card == cardName)
      .toList();

  if (toDelete.isEmpty) return;

  undoBuffer.save(toDelete);

  entries.removeWhere(
    (e) => e.type == EntryType.spent && e.card == cardName,
  );
}
