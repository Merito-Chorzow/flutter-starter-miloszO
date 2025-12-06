import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/api_service.dart';

class EntryListScreen extends StatefulWidget {
  final ApiService apiService;

  const EntryListScreen({super.key, required this.apiService});

  @override
  State<EntryListScreen> createState() => _EntryListScreenState();
}

class _EntryListScreenState extends State<EntryListScreen> {
  bool _isLoading = false;
  String? _error;
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final entries = await widget.apiService.fetchEntries();
      setState(() {
        _entries = entries;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _goToAdd() async {
    final created = await Navigator.pushNamed(context, '/add');
    if (created == true) {
      await _loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Błąd podczas ładowania wpisów'),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEntries,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    } else if (_entries.isEmpty) {
      body = const Center(
        child: Text('Brak wpisów, dodaj pierwszy.'),
      );
    } else {
      body = ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return Card(
            child: ListTile(
              title: Text(entry.title),
              subtitle: Text(entry.description),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: entry,
                );
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
