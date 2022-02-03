import 'v_01_classes/user_truncated.dart';
import 'v_01_classes/location.dart';

class Happening {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final Location location;
  final String category;
  final UserTruncated creator;

  Happening({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.category,
    required this.creator,
  });
}

/// UPDATE NOTES:
/// implement role play
