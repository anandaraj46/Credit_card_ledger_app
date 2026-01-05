import '../models/entry.dart';

final dummyEntries = [
  Entry(
    type: EntryType.spent,
    amount: 5000,
    person: 'Client A',
    date: DateTime.now(),
    note: 'Hotel booking',
  ),
  Entry(
    type: EntryType.spent,
    amount: 3000,
    person: 'Client B',
    date: DateTime.now(),
    note: 'Travel',
  ),
  Entry(
    type: EntryType.received,
    amount: 2000,
    person: 'Client A',
    date: DateTime.now(),
    note: 'Partial payment',
  ),
];
