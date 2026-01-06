import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/entry.dart';

class LedgerDatabase {
  static final LedgerDatabase instance = LedgerDatabase._init();
  static Database? _database;

  LedgerDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ledger.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final Directory dbDir = await getApplicationDocumentsDirectory();
    final String path = join(dbDir.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        amount INTEGER NOT NULL,
        person TEXT NOT NULL,
        card TEXT,
        note TEXT,
        date INTEGER NOT NULL
      )
    ''');
  }

  // ---------------- INTERNAL MAPPER ----------------

  Entry _mapRowToEntry(Map<String, Object?> row) {
    return Entry(
      type: row['type'] == 'spent'
          ? EntryType.spent
          : EntryType.received,
      amount: row['amount'] as int,
      person: row['person'] as String,
      card: row['card'] as String?,
      note: row['note'] as String?,
      date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
    );
  }

  // ---------------- CRUD ----------------

  Future<int> insertEntry(Entry entry) async {
    final db = await instance.database;
    return await db.insert('entries', {
      'type': entry.type.name,
      'amount': entry.amount,
      'person': entry.person,
      'card': entry.card,
      'note': entry.note,
      'date': entry.date.millisecondsSinceEpoch,
    });
  }

  Future<void> insertMany(List<Entry> entries) async {
    final db = await instance.database;
    final batch = db.batch();

    for (final e in entries) {
      batch.insert('entries', {
        'type': e.type.name,
        'amount': e.amount,
        'person': e.person,
        'card': e.card,
        'note': e.note,
        'date': e.date.millisecondsSinceEpoch,
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<Entry>> getAllEntries() async {
    final db = await instance.database;
    final result = await db.query('entries', orderBy: 'date DESC');
    return result.map(_mapRowToEntry).toList();
  }

  // ---------------- UNDO SUPPORT QUERIES ----------------

  Future<List<Entry>> getAllSpent() async {
    final db = await instance.database;
    final result = await db.query(
      'entries',
      where: 'type = ?',
      whereArgs: ['spent'],
    );
    return result.map(_mapRowToEntry).toList();
  }

  Future<List<Entry>> getSpentByCard(String card) async {
    final db = await instance.database;
    final result = await db.query(
      'entries',
      where: 'type = ? AND card = ?',
      whereArgs: ['spent', card],
    );
    return result.map(_mapRowToEntry).toList();
  }

  // ---------------- DELETE ----------------

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete('entries');
  }

  Future<void> deleteByCard(String card) async {
    final db = await instance.database;
    await db.delete(
      'entries',
      where: 'type = ? AND card = ?',
      whereArgs: ['spent', card],
    );
  }
}
