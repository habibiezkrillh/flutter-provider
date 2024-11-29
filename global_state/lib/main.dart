import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/global_state.dart';
import 'dart:math';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => GlobalState(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Counter App')),
      body:
          globalState.counters.isEmpty
              ? Center(
                child: Text(
                  'No counters yet. Add one!',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex--;
                  globalState.reorderCounters(oldIndex, newIndex);
                },
                children:
                    globalState.counters.asMap().entries.map((entry) {
                      final index = entry.key;
                      final counter = entry.value;

                      return AnimatedContainer(
                        key: ValueKey(counter),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: counter.color,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                counter.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Value: ${counter.value}', // Menampilkan nilai counter
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  globalState.incrementCounter(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  globalState.decrementCounter(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editCounterDialog(
                                    context,
                                    globalState,
                                    index,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  globalState.deleteCounter(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: globalState.addCounter,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editCounterDialog(
    BuildContext context,
    GlobalState globalState,
    int index,
  ) {
    final controller = TextEditingController(
      text: globalState.counters[index].label,
    );
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Counter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Label'),
              ),
              ElevatedButton(
                onPressed: () {
                  globalState.changeCounterColor(index);
                },
                child: const Text('Change Color'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                globalState.updateCounterLabel(index, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
