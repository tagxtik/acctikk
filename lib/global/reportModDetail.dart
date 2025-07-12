import 'dart:convert';
import 'package:acctik/model/report_jornal_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reportmoddetail extends ChangeNotifier {
  // Private list of items
  List<ReportJornalModel> _items = [];

  // Public getter to access the list of items
  List<ReportJornalModel> get items => _items;

  // Method to set items directly (like a setter)
  void setItems(List<ReportJornalModel> newItems) {
    _items = newItems;
    notifyListeners(); // Call notifyListeners if using ChangeNotifier
  }

  List<int?> _selectedRadioIndexes =
      []; // Stores selected radio button for each item
  List<String> _textValues = []; // Stores text field values for each item

  List<int?> get selectedRadioIndexes => _selectedRadioIndexes;
  List<String> get textValues => _textValues;

  void selectRadioButton(int itemIndex, int selectedRadioIndex) {
    if (_selectedRadioIndexes.length <= itemIndex) {
      _selectedRadioIndexes.length = itemIndex + 1;
    }
    _selectedRadioIndexes[itemIndex] = selectedRadioIndex;
    notifyListeners();
  }

  void setTextValue(int itemIndex, String value) {
    if (_textValues.length <= itemIndex) {
      _textValues.length = itemIndex + 1;
    }
    _textValues[itemIndex] = value;
    notifyListeners();
  }

  Future<void> loadItems() async {
    _items = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsJson = prefs.getString('dailyrep');

    if (itemsJson != null) {
      try {
        List<dynamic> itemsList = jsonDecode(itemsJson);
        _items = itemsList.map((itemJson) {
          return ReportJornalModel.fromJson(jsonDecode(itemJson));
        }).toList();
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }
    notifyListeners();
  }

  Future<void> addJornalItem(ReportJornalModel newItem) async {
    _selectedRadioIndexes.add(0); // Set the default selected radio to 0

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsJson = prefs.getString('dailyrep');

    if (itemsJson != null) {
      try {
        List<dynamic> itemsList = jsonDecode(itemsJson);
        _items = itemsList.map((itemJson) {
          return ReportJornalModel.fromJson(jsonDecode(itemJson));
        }).toList();
      } catch (e) {
        print('Error parsing existing items from JSON: $e');
      }
    }

    _items.add(newItem);
    List<String> updatedItemsJson =
        _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setString('dailyrep', jsonEncode(updatedItemsJson));

    notifyListeners();
  }

  Future<void> clearSharedPreferences() async {
    _items = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void clearitems() {
    _items = [];
  }

  /// Calculates the sum of debit values and rounds the result to 2 decimal places
  double calculateSumDebit() {
    if (_items.isEmpty) return 0.0;
    double totalDebit = 0.0;

    for (var item in _items) {
      if (item.type == "Debit") {
        totalDebit += item.value;
      }
    }

    return double.parse(
        totalDebit.toStringAsFixed(3)); // Round to 2 decimal places
  }

  /// Calculates the sum of credit values and rounds the result to 2 decimal places
  double calculateSumCredit() {
    if (_items.isEmpty) return 0.0;
    double totalCredit = 0.0;

    for (var item in _items) {
      if (item.type == "Credit") {
        totalCredit += item.value;
      }
    }

    return double.parse(
        totalCredit.toStringAsFixed(3)); // Round to 2 decimal places
  }

  /// Calculates the difference between debit and credit and rounds the result to 2 decimal places
  double calculateDifference() {
    if (_items.isEmpty) return 0.0;

    double totalDebit = 0.0;
    double totalCredit = 0.0;

    for (var item in _items) {
      if (item.type == "Debit") {
        totalDebit += item.value;
      } else if (item.type == "Credit") {
        totalCredit += item.value;
      }
    }

    double difference = totalDebit - totalCredit;
    return double.parse(
        difference.toStringAsFixed(3)); // Round to 2 decimal places
  }

  // Inside the Jdetailmod provider
  Future<void> deleteItem(int itemIndex, String itemType) async {
    if (itemType == "Credit") {
      final creditItems =
          _items.where((item) => item.type == "Credit").toList();
      if (itemIndex >= 0 && itemIndex < creditItems.length) {
        _items.remove(creditItems[itemIndex]);
      }
    } else if (itemType == "Debit") {
      final debitItems = _items.where((item) => item.type == "Debit").toList();
      if (itemIndex >= 0 && itemIndex < debitItems.length) {
        _items.remove(debitItems[itemIndex]);
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedItemsJson =
        _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setString('dailyrep', jsonEncode(updatedItemsJson));
    print(_items.length);
    notifyListeners(); // Ensure UI updates
  }
}
