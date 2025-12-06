import 'package:flutter/material.dart';
import 'models/journal_entry.dart';
import 'services/api_service.dart';
import 'ui/entry_list_screen.dart';
import 'ui/add_entry_screen.dart';
import 'ui/entry_detail_screen.dart';

void main() {
  runApp(const GeoJournalApp());
}

final ApiService apiService = ApiService();

class GeoJournalApp extends StatelessWidget {
  const GeoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => EntryListScreen(apiService: apiService),

        '/add': (context) => AddEntryScreen(apiService: apiService),

        '/detail': (context) {
          final entry =
              ModalRoute.of(context)!.settings.arguments as JournalEntry;
          return EntryDetailScreen(entry: entry);
        },
      },
    );
  }
}
