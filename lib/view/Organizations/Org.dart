 import 'package:acctik/view/Widgets/all_org.dart';
import 'package:acctik/view/Widgets/header_widget.dart';
import 'package:flutter/material.dart';

class Org extends StatefulWidget {
  const Org({super.key});

  @override
  State<Org> createState() => _OrgState();
}

class _OrgState extends State<Org> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const Expanded(flex: 1, child: Column()),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                    HeaderWidget(),
                      const SizedBox(
                        height: 18,
                      ),
                      const AllOrg(),
                      const SizedBox(height: 18,),
                      
               ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
             const Expanded(flex: 4, child: Column()),
          ],
        ),
      ),
    );
  }
}
