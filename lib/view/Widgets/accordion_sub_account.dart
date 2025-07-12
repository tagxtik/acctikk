import 'package:flutter/material.dart';

class AccordionSubAccount extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const AccordionSubAccount({super.key, required this.title, required this.children});

  @override
  _AccordionSubAccountState createState() => _AccordionSubAccountState();
}

class _AccordionSubAccountState extends State<AccordionSubAccount> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(widget.title),
              trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            );
          },
          body: Column(
            children: widget.children,
          ),
          isExpanded: _isOpen,
        ),
      ],
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isOpen = isExpanded;
        });
      },
    );
  }
}