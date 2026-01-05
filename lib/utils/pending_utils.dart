import '../models/entry.dart';

Map<String, int> pendingByPerson(List<Entry> entries) {
  final Map<String, int> balanceMap = {};

  for (final entry in entries) {
    balanceMap.putIfAbsent(entry.person, () => 0);

    if (entry.type == EntryType.spent) {
      balanceMap[entry.person] =
          balanceMap[entry.person]! + entry.amount;
    } else {
      balanceMap[entry.person] =
          balanceMap[entry.person]! - entry.amount;
    }
  }

  // Remove settled people (zero balance)
  balanceMap.removeWhere((_, balance) => balance == 0);

  return balanceMap;
}
