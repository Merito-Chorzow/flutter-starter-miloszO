import '../models/journal_entry.dart';

class ApiService {
  final List<JournalEntry> _entries = [];

  Future<List<JournalEntry>> fetchEntries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_entries);
  }

  Future<JournalEntry> createEntry(String title, String description) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
    );
    _entries.add(entry);
    return entry;
  }
}
