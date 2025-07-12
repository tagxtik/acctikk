import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acctik/model/master_ledger_model.dart';

class MasterLedgerChangemod extends ChangeNotifier {
  List<MasterLedgerModel> _allItems = [];
  final Map<String, List<MasterLedgerModel>> _groupedData = {};

  List<MasterLedgerModel> get allItems => _allItems;

  Map<String, List<MasterLedgerModel>> get groupedData => _groupedData;
// New field for summary data
  final Map<String, Map<String, dynamic>> _summaryData = {};

  Map<String, Map<String, dynamic>> get summaryData => _summaryData;

  void addSummary(
      String mainid, double totalDebit, double totalCredit, double difference) {
    _summaryData[mainid] = {
      'totalDebit': totalDebit,
      'totalCredit': totalCredit,
      'difference': difference,
    };
    notifyListeners();
  }

  void clearData() {
    _allItems.clear();
    _groupedData.clear();
    notifyListeners();
  }

  void addGroupedData(String mainid, List<MasterLedgerModel> items) {
    if (!_groupedData.containsKey(mainid)) {
      _groupedData[mainid] = [];
    }
    _groupedData[mainid]?.addAll(items);
    notifyListeners();
  }

  Future<void> loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsJson = prefs.getString('mainledgeritems');

    if (itemsJson != null) {
      try {
        List<dynamic> itemsList = jsonDecode(itemsJson);
        _allItems = itemsList.map((itemJson) {
          return MasterLedgerModel.fromJson(
              jsonDecode(itemJson) as Map<String, dynamic>);
        }).toList();
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print('No items found in SharedPreferences.');
    }
  }

  Future<void> addAllItems(List<MasterLedgerModel> newItems) async {
    _allItems = newItems;

    List<String> allItemsJson =
        _allItems.map((item) => jsonEncode(item.toJson())).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mainledgeritems', jsonEncode(allItemsJson));

    print('All items added and saved in SharedPreferences.');
    notifyListeners();
  }

  Future<void> addSelectedItems(List<MasterLedgerModel> selectedItems) async {
    _allItems = selectedItems; // Update the list with selected items only

    List<String> selectedItemsJson =
        _allItems.map((item) => jsonEncode(item.toJson())).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mainledgeritems', jsonEncode(selectedItemsJson));

    print('Selected items added and saved in SharedPreferences.');
    notifyListeners();
  }

  Future<void> clearSharedPreferences() async {
    _allItems = []; // Clear all items
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mainledgeritems'); // Clear specific key
    notifyListeners();
  }

  Future<void> loadProcessedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsJson = prefs.getString('mainledgeritems');

    if (itemsJson != null) {
      try {
        List<dynamic> itemsList = jsonDecode(itemsJson);
        _allItems = itemsList.map((itemJson) {
          return MasterLedgerModel.fromJson(
              jsonDecode(itemJson) as Map<String, dynamic>);
        }).toList();
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print('No processed items found in SharedPreferences.');
    }

    notifyListeners();
  }
}
