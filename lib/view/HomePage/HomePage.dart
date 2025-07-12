import 'package:acctik/services/move_coll.dart';
import 'package:acctik/view/Widgets/activity_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  children: [
              ///      TextButton(onPressed: (){pd},child:Icon(Icons.print))
                    // TextButton(
                    //     onPressed: () async {
                    //       print("Data Copying .. )}");
                    //       const String sourceCollection = "journals";
                    //       const String destinationDocPath =
                    //           "orgs/Zhrri1UzbA3p7WUVnpwd"; // Replace 'yourDocId' with the actual document ID

                    //       // List of subcollection names you want to copy
                    //       const List<String> subcollectionNames = [
                    //         "jdetails",
                    //         "images"
                    //        ];

                    //       await copyCollectionWithSubcollections(
                    //           sourceCollection,
                    //           destinationDocPath,
                    //           subcollectionNames);
                    //     },
                    //     child: Icon(Icons.change_circle))
                  ],
                )),
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
                          ActivityCard(),
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
