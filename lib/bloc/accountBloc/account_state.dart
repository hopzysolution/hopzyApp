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