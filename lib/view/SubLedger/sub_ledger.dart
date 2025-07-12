import 'package:flutter/material.dart';

class SubLedger extends StatefulWidget {
  const SubLedger({super.key});

  @override
  State<SubLedger> createState() => _SubLedgerState();
}

class _SubLedgerState extends State<SubLedger> {
   @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(flex: 3, child: Column()),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                        Text("Sub Ledger")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
