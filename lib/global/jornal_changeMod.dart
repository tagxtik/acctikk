import 'dart:async';
import 'dart:convert';

import 'package:acctik/model/jornal_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JornalChangemod extends ChangeNotifier {
  // final _itemsController = StreamController<List<JornalEntryModel>>.broadcast();
  // Stream<List<JornalEntryModel>> get itemsStream => _itemsController.stream;

  List<JornalEntryModel> _items = [];
  List<JornalEntryModel> get items => _items;
  List<int?> _selectedRadioIndexes =
      []; // Stores selected radio button for each item
  List<String> _textValues = []; // Stores text field values for each item

  // Getter to access the selected radio button for each item
  List<int?> get selectedRadioIndexes => _selectedRadioIndexes;

  // Getter to access text field values
  List<String> get textValues => _textValues;

  // Set the selected radio button index for the given item
  void selectRadioButton(int itemIndex, int selectedRadioIndex) {
    if (_selectedRadioIndexes.length <= itemIndex) {
      _selectedRadioIndexes.length = itemIndex + 1;
    }
    _selectedRadioIndexes[itemIndex] = selectedRadioIndex;
    notifyListeners(); // Notify the UI to rebuild
  }

  // Set the text field value for the given item
  void setTextValue(int itemIndex, String value) {
    print("Value is : " + value);
    if (_textValues.length <= itemIndex) {
      _textValues.length = itemIndex + 1;
    }
    _textValues[itemIndex] = value;
    notifyListeners(); // Notify the UI to rebuild
  }

  Future<void> loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsJson = prefs.getString('jornalItems');

    if (itemsJson != null) {
      try {
        // First, decode the JSON string as a list of strings
        List<dynamic> itemsList = jsonDecode(itemsJson);

        // Then decode each individual string inside the list to a map
        _items = itemsList.map((itemJson) {
          return JornalEntryModel.fromJson(
              jsonDecode(itemJson) as Map<String, dynamic>);
        }).toList();

        // Notify listeners about the loaded items (if you're using a stream)
        // _itemsController.add(_items);
        print('Items loaded successfully.');
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print('No items found in SharedPreferences.');
    }
  }

  // Add a new item and save the updated list
  Future<void> addJornalItem(JornalEntryModel newItem) async {
    _selectedRadioIndexes.add(0); // Set the default selected radio to 0
    loadItems();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsJson = prefs.getString('jornalItems');

    // Load existing items from SharedPreferences
    if (itemsJson != null) {
      try {
        // Decode the existing items from SharedPreferences (list of strings)
        List<dynamic> itemsList = jsonDecode(itemsJson);

        // Decode each string in the list to a map and convert to JornalEntryModel
        _items = itemsList.map((itemJson) {
          return JornalEntryModel.fromJson(
              jsonDecode(itemJson) as Map<String, dynamic>);
        }).toList();

        print('Loaded existing items from SharedPreferences.');
      } catch (e) {
        print('Error parsing existing items from JSON: $e');
      }
    } else {
      print('No previous items found in SharedPreferences.');
    }

    // Add the new item to the list
    _items.add(newItem);
    // _itemsController.add(_items);

    // Save the updated list to SharedPreferences
    List<String> updatedItemsJson =
        _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setString('jornalItems', jsonEncode(updatedItemsJson));
    print('New item added and list updated in SharedPreferences.');
    notifyListeners(); // Notify listeners when the list changes

    //   notifyListeners();
  }

  // void dispose() {
  //   _itemsController.close(); // Always close the stream controller
  // }

  Future<void> clearSharedPreferences() async {
    _items = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  double calculateSumCredit() {
    loadItems();
    if (_items.isEmpty) return 0.0;
    double totalCredit = 0.0;

    for (var item in _items) {
      totalCredit += item.creditVal;
    }

    return double.parse(
        totalCredit.toStringAsFixed(3)); // Round to 2 decimal places
  }

  double calculateSumDebit() {
    loadItems();
    if (_items.isEmpty) return 0.0;
    double totalDebit = 0.0;

    for (var item in _items) {
      totalDebit += item.debitVal;
    }

    return double.parse(
        totalDebit.toStringAsFixed(3)); // Round to 2 decimal places
  }

  double calculateDifference() {
    loadItems();
    //   notifyListeners();

    double roundedValue = calculateSumDebit() - calculateSumCredit();
    return roundedValue;
  }

  Future<void> deleteItem(int itemIndex, String itemType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Refresh `_items` from SharedPreferences to ensure consistency
    await loadItems(); // Reload items from SharedPreferences

    // Find and delete the item in `_items` based on `itemType`
    if (itemType == "Credit") {
      final creditItems =
          _items.where((item) => item.accountType == "Credit").toList();
      if (itemIndex >= 0 && itemIndex < creditItems.length) {
        _items.remove(creditItems[itemIndex]);
      }
    } else if (itemType == "Debit") {
      final debitItems =
          _items.where((item) => item.accountType == "Debit").toList();
      if (itemIndex >= 0 && itemIndex < debitItems.length) {
        _items.remove(debitItems[itemIndex]);
      }
    }

    // Save updated `_items` list to SharedPreferences
    List<String> updatedItemsJson =
        _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setString('jornalItems', jsonEncode(updatedItemsJson));

    print("Item deleted. Remaining items: $_items"); // Debugging line
    print(_items.length);

    // Notify listeners to update the UI
    notifyListeners();
  }
    void clearItems() {
    items.clear();
    notifyListeners();  // Notify listeners to update UI
  }
}
