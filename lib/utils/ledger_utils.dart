import '../models/entry.dart';

int totalSpent(List<Entry> entries) {
  return entries
      .where((e) => e.type == EntryType.spent)
      .fold(0, (sum, e) => sum + e.amount);
}

int totalReceived(List<Entry> entries) {
  return entries
      .where((e) => e.type == EntryType.received)
      .fold(0, (sum, e) => sum + e.amount);
}

int pendingAmount(List<Entry> entries) {
  return totalSpent(entries) - totalReceived(entries);
}
