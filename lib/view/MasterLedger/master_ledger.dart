import 'package:acctik/global/master_Ledger_changeMod.dart';
import 'package:acctik/model/org_model.dart';
import 'package:acctik/services/master_ledger_srv.dart';
import 'package:acctik/view/MasterLedger/list_main_ledger.dart';
import 'package:acctik/view/MasterLedger/master_ledger_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MasterLedger extends StatefulWidget {
  const MasterLedger({super.key});

  @override
  State<MasterLedger> createState() => _MasterLedgerState();
}

class _MasterLedgerState extends State<MasterLedger> {
  bool _isLoading = false; // Track the loading state
  final MasterLedgerSrv _firebaseService = MasterLedgerSrv();
  List<OrgModel> organizations = [];
  OrgModel? selectedOrganization;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  DateTime _selectedDate = DateTime.now();
  void _loadOrganizations() async {
    final orgs = await _firebaseService.fetchOrganizations();
    setState(() {
      organizations = orgs;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MasterLedgerChangemod(),
      child: Scaffold(
        body: Stack(
          children: [
            buildUI(),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget buildUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 18),
            const Center(
              child: Text(
                "Main Ledger",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 18),
            buildOrganizationDropdown(),
            buildJournalDetails(),
            buildAccountsAndEntries(),
          ],
        ),
      ),
    );
  }

  Widget buildOrganizationDropdown() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<OrgModel>(
            hint: Text("Select Organization"),
            value: selectedOrganization,
            items: organizations.map((org) {
              return DropdownMenuItem<OrgModel>(
                value: org,
                child: Text(org.org_name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOrganization = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildJournalDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDateSelector(),
      ],
    );
  }

  Widget buildAccountsAndEntries() {
    // Check if selectedOrganization, startDate, and endDate are not null before displaying the widgets
    if (selectedOrganization == null || startDate == null || endDate == null) {
      return Center(
          child: Text("Please select an organization and date range"));
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Card(
              child: ListMainLedger(
                from: startDate!,
                to: endDate!,
                selectedOrganization: selectedOrganization!,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: Card(
              child: MasterLedgerDetail(
                  selectedOrganization: selectedOrganization!,
                  startDate: startDate!,
                  endDate: endDate!),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
              // child: ListMainLedger(
              //   from: startDate!,
              //   to: endDate!,
              //   selectedOrganization: selectedOrganization!,
              // ),
              ),
        ),
      ],
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Done'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget buildDateSelector() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(isStartDate: true),
            child: Column(
              children: [
                const Text('Select Start Date'),
                const SizedBox(height: 10),
                Text(startDate != null ? startDate.toString() : 'Not selected'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(isStartDate: false),
            child: Column(
              children: [
                const Text('Select End Date'),
                const SizedBox(height: 10),
                Text(endDate != null ? endDate.toString() : 'Not selected'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null) {
      setState(() {
        if (isStartDate) {
          startDate = selected;
        } else {
          endDate = selected;
        }
      });
    }
  }
}
