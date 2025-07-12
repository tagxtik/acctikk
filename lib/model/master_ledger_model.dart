import 'package:acctik/model/jornal_model_details.dart';

class MasterLedgerModel {
  final int jornalId;
  final DateTime entredDate; // Using DateTime instead of String
  final String entredBy;
  final double totaldeb;
  final double totalcred;
  final List<JornalModelDetails> details;

  MasterLedgerModel({
    required this.jornalId,
    required this.entredDate,
    required this.entredBy,
    required this.totalcred,
    required this.totaldeb,
    required this.details,
  });

  // Convert the model to a JSON-friendly Map
  Map<String, dynamic> toJson() => {
        'jornalid': jornalId,
        'entredDate':
            entredDate.toIso8601String(), // Convert DateTime to string
        'entredBy': entredBy,
        'totalcred': totalcred,
        'totaldeb': totaldeb,
        'details': details
            .map((detail) => detail.toJson())
            .toList(), // Convert List<JornalModelDetails> to List<Map>
      };

  // Create model from a JSON Map
  factory MasterLedgerModel.fromJson(Map<String, dynamic> json) {
    return MasterLedgerModel(
      jornalId: json['jornalid'] is int
          ? json['jornalid']
          : int.tryParse(json['jornalid'].toString()) ?? 0, // Convert to int
      entredDate:
          DateTime.parse(json['entredDate']), // Parse date string to DateTime
      entredBy: json['entredBy'],
      totalcred: (json['totalcred'] is double)
          ? json['totalcred']
          : double.tryParse(json['totalcred'].toString()) ??
              0.0, // Convert to double
      totaldeb: (json['totaldeb'] is double)
          ? json['totaldeb']
          : double.tryParse(json['totaldeb'].toString()) ??
              0.0, // Convert to double
      details: (json['details'] as List)
          .map((detail) => JornalModelDetails.fromJson(detail))
          .toList(), // Parse List<Map> to List<JornalModelDetails>
    );
  }
}
