
import 'package:flutter/material.dart';

class JustFrame extends StatefulWidget {
 

  const JustFrame(
      {super.key });

  @override
  _JustFrameState createState() => _JustFrameState();
}

class _JustFrameState extends State<JustFrame> {
 

  @override
  void initState() {
    super.initState();
   }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       
        SizedBox(
          width: 2000,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: 2000,
              ),
              child:  Text("Your List or widget")
            ),
          ),
        ),
      ],
    );
  }
}
