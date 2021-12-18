import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survival_map/models/message_model.dart';
import 'package:survival_map/models/user_model.dart';
import 'package:survival_map/modules/map/gmap.dart';
import 'package:survival_map/shared/components/constants.dart';
import 'package:survival_map/shared/cubit/states.dart';
import 'package:survival_map/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  Widget currentScreen = GMap();

  List<String> titles = [
    'Map',
    'Chats',
    'Doctors',
    'Settings',
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  bool? isDark = true;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark!;
      CacheHelper.putBoolean(key: 'isDark', value: isDark!).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  UserModel?
      userModel; // ==> my json model that i use to receive data from Firestore

  void getUserData() {
    // uId = CacheHelper.getData(key: 'uId');
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
  }) {
    emit(AppUserUpdateProfileLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(
          name: name,
          phone: phone,
          image: value,
        );
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    String? image,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: userModel!.email,
      image: image ?? userModel!.image,
      uId: userModel!.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(AppUserUpdateErrorState());
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    emit(AppLoadingGetAllUserDataState());
    if (users.length == 0) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId)
            users.add(UserModel.fromJson(element.data()));
        });
        emit(AppGetAllUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(AppGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(AppGetMessagesSuccessState());
    });
  }
}
