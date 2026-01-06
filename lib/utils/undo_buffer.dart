import '../models/entry.dart';

class UndoBuffer {
  List<Entry>? _lastDeleted;

  void save(List<Entry> entries) {
    _lastDeleted = List<Entry>.from(entries);
  }

  List<Entry>? restore() {
    final temp = _lastDeleted;
    _lastDeleted = null;
    return temp;
  }

  bool get hasData => _lastDeleted != null;
}

final undoBuffer = UndoBuffer();
