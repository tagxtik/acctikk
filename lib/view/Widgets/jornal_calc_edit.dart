import 'package:acctik/functions.dart';
import 'package:acctik/global/jDetailMod.dart';
import 'package:acctik/view/Widgets/jornal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JornalCalcEdit extends StatefulWidget {
  const JornalCalcEdit({super.key});

  @override
  State<JornalCalcEdit> createState() => _JornalCalcEditState();
}

class _JornalCalcEditState extends State<JornalCalcEdit> {
  String totalDebit = "0";
  String totalCred = "0";
  String diff = "0";
  @override
  void initState() {
    Jdetailmod jmod = Jdetailmod();
    setState(() {
      totalDebit = jmod.calculateSumDebit().toString();
      totalCred = jmod.calculateSumDebit().toString();
      diff = jmod.calculateDifference().toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  maxWidth: 400,
                ),
                child: Consumer<Jdetailmod>(
                  builder:
                      (BuildContext context, Jdetailmod value, Widget? child) {
                    return SingleChildScrollView(
  scrollDirection: Axis.vertical, // Enable vertical scrolling
  child: Column(
    children: [
      JornalCard(
        color: Color.fromARGB(255, 92, 1, 1),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 4),
                child: Text(
                  "Debit is :" +
                    roundThree(  value.calculateSumDebit()).toString(),
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
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 4),
                child: Text(
                  "Credit is : " +
                     roundThree( value.calculateSumCredit()).toString(),
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
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 4),
                child: Text(
                  "Difference is : " +
                     roundThree( value.calculateDifference()).toString(),
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
)
;
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
