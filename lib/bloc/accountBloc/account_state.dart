import '../../models/profile_data_model.dart';

abstract class AccountState{}

class AccountInitial extends AccountState{}

class AccountLoading extends AccountState{}

class AccountSuccess extends AccountState{
  final ProfileDataModel userProfile;

  AccountSuccess(this.userProfile);
}

class AccountError extends AccountState{
  final String errorMessage;

  AccountError(this.errorMessage);
}

class AccountLogout extends AccountState{}

class ProfileUpdateLoading extends AccountState {}

class ProfileUpdateSuccess extends AccountState {
  final String message;
  ProfileUpdateSuccess(this.message);
}

class ProfileUpdateError extends AccountState {
  final String message;
  ProfileUpdateError(this.message);
}