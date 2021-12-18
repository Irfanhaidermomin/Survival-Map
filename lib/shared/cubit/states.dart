abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeModeState extends AppStates {}

class AppChangeMapState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class AppGetUserLoadingState extends AppStates {}

class AppGetUserSuccessState extends AppStates {}

class AppGetUserErrorState extends AppStates {
  final String error;

  AppGetUserErrorState(this.error);
}

class AppGetAllUsersLoadingState extends AppStates {}

class AppGetAllUsersSuccessState extends AppStates {}

class AppLoadingGetAllUserDataState extends AppStates {}

class AppGetAllUsersErrorState extends AppStates {
  final String error;

  AppGetAllUsersErrorState(this.error);
}

class AppProfileImagePickedSuccessState extends AppStates {}

class AppProfileImagePickedErrorState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageErrorState extends AppStates {}

class AppUserUpdateProfileLoadingState extends AppStates {}

class AppUserUpdateErrorState extends AppStates {}
// chat

class AppSendMessageSuccessState extends AppStates {}

class AppSendMessageErrorState extends AppStates {}

class AppGetMessagesSuccessState extends AppStates {}

class AppLogOutState extends AppStates {}

class AppLogOutSuccessState extends AppStates {
  // final String uId;
  //
  // AppLogOutSuccessState(this.uId);

}

class AppLogOutErrorState extends AppStates {
  final String error;

  AppLogOutErrorState(this.error);
}
