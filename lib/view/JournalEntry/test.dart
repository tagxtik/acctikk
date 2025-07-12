 import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return // Figma Flutter Generator LoginWidget - FRAME
        Expanded(
      flex: 6,
      child: SingleChildScrollView(
        child: Container(
            width: 1366,
            height: 768,
            decoration: BoxDecoration(
              color: Color.fromRGBO(43, 60, 71, 1),
            ),
            child: Stack(children: <Widget>[
              Positioned(
                  top: 139,
                  left: 256,
                  child: Container(
                      width: 855,
                      height: 489,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(43),
                          topRight: Radius.circular(43),
                          bottomLeft: Radius.circular(43),
                          bottomRight: Radius.circular(43),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment(6.123234262925839e-17, 1),
                            end: Alignment(-1, 6.123234262925839e-17),
                            colors: [
                              Color.fromRGBO(241, 241, 241, 1),
                              Color.fromRGBO(215, 215, 215, 1),
                              Color.fromRGBO(195, 193, 193, 1)
                            ]),
                      ))),
              Positioned(
                  top: 86,
                  left: 630,
                  child: Container(
                      width: 106,
                      height: 106,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/Vectorsmartobject1.png'),
                            fit: BoxFit.fitWidth),
                      ))),
              Positioned(
                  top: 237,
                  left: 574,
                  child: Text(
                    'تسجيل الدخول',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(43, 60, 71, 1),
                        fontFamily: 'Roboto',
                        fontSize: 36,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.2222222222222223),
                  )),
              Positioned(
                  top: 525,
                  left: 523,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(1000),
                        topRight: Radius.circular(1000),
                        bottomLeft: Radius.circular(1000),
                        bottomRight: Radius.circular(1000),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Email',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5 /*PERCENT not supported*/
                                    ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Description',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(117, 117, 117, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5 /*PERCENT not supported*/
                                    ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  border: Border.all(
                                    color: Color.fromRGBO(217, 217, 217, 1),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Value',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(179, 179, 179, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1.5 /*PERCENT not supported*/
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Error',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5 /*PERCENT not supported*/
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(width: 8),
                                    Text(
                                      'Cancel',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(48, 48, 48, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1.5 /*PERCENT not supported*/
                                          ),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(1000),
                                    topRight: Radius.circular(1000),
                                    bottomLeft: Radius.circular(1000),
                                    bottomRight: Radius.circular(1000),
                                  ),
                                  color: Color.fromRGBO(44, 44, 44, 1),
                                  border: Border.all(
                                    color: Color.fromRGBO(44, 44, 44, 1),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(width: 8),
                                    Text(
                                      'تذكرني',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(245, 245, 245, 1),
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1.5 /*PERCENT not supported*/
                                          ),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  top: 324,
                  left: 472,
                  child: Container(
                    decoration: BoxDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'إسم المستخدم',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              fontFamily: 'Inter',
                              fontSize: 16,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.5 /*PERCENT not supported*/
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(117, 117, 117, 1),
                              fontFamily: 'Inter',
                              fontSize: 16,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.5 /*PERCENT not supported*/
                              ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1000),
                              topRight: Radius.circular(1000),
                              bottomLeft: Radius.circular(1000),
                              bottomRight: Radius.circular(1000),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 28),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Value',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5 /*PERCENT not supported*/
                                    ),
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hint',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(117, 117, 117, 1),
                              fontFamily: 'Inter',
                              fontSize: 16,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.5 /*PERCENT not supported*/
                              ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  top: 439,
                  left: 472,
                  child: Container(
                    decoration: BoxDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'الرقم السري',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              fontFamily: 'Inter',
                              fontSize: 16,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.5 /*PERCENT not supported*/
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(117, 117, 117, 1),
                              fontFamily: 'Inter',
                              fontSize: 16,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.5 /*PERCENT not supported*/
                              ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1000),
                              topRight: Radius.circular(1000),
                              bottomLeft: Radius.circular(1000),
                              bottomRight: Radius.circular(1000),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 28),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Value',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5 /*PERCENT not supported*/
                                    ),
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hint',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(117, 117, 117, 1),
                              fontFamily: 'Inter',
                              fontSize: 16,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.5 /*PERCENT not supported*/
                              ),
                        ),
                      ],
                    ),
                  )),
              Positioned(top: 341, left: 488, child: Container()),
              Positioned(top: 465, left: 498, child: Container()),
            ])),
      ),
    );
  }
}
