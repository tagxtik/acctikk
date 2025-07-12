class JornalModelDetails {
  final int jornalId;
  final DateTime entredDate; // Using DateTime instead of String
  final String entredBy;
  final String type;
  final String mainid;
  final String subid;

  //final String subname;
  final double value;

  JornalModelDetails(
      {required this.jornalId,
      required this.entredDate,
      required this.entredBy,
      required this.type,
      required this.mainid,
      required this.subid,
      // required this.subname,
      required this.value});

  // Convert the model to a JSON-friendly Map
  Map<String, dynamic> toJson() => {
        'jornalid': jornalId,
        'entredDate':
            entredDate.toIso8601String(), // Convert DateTime to string
        'entredBy': entredBy,
        'type': type,
        'mainid': mainid,
        'subid': subid,
        // 'subname': subname,

        'value': value,
      };

  // Create model from a JSON Map
  factory JornalModelDetails.fromJson(Map<String, dynamic> json) {
    return JornalModelDetails(
      jornalId: json['jornalid'] is int
          ? json['jornalid']
          : int.tryParse(json['jornalid'].toString()) ?? 0, // Convert to int
      entredDate:
          DateTime.parse(json['entredDate']), // Parse date string to DateTime
      entredBy: json['entredBy'],
      type: json['type'],
      mainid: json['mainid'],
      subid: json['subid'],
      //  subname: json['subname'],
      value: json['value'],
    );
  }
}
