import 'package:acctik/functions.dart';
import 'package:acctik/global/jDetailMod.dart';
import 'package:acctik/services/account_services.dart';
import 'package:acctik/services/firestore.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:acctik/services/logService.dart';
import 'package:acctik/view/JournalEntry/edit_jornal_screen.dart';
import 'package:acctik/view/Widgets/edit_all_account.dart';
import 'package:acctik/view/Widgets/jornal_calc_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditJornal extends StatefulWidget {
  final String orgid;
  final String jornalname;
  final String jornaldesc;
  final int jornalid;
  final DateTime jornaldate;

  const EditJornal({
    super.key,
    required this.orgid,
    required this.jornalname,
    required this.jornaldesc,
    required this.jornalid,
    required this.jornaldate,
  });

  @override
  State<EditJornal> createState() => _EditJornalState();
}

// Global variables
bool isButtonActive = false;
DateTime _selectedDate = DateTime.now();
TextEditingController _jname = TextEditingController();
TextEditingController _jdesc = TextEditingController();
final FirestoreService fbs = FirestoreService();
final AccountServices accs = AccountServices();
final JornalService js = JornalService();

class _EditJornalState extends State<EditJornal> {
  bool _isLoading = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final jornalChangeMod = Jdetailmod();
    jornalChangeMod.clearSharedPreferences();
    _selectedDate = widget.jornaldate;
    _jname.text = widget.jornalname;
    _jdesc.text = widget.jornaldesc;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Jdetailmod(),
      child: Scaffold(
        appBar: AppBar(title: Text('Edit Journal')),
        floatingActionButton: Consumer<Jdetailmod>(
          builder: (context, jornalChangeMod, child) {
            Logservice log = Logservice();
            jornalChangeMod.loadItems();
            return FloatingActionButton(
              onPressed: () {
                print("Deb  ${roundThree(jornalChangeMod.calculateSumDebit())}");
                print("cred  ${roundThree(jornalChangeMod.calculateSumCredit())}");
                print("diff  ${roundThree(jornalChangeMod.calculateDifference())}");
                if (widget.orgid.isNotEmpty &&
                    _jname.text.isNotEmpty &&
                    roundThree(jornalChangeMod.calculateDifference()) == 0 &&
                    roundThree(jornalChangeMod.calculateSumDebit()) > 0 &&
                    roundThree(jornalChangeMod.calculateSumCredit()) > 0) {
                  setState(() => _isLoading = true);

                  try {
                    js.updateJornal(widget.jornalid, 
                    jornalChangeMod.items,
                    roundThree(jornalChangeMod.calculateSumDebit()),
                    roundThree(jornalChangeMod.calculateSumCredit()),widget.orgid);
                    log.addLog(
                      "editjor",
                      "Journal updated with Debit = ${roundThree(jornalChangeMod.calculateSumDebit())} and Credit = ${roundThree(jornalChangeMod.calculateSumCredit())}",
                      getUser(),
                      DateTime.now(),
                    );

                    // Reset form and clear SharedPreferences
                    jornalChangeMod.clearSharedPreferences();
                    showDialogWithMessage('All Data Done', 'Done');
                  } catch (error) {
                    showErrorDialog('An error occurred. Please try again.');
                  } finally {
                    setState(() => _isLoading = false);
                  }
                } else {
                  showErrorDialog("Error in Calculation");
                }
              },
              child: const Icon(Icons.save),
            );
          },
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildUI(),
            ),
            if (_isLoading || _isUpdating)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  // Main UI structure
  Widget buildUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 18),
            buildJournalDetails(),
            const SizedBox(height: 15),
            buildEditableWidgets(),
          ],
        ),
      ),
    );
  }

  // Journal details section
  Widget buildJournalDetails() {
    return Row(
      children: [
        buildDateSelector(),
        const SizedBox(width: 10),
        buildJournalId(),
        const SizedBox(width: 10),
        buildJournalNameField(),
        const SizedBox(width: 10),
        buildJournalDescField(),
        const SizedBox(width: 10),
        buildUpdateButton(),
      ],
    );
  }

  // Editable widgets (accounts and entries)
  Widget buildEditableWidgets() {
    return ChangeNotifierProvider(
      create: (context) => Jdetailmod(),
      child: Row(
        children: [
          buildEditAllAccounts(),
          const SizedBox(width: 15),
          buildEditJournalEntries(),
          const SizedBox(width: 15),
          buildJournalCalcEdit(),
        ],
      ),
    );
  }
 
  // Date picker widget
  Widget buildDateSelector() {
    return Expanded(
      child: ElevatedButton(
        onPressed: _selectDate,
        child: Column(
          children: [
            const Text('Select Date'),
            const SizedBox(height: 10),
            Text(_selectedDate.toString()),
          ],
        ),
      ),
    );
  }

  // Journal ID display widget
  Widget buildJournalId() {
    return Expanded(
      child: Text('Journal ID: ${widget.jornalid}'),
    );
  }

  // Journal name input field
  Widget buildJournalNameField() {
    return Expanded(
      child: TextField(
        controller: _jname,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter Journal name',
        ),
      ),
    );
  }

  // Journal description input field
  Widget buildJournalDescField() {
    return Expanded(
      child: TextField(
        controller: _jdesc,
        maxLines: 5,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter Description here',
        ),
      ),
    );
  }

  // Update journal data button
  Widget buildUpdateButton() {
    return IconButton(
      icon: const Icon(Icons.update),
      tooltip: 'Update Data',
      onPressed: () async {
        setState(() => _isUpdating = true);

        await js.updateMainData(
          widget.orgid,
          widget.jornalid,
          _jname.text,
          _selectedDate,
          _jdesc.text,
        );

        setState(() => _isUpdating = false);
      },
    );
  }

  // Components for editing all accounts, journal entries, and calculations

  Widget buildEditAllAccounts() {
    return Expanded(
      flex: 5,
      child: widget.orgid.isNotEmpty
          ? SingleChildScrollView(
              child: Card(
                child: EditAllAccount(
                  org_id: widget.orgid,
                  jornalname: _jname.text,
                  jornaldesc: _jdesc.text,
                  jornalid: widget.jornalid,
                  jornaldate: _selectedDate,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget buildEditJournalEntries() {
    return Expanded(
      flex: 3,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: 700,
        ),
        child: SingleChildScrollView(
          child: Card(
            child: Consumer<Jdetailmod>(
              builder: (context, jDetailMod, child) {
                return EditJornalScreen(jid: int.parse(widget.jornalid.toString()),orgid: widget.orgid,);  // Convert if jidString is a String

              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJournalCalcEdit() {
    return Expanded(
      flex: 3,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: 100,
        ),
        child: const JornalCalcEdit(),
      ),
    );
  }

  // Date picker logic
  Future<void> _selectDate() async {
    setState(() => _isLoading = true);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }

    setState(() => _isLoading = false);
  }

  // Helper to display success dialog
  void showDialogWithMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper to display error dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}





 