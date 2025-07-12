import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:acctik/view/Accounts/accounts.dart';
import 'package:acctik/view/Widgets/jornal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAllJornalEntry extends StatefulWidget {
  final selectedorg;
  const ListAllJornalEntry({
    super.key,
    required this.selectedorg,
  });

  @override
  State<ListAllJornalEntry> createState() => _ListAllJornalEntryState();
}

class _ListAllJornalEntryState extends State<ListAllJornalEntry> {
  final JornalService js = JornalService();
  final Map<String, Future<String?>> subcache = {};

  @override
  void initState() {
    super.initState();
    Provider.of<JornalChangemod>(context, listen: false).loadItems();
  }

  Future<String?> fetchsub(String orgid, String mainid, String subid) {
    print("org id = : ${orgid}");
    print("mainid id = : ${mainid}");
    print("subid id = : ${subid}");
    if (!subcache.containsKey(subid)) {
      subcache[subid] = js.getSubname(orgid, mainid, subid);
    }
    return subcache[subid]!;
  }

  @override
  Widget build(BuildContext context) {
    final jdetailmod = Provider.of<JornalChangemod>(context);

    if (jdetailmod.items.isEmpty) {
      return const Center(child: Text("No journal entries available."));
    }

    final creditItems =
        jdetailmod.items.where((item) => item.accountType == "Credit").toList();
    final debitItems =
        jdetailmod.items.where((item) => item.accountType == "Debit").toList();

    return Center(
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: debitItems.length + creditItems.length + 3,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 && debitItems.isNotEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Debit Entries",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                } else if (index > 0 && index <= debitItems.length) {
                  return _buildJournalItem(
                    context,
                    debitItems[index - 1],
                    "Debit",
                    index - 1,
                    const Color.fromARGB(255, 92, 1, 1),
                  );
                } else if (index == debitItems.length + 1 &&
                    debitItems.isNotEmpty) {
                  return const Divider();
                } else if (index == debitItems.length + 2 &&
                    debitItems.isNotEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Credit Entries",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                } else if (index > debitItems.length + 2 &&
                    index < debitItems.length + creditItems.length + 3) {
                  return _buildJournalItem(
                    context,
                    creditItems[index - debitItems.length - 3],
                    "Credit",
                    index - debitItems.length - 3,
                    const Color.fromARGB(255, 11, 9, 133),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJournalItem(BuildContext context, dynamic item, String type,
      int itemIndex, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: JornalCard(
        color: color,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 4),
                child: Text(
                  " : $type",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FutureBuilder<String?>(
                future: fetchsub(widget.selectedorg, item.mainId, item.subId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      " : Loading...",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      " : Error",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    );
                  } else {
                    return Text(
                      " : ${snapshot.data ?? "Unknown"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 4),
                child: Text(
                  type == "Debit"
                      ? " : ${item.debitVal}"
                      : " : ${item.creditVal}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<JornalChangemod>(context, listen: false)
                      .deleteItem(itemIndex, type);
                },
                icon: const Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
