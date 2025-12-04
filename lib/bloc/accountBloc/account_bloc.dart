import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/accountBloc/account_state.dart';
import 'package:ridebooking/models/profile_data_model.dart';
import 'package:ridebooking/repository/ApiRepository.dart';

import '../../repository/ApiConst.dart';
import '../../utils/session.dart';
import 'account_event.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  ProfileDataModel? profileDataModel;
  String? phone;

  AccountBloc() : super(AccountInitial()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<AccountState> emit,
  ) async
  {
    try {
      emit(AccountLoading());

      // Get phone number from session or event
      phone = await Session().getPhoneNo();

      print("phone number in get profile--------->>>>>$phone");

      if (phone != null) {
        var formData = {"phone": phone};

        var response = await ApiRepository.postAPI(
          ApiConst.getProfileApi,
          formData,
          basurl2: ApiConst.baseUrl2,
        );

        final data = response.data;
        print("profile data model before condition-------->>>>${data}");

        if (data["status"] != null && data["status"] == 1) {
          profileDataModel = ProfileDataModel.fromJson(data);
          await Session.saveProfileData(profileDataModel!);

          print(
            "profile data model-------->>>>${profileDataModel!.data!.wallet}",
          );

          emit(AccountSuccess(profileDataModel!));
        } else {
          emit(AccountError("Failed to load profile"));
        }
      } else {
        emit(AccountError("Phone number not found"));
      }
    } catch (e) {
      print("Error in getProfile: $e");
      emit(AccountError("An error occurred: ${e.toString()}"));
    }
  }
  Future<void> _onUpdateProfile(
      UpdateProfileEvent event,
      Emitter<AccountState> emit,
      ) async {
    emit(ProfileUpdateLoading());

    try {

      final formData = {
        'userId': event.userId,
        'firstName': event.firstName,
        'lastName': event.lastName,
        'email': event.email,
        'state': event.state,
      };

      var response = await ApiRepository.postAPI(
        ApiConst.updateProfileApi,
        formData,
        basurl2: ApiConst.baseUrl2,
      );

      if (response.statusCode == 200) {

        // final data = jsonDecode(response.body);
        emit(ProfileUpdateSuccess('Profile updated successfully'));

        // Refresh profile data
        add(FetchUserProfileEvent());
      } else {
        emit(ProfileUpdateError('Failed to update profile'));
      }
    } catch (e) {
      emit(ProfileUpdateError('Error: ${e.toString()}'));
    }
  }
  Future<void> _onLogout(LogoutEvent event, Emitter<AccountState> emit) async {
    try {
      await Session().clearAllData();

      profileDataModel = null;   // <-- clear memory state
      phone = null;

      emit(AccountLogout());     // Emit logout state
      emit(AccountInitial());    // Reset default state
    } catch (e) {
      print("Error in logout: $e");
      emit(AccountError("Logout failed"));
    }
  }

}
