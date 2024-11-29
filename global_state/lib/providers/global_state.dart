import 'package:flutter/material.dart';
import 'dart:math';

class GlobalState with ChangeNotifier {
  List<Counter> counters = [];

  void deleteCounter(int index) {
    counters.removeAt(index);
    notifyListeners();
  }

  void addCounter() {
    counters.add(Counter(label: 'Counter ${counters.length + 1}'));
    notifyListeners();
  }

  void incrementCounter(int index) {
    counters[index].value++;
    notifyListeners();
  }

  void decrementCounter(int index) {
    if (counters[index].value > 0) {
      counters[index].value--;
      notifyListeners();
    }
  }

  void updateCounterLabel(int index, String newLabel) {
    counters[index].label = newLabel;
    notifyListeners();
  }

  void changeCounterColor(int index) {
    counters[index].color = _generateRandomColor();
    notifyListeners();
  }

  void reorderCounters(int oldIndex, int newIndex) {
    final counter = counters.removeAt(oldIndex);
    counters.insert(newIndex, counter);
    notifyListeners();
  }

  Color _generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}

class Counter {
  String label;
  int value;
  Color color;

  Counter({required this.label, this.value = 0, Color? color})
    : color = color ?? Colors.blue;
}
