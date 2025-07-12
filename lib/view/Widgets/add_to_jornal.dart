import 'package:acctik/functions.dart';
import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/model/jornal_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToJornal extends StatefulWidget {
  final String title;
  final String message;
  final String jornalname;
  final int jornalid;
  final DateTime jornaldate;
  final String accname;
  final String jornaldesc;
  final String orgid;
  final String mainid;
  final String subid;
  final Function(String) onConfirm;

  const AddToJornal({
    super.key,
    required this.title,
    required this.message,
    required this.jornalname,
    required this.jornalid,
    required this.jornaldesc,
    required this.jornaldate,
    required this.accname,
    required this.orgid,
    required this.mainid,
    required this.subid,
    required this.onConfirm,
  });

  @override
  State<AddToJornal> createState() => _AddToJornalState();
}

class _AddToJornalState extends State<AddToJornal> {
  int _selectedOption = 0;
  String holder = "Enter Debit here";
  String accounttype = "Debit";
  final _value = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
            create: (context) => JornalChangemod(), // Provider added here

      child: AlertDialog(
        scrollable: true,
        content: SizedBox(
          width: 400,
          height: 400,
          child: Center(
            child: Column(
              children: [
                RadioListTile(
                  title: const Text('Debit'),
                  value: 0,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      accounttype = "Debit";
                      holder = 'Enter Debit here';
                      _selectedOption = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Credit'),
                  value: 1,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      holder = "Enter Credit here";
      
                      accounttype = "Credit";
                      _selectedOption = value!;
                    });
                  },
                ),
                // Row(
                //   children: [
      
                //   ],
                // ),
                TextField(
                  controller: _value,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: holder,
                  ),
                ),
      
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    Consumer<JornalChangemod>(
                      builder: (BuildContext context, JornalChangemod value,
                          Widget? child) {
                        return TextButton(
                          onPressed: () {
                            final madeenval = validateDouble(_value.text);
                            if (madeenval != null) {
                              final newItem = _selectedOption == 0
                                  ? JornalEntryModel(
                                    userValue: getUser(),
                                      accountType: accounttype,
                                      debitVal: double.parse(_value.text),
                                      creditVal: 0,
                                      jornalName: widget.jornalname,
                                      jornalId: widget.jornalid,
                                      jornalDate: widget.jornaldate,
                                      accName: widget.accname,
                                      jornalDesc: widget.jornaldesc,
                                      orgId: widget.orgid,
                                      mainId: widget.mainid,
                                      subId: widget.subid)
                                  : JornalEntryModel(
                                      userValue: getUser(),
                                      accountType: accounttype,
                                      debitVal: 0,
                                      creditVal: double.parse(_value.text),
                                      jornalName: widget.jornalname,
                                      jornalId: widget.jornalid,
                                      jornalDate: widget.jornaldate,
                                      accName: widget.accname,
                                      jornalDesc: widget.jornaldesc,
                                      orgId: widget.orgid,
                                      mainId: widget.mainid,
                                      subId: widget.subid);
                              Provider.of<JornalChangemod>(context, listen: false)
                                  .addJornalItem(newItem);
                              Navigator.of(context).pop();
                            } else {
                              return;
                            }
                            Provider.of<JornalChangemod>(context, listen: false)
                                .loadItems();
                          },
                          child: const Text('OK'),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
