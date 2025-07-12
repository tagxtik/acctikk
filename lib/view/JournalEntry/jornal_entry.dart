import 'package:acctik/data/card_data.dart';
import 'package:acctik/functions.dart';
import 'package:acctik/global/jDetailMod.dart';
import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/model/jornal_entry_model.dart';
import 'package:acctik/services/account_services.dart';
import 'package:acctik/services/firestore.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:acctik/services/logService.dart';
import 'package:acctik/view/Widgets/all_account.dart';
import 'package:acctik/view/Widgets/jornal_calc.dart';
import 'package:acctik/view/Widgets/list_all_jornal_entry.dart';
import 'package:acctik/view/Widgets/upload_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class JornalEntry extends StatefulWidget {
  const JornalEntry({super.key});

  @override
  State<JornalEntry> createState() => _JornalEntryState();
}

// Global Variables
bool isButtonActive = false;
DateTime _selectedDate = DateTime.now();
String selectedOrg = "0";
TextEditingController _jname = TextEditingController();
TextEditingController _jdesc = TextEditingController();
List<XFile> _selectedImages = [];
late int maximumValue = 0;

final FirestoreService fbs = FirestoreService();
final AccountServices accs = AccountServices();
final JornalService js = JornalService();
final TextEditingController _nameController = TextEditingController();
final TextEditingController __descController = TextEditingController();
final cd = CardData();

class _JornalEntryState extends State<JornalEntry> {
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    final jornalChangeMod = JornalChangemod();
    jornalChangeMod.loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JornalChangemod(),
      child: Form(
        child: Scaffold(
          floatingActionButton: Consumer<JornalChangemod>(
            builder: (context, jornalChangeMod, child) {
              return FloatingActionButton(
                onPressed: () => submitData(jornalChangeMod),
                child: const Icon(Icons.save),
              );
            },
          ),
          body: Stack(
            children: [
              buildUI(),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
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
                "Jornal Entry",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 18),
            buildOrganizationDropdown(),
            buildJournalDetails(),
            buildAddImagesButton(),
            UploadImages(selectedImages: _selectedImages),
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
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('orgs').snapshots(),
            builder: (context, snapshot) {
              List<DropdownMenuItem> orgItems = [];
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final orgs = snapshot.data?.docs.reversed.toList();
              orgItems.add(const DropdownMenuItem(
                value: "0",
                child: Text(
                  "Select Client",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ));

              orgs?.forEach((org) {
                orgItems.add(DropdownMenuItem(
                  value: org.id,
                  child: Text(org["orgname"]),
                ));
              });

              return DropdownButton(
                items: orgItems,
                onChanged: (orgValue) {
                  _jname.clear();
                  _jdesc.clear();
                  _selectedImages = [];
                  Provider.of<JornalChangemod>(context, listen: false)
                      .clearSharedPreferences();

                  setState(() {
                    isButtonActive = orgValue != "0";
                    selectedOrg = orgValue;
                  });
                },
                value: selectedOrg,
                isExpanded: false,
              );
            },
          ),
          const SizedBox(width: 30),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset',
            onPressed: resetFields,
          ),
        ],
      ),
    );
  }

  Widget buildJournalDetails() {
    return Row(
      children: [
        buildDateSelector(),
        buildJournalId(),
        buildTextField(_jname, 'Enter Journal name here'),
        buildTextField(_jdesc, 'Enter Description here', maxLines: 5),
      ],
    );
  }

  Widget buildAddImagesButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Add Images',
      onPressed: isButtonActive ? pickImages : null,
    );
  }

  Widget buildAccountsAndEntries() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: selectedOrg != "0"
              ? SingleChildScrollView(
                  child: Card(
                    child: AllAccount(
                      org_id: selectedOrg,
                      jornalname: _jname.text,
                      jornaldesc: _jdesc.text,
                      jornalid: maximumValue,
                      jornaldate: _selectedDate,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 4,
          child: selectedOrg != "0"
              ? SingleChildScrollView(
                  child: Card(
                    child: Consumer<JornalChangemod>(
                      builder: (context, jornalChangeMod, child) {
                        return ListAllJornalEntry(selectedorg: selectedOrg);
                      },
                    ),
                  ),
                )
              : Text("Please Select Orgnization"),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(child: const JornalCalc()),
        ),
      ],
    );
  }

  void submitData(JornalChangemod jornalChangeMod) async {
    final log = Logservice();
    jornalChangeMod.loadItems();

    if (selectedOrg != null &&
        _jname.text.isNotEmpty &&
        jornalChangeMod.calculateDifference() == 0) {
      setState(() => _isLoading = true);

      try {
        for (JornalEntryModel entry in jornalChangeMod.items) {
          await js.addJournalWithSubcollection(
            entry.orgId,
            maximumValue,
            _jname.text,
            _jdesc.text,
            getUser(),
            _selectedDate,
            roundThree(jornalChangeMod.calculateSumDebit()),
            roundThree(jornalChangeMod.calculateSumCredit()),
            entry.mainId,
            entry.subId,
            entry.accName,
            entry.accountType == "Debit" ? entry.debitVal : entry.creditVal,
            entry.accountType,
            _selectedImages,
          );
        }
      } catch (error) {
        showErrorDialog('An error occurred. Please try again.');
      } finally {
        await js.addImgs(_selectedImages, maximumValue.toString(), getUser(),
            _selectedDate, selectedOrg!);
        log.addLog(
          "addjor",
          "Journal Add with Debit = ${roundThree(jornalChangeMod.calculateSumDebit())} and Credit = ${roundThree(jornalChangeMod.calculateSumCredit())} with images = ${_selectedImages.length}",
          getUser(),
          DateTime.now(),
        );

        // Clear the Jdetailmod items after data submission
        jornalChangeMod.clearItems();
        jornalChangeMod.loadItems();
        setState(() {
          maximumValue++;
          selectedOrg = "0";
          _jname.clear();
          _jdesc.clear();
          _selectedImages = [];
          jornalChangeMod.clearSharedPreferences();
          _isLoading = false;
        });

        showSuccessDialog('All Data Done');
      }
    } else {
      showErrorDialog('Be sure you fill all required fields');
    }
  }

  void resetFields() {
    setState(() {
      _jname.clear();
      _jdesc.clear();
      _selectedImages = [];
      selectedOrg = "0";
      isButtonActive = false;
    });
  }

  Future<void> pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _selectedImages = pickedImages;
    });
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

  Widget buildJournalId() {
    return Expanded(
      child: FutureBuilder<int>(
        future: js.getMaxJorID(selectedOrg!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            maximumValue = snapshot.data! + 1;
            return Text('Journal ID: $maximumValue');
          }
        },
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Expanded(
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration:
            InputDecoration(hintText: hint, border: const OutlineInputBorder()),
      ),
    );
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }
}
