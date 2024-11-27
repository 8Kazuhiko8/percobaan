import 'package:flutter/material.dart';
import 'package:percobaan/services/api_service.dart';
import 'package:percobaan/models/history_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final ApiService _apiService = ApiService();
  String _selectedTimeZone = 'WIB';
  final List<String> _timeZones = ['WIB', 'WITA', 'WIT', 'London', 'Tokyo'];

  String? _currentContent;
  String? _currentType;

  String _formatDateTime(DateTime dateTime) {
    switch (_selectedTimeZone) {
      case 'WIB':
        return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
      case 'WITA':
        return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.add(const Duration(hours: 1)));
      case 'WIT':
        return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.add(const Duration(hours: 2)));
      case 'London':
        return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.subtract(const Duration(hours: 7)));
      case 'Tokyo':
        return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.add(const Duration(hours: 2)));
      default:
        return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
    }
  }

  Future<void> _generateContent(String type) async {
    try {
      String content = '';
      switch (type) {
        case 'fact':
          content = await _apiService.getFact();
          break;
        case 'joke':
          content = await _apiService.getJoke();
          break;
        case 'quote':
          content = await _apiService.getQuote();
          break;
      }

      final history = History(
        type: type,
        content: content,
        timestamp: DateTime.now(),
      );

      final historyBox = Hive.box<History>('history');
      await historyBox.add(history);

      setState(() {
        _currentContent = content;
        _currentType = type;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Generate Something'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Generate'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Generate Tab
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    textColor: Colors.white,
                    title: const Text('Generate Random Fact'),
                    trailing: const Icon(Icons.lightbulb, color: Colors.white,),
                    onTap: () => _generateContent('fact'),
                  ),
                ),
                Card(
                  child: ListTile(
                    textColor: Colors.white,
                    title: const Text('Generate Random Joke'),
                    trailing: const Icon(Icons.mood, color: Colors.white,),
                    onTap: () => _generateContent('joke'),
                  ),
                ),
                Card(
                  child: ListTile(
                    textColor: Colors.white,
                    title: const Text('Generate Random Quote'),
                    trailing: const Icon(Icons.format_quote, color: Colors.white,),
                    onTap: () => _generateContent('quote'),
                  ),
                ),
                if (_currentContent != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          'Generated $_currentType:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(_currentContent!),
                      ),
                    ),
                  ),
              ],
            ),
            // History Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectedTimeZone,
                    items: _timeZones.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTimeZone = newValue!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<History>('history').listenable(),
                    builder: (context, Box<History> box, _) {
                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final history = box.getAt(box.length - 1 - index);
                          return Card(
                            child: ListTile(
                              title: Text(history!.content),
                              subtitle: Text(
                                '${history.type} - ${_formatDateTime(history.timestamp)}',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
