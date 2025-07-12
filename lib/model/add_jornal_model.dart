import 'dart:ffi';
 
class AddJornalModel {
  String jornalname;
  String jornalid;
  DateTime jornaldate;
  String jornaldesc;
  Double madeen;
  Double daeen;
  String orgid;
  String mainid;
  String subid;
 
  AddJornalModel({
    required this.jornalname,
    required this.jornalid,
    required this.jornaldate,
    required this.jornaldesc,
    required this.madeen,
    required this.daeen,
    required this.orgid,
    required this.mainid,
    required this.subid,
   });
}
