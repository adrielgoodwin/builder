import 'user_truncated.dart';
import 'happening_request.dart';
import '../Happening.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
  final String city;
  final List<String> friendsIDs;
  final List<HappeningRequest> happeningRequests;
  final List<UserTruncated> friendRequests;
  final List<Happening> myHappenings;


  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImageUrl = 'defaultProfileImage.png',
    required this.city,
    this.friendsIDs = const [],
    required this.happeningRequests,
    required this.friendRequests,
    required this.myHappenings,
  });
}

/// UPDATE NOTES:
/// 1. Make a location class and make city a link to show
/// when the city is clicked on, a little box with map opens,
/// zooms out of your location, then zooms into that city that you clicked on
