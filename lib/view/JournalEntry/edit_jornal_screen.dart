import 'package:acctik/global/jDetailMod.dart';
import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:acctik/view/Widgets/jornal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditJornalScreen extends StatefulWidget {
  final int jid;
  final String orgid;

  EditJornalScreen({super.key, required this.jid, required this.orgid});

  final JornalService js = JornalService();

  @override
  State<EditJornalScreen> createState() => _EditJornalScreenState();
}

final JornalService js = JornalService();
final Map<String, Future<String?>> subcatche = {};

class _EditJornalScreenState extends State<EditJornalScreen> {
  @override
  void initState() {
    super.initState();
    widget.js.fetchJournalEntries(widget.jid, widget.orgid).then((_) {
      Provider.of<Jdetailmod>(context, listen: false).loadItems();
    });
  }

  Future<String?> fetchsub(String mainid, String subid) {
    // Use a cached Future to prevent duplicate fetches
    if (!subcatche.containsKey(subid)) {
      subcatche[subid] = js.getSubname(widget.orgid, mainid, subid);
    }
    return subcatche[subid]!;
  }

  @override
  Widget build(BuildContext context) {
    final jdetailmod = Provider.of<Jdetailmod>(context);

    if (jdetailmod.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final creditItems =
        jdetailmod.items.where((item) => item.type == "Credit").toList();
    final debitItems =
        jdetailmod.items.where((item) => item.type == "Debit").toList();

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
            child: Consumer<JornalChangemod>(
              builder:
                  (BuildContext context, JornalChangemod value, Widget? child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: debitItems.length + creditItems.length + 3,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0 && debitItems.isNotEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Debit Entries",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJournalItem(BuildContext context, dynamic item, String type,
      int itemIndex, Color color) {
    String sid = "";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: JornalCard(
        color: color,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: InkWell(
            onTap: () => print(item.subid),
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
                  future: fetchsub(item.mainid, item.subid),
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
                      sid = snapshot.data!;
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
                    " : ${item.value}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<Jdetailmod>(context, listen: false)
                        .deleteItem(itemIndex, type);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
