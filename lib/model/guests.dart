class GuestFields {
  static const String name = 'Guest Name';
  static const String ceremony = 'Ceremony Attendance';
  static const String reception = 'Reception Attendance';
  static const String dietary = 'Dietary Requirements';
  static const String groupId = 'Group ID';

  static List<String?> getFields() =>
      [name, ceremony, reception, dietary, groupId];
}

class Guest {
  final String name;
  final String ceremony;
  final String reception;
  final String? dietary;
  final String? groupId;

  const Guest({
    required this.name,
    required this.ceremony,
    required this.reception,
    this.dietary,
    this.groupId,
  });

  static Guest fromJson(Map<String, dynamic> json) => Guest(
        name: json[GuestFields.name],
        ceremony: json[GuestFields.ceremony],
        reception: json[GuestFields.reception],
        dietary: json[GuestFields.dietary],
        groupId: json[GuestFields.groupId],
      );

  Map<String, dynamic> toJson() => {
        GuestFields.name: name,
        GuestFields.ceremony: ceremony,
        GuestFields.reception: reception,
        GuestFields.dietary: dietary,
      };
}
