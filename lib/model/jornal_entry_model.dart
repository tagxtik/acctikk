 
class JornalEntryModel {
  final String userValue;
  final String accountType;
  final double debitVal;
  final double creditVal;
  final String jornalName;
  final int jornalId;
  final DateTime jornalDate; // Using DateTime instead of String
  final String accName;
  final String jornalDesc;
  final String orgId;
  final String mainId;
  final String subId;

  JornalEntryModel({
    required this.userValue,
    required this.accountType,
    required this.debitVal,
    required this.creditVal,
    required this.jornalName,
    required this.jornalId,
    required this.jornalDate,
    required this.accName,
    required this.jornalDesc,
    required this.orgId,
    required this.mainId,
    required this.subId,
  });

  // Convert the model to a JSON-friendly Map
  Map<String, dynamic> toJson() => {
        'userValue': userValue,
        'accounttype': accountType,
        'debitVal': debitVal,
        'creditVal': creditVal,
        'jornalname': jornalName,
        'jornalid': jornalId,
        'jornaldate':
            jornalDate.toIso8601String(), // Convert DateTime to string
        'accname': accName,
        'jornaldesc': jornalDesc,
        'orgid': orgId,
        'mainid': mainId,
        'subid': subId,
      };

  // Create model from a JSON Map
  factory JornalEntryModel.fromJson(Map<String, dynamic> json) {
    return JornalEntryModel(
      userValue: json['userValue'],
      accountType: json['accounttype'],
      debitVal: json['debitVal'],
      creditVal: json['creditVal'],
      jornalName: json['jornalname'],
      jornalId: json['jornalid'],
      jornalDate:
          DateTime.parse(json['jornaldate']), // Parse date string to DateTime
      accName: json['accname'],
      jornalDesc: json['jornaldesc'],
      orgId: json['orgid'],
      mainId: json['mainid'],
      subId: json['subid'],
    );
  }
}
