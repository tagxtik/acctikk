import 'package:acctik/view/Accounts/accounts.dart';
import 'package:acctik/view/JournalEntry/jornal_entry.dart';
import 'package:acctik/view/JournalEntry/jornal_trans.dart';
import 'package:acctik/view/LogPage/log_page.dart';
import 'package:acctik/view/MasterLedger/list_main_ledger.dart';
import 'package:acctik/view/MasterLedger/master_ledger.dart';
import 'package:acctik/view/SubLedger/sub_ledger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acctik/controller/Navigation/route/navigation_event_bloc.dart';
import 'package:acctik/controller/lang/language_cubit.dart';
import 'package:acctik/generated/l10n.dart';
import 'package:acctik/view/HomePage/HomePage.dart';
import 'package:acctik/view/Organizations/Org.dart';
import 'package:acctik/view/Reports/Reports.dart';
import 'package:acctik/view/Setting/Setting.dart';
import 'package:acctik/view/Sidebar/Sidebar.dart';
import 'package:acctik/view/Widgets/ThemeToggle.dart';
import 'package:go_router/go_router.dart';

class StagePage extends StatefulWidget {
  const StagePage({super.key});

  @override
  State<StagePage> createState() => _StagePageState();
}

class _StagePageState extends State<StagePage> {
  @override
  Widget build(BuildContext context) {
    // final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final screenWidth = MediaQuery.of(context).size.width;

    final ThemeData theme = Theme.of(context);
    @override
    void initState() {
      super.initState();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          // If the user logs out or is not authenticated, navigate to the login screen
          context.goNamed("Home");
        }
      });
    }

    Future<void> _signOut(BuildContext context) async {
      try {
        await _auth.signOut();
        // Navigate to the login screen after signing out
        context.goNamed("Login");
      } catch (e) {
        print('Error signing out: $e');
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(80), // Set the desired app bar height
        child: Center(
          child: AppBar(
            backgroundColor: theme.indicatorColor,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('/imgs/icon1.png'),

                radius: screenWidth * 2, // Adjust size based on screen width
                backgroundColor:
                    Colors.transparent, // Access custom property from extension
                foregroundColor: theme.canvasColor,
              ),
            ),
            title: Text(
              'Acctik',
              style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ThemeToggle(),
                        VerticalDivider(
                          thickness: 0.5,
                          color: theme.canvasColor.withOpacity(0.3),
                          indent: 500,
                          endIndent: 10,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.language,
                            color: theme.canvasColor,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  child: AlertDialog(
                                    title: const Text('Dialog Title'),
                                    content: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: ListView.builder(
                                        itemCount:
                                            S.delegate.supportedLocales.length,
                                        itemBuilder: (context, index) {
                                          final locale = S
                                              .delegate.supportedLocales[index];
                                          return SizedBox(
                                            width: 20,
                                            height: 50,
                                            child: ListTile(
                                              title: Text(locale.languageCode),
                                              onTap: () {
                                                BlocProvider.of<LanguageCubit>(
                                                        context)
                                                    .setLanguage(locale);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () =>
                              _signOut(context), // Call sign out when pressed
                        ),
                      ],
                    ),
                  ])
            ],
          ),
        ),
      ),
      body: BlocProvider<NavigationCubit>(
        create: (context) => NavigationCubit(),
        child: Stack(
          children: [
            BlocBuilder<NavigationCubit, NavigationEvent>(
              builder: (context, state) {
                if (state == NavigationEvent.HomePageClickedEvent) {
                  return const Padding(
                      padding: EdgeInsets.all(30), child: HomePage());
                } else if (state == NavigationEvent.OrgClickedEvent) {
                  return const Padding(
                      padding: EdgeInsets.all(30), child: Org());
                } else if (state == NavigationEvent.AccountsClickedEvent) {
                  return const Padding(
                      padding: EdgeInsets.all(30), child: Accounts());
                } else if (state == NavigationEvent.JornalEntryClickedEvent) {
                  return const Padding(
                      padding: EdgeInsets.all(30), child: JornalEntry());
                } else if (state ==
                    NavigationEvent.JornalEntryTransactionClickedEvent) {
                  return const Padding(
                      padding: EdgeInsets.all(30), child: JornalTrans());
                } else if (state == NavigationEvent.MasterledgerClickEvent) {
                  return Padding(
                      padding: const EdgeInsets.all(30), child: MasterLedger());
                } else if (state == NavigationEvent.SubledgerClickEvent) {
                  return const Padding(
                      padding: EdgeInsets.all(30), child: SubLedger());
                } else if (state == NavigationEvent.logDataClickEvent) {
                  return const LogPage();
                } else if (state == NavigationEvent.SettingClickedEvent) {
                  return const Setting();
                } else if (state == NavigationEvent.ReportsClickedEvent) {
                  return Reports();
                }
                return Container();
              },
            ),
            const Sidebar()
          ],
        ),
      ),
    );
  }
}
