import 'package:acctik/functions.dart';
import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/view/Widgets/jornal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JornalCalc extends StatefulWidget {
  const JornalCalc({super.key});

  @override
  State<JornalCalc> createState() => _JornalCalcState();
}

class _JornalCalcState extends State<JornalCalc> {
  // double debtotal = 0;
  // double credtotal = 0;
  // _calculateSumDebit() {
  //     listStream.listen((onData) {
  //     for (var entry in onData) {
  //          setState(() {
  //           debtotal = debtotal + entry.debitVal;
  //         });
  //         print(entry.accounttype +
  //             "  " +
  //             entry.debitVal.toString() +
  //             " The Current Value " +
  //             debtotal.toString());
  //      }
  //   });
  // }

  // _calculateSumCredit() {
  //    listStream.listen((onData) {
  //     for (var entry in onData) {
  //          setState(() {
  //           credtotal = credtotal + entry.creditVal;
  //         });
  //         print(entry.accounttype +
  //             "  " +
  //             entry.creditVal.toString() +
  //             " The Current Value " +
  //             credtotal.toString());
  //      }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // _calculateSumDebit();
    // _calculateSumCredit();
  }

  @override
  Widget build(BuildContext context) {
    final jornalChangeMod = Provider.of<JornalChangemod>(context);
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 500,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: 500,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Enable vertical scrolling
                    child: Column(
                      children: [
                        JornalCard(
                          color: Color.fromARGB(255, 92, 1, 1),
                          child: SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Enable horizontal scrolling
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 9, bottom: 4),
                                  child: Text(
                                    "Debit is :" +
                                        roundThree(jornalChangeMod
                                                .calculateSumDebit())
                                            .toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 5),
                        JornalCard(
                          color: Color.fromARGB(255, 11, 9, 133),
                          child: SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Enable horizontal scrolling
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 9, bottom: 4),
                                  child: Text(
                                    "Credit is : " +
                                        roundThree(jornalChangeMod
                                            .calculateSumCredit())
                                            .toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 5),
                        JornalCard(
                          color: Color.fromRGBO(255, 237, 186, 1),
                          child: SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Enable horizontal scrolling
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 9, bottom: 4),
                                  child: Text(
                                    "Difference is : " +
                                        roundThree(jornalChangeMod
                                            .calculateDifference())
                                            .toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
