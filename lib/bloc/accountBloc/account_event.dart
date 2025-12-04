abstract class AccountEvent{}

class FetchUserProfileEvent extends AccountEvent{}

class LogoutEvent extends AccountEvent{}

class UpdateProfileEvent extends AccountEvent {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String state;

  UpdateProfileEvent({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.state,
  });
}

