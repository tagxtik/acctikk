import 'package:acctik/data/card_data.dart';
import 'package:acctik/view/Widgets/custom_card.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    final cd = CardData();
     return GridView.builder(
      itemCount: cd.carddata.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 12.0),
      itemBuilder: (context, index) => InkWell(
        child: SingleChildScrollView(
          child: CustomCard(
             child: Column(
            
              children: [
              
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 4),
                  child: Text(
                    cd.carddata[index].value,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  cd.carddata[index].title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                  Image.asset(
                  cd.carddata[index].icon,
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          
        },
      ),
    );
  }
}