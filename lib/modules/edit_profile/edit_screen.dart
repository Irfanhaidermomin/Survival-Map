import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_map/shared/components/componets.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/cubit/states.dart';
import 'package:survival_map/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (AppCubit.get(context).userModel == null) {
          AppCubit.get(context).getUserData();
        }
      },
      builder: (context, state) {
        var userModel = AppCubit.get(context).userModel;
        var profileImage = AppCubit.get(context).profileImage;
        nameController.text = userModel!.name;
        phoneController.text = userModel.phone;
        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: 'Edit profile', actions: [
            defaultTextButton(
                function: () {
                  AppCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                },
                text: 'update'),
            SizedBox(
              width: 15,
            )
          ]),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is AppGetUserLoadingState)
                    LinearProgressIndicator(),
                  if (state is AppGetUserLoadingState)
                    SizedBox(
                      height: 10.0,
                    ),
                  Container(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16,
                                ),
                              ),
                              onPressed: () {
                                AppCubit.get(context).getProfileImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (AppCubit.get(context).profileImage != null)
                    Row(
                      children: [
                        if (AppCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    AppCubit.get(context).uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                                  text: 'upload profile',
                                ),
                                if (state is AppUserUpdateProfileLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is AppUserUpdateProfileLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  if (AppCubit.get(context).profileImage != null)
                    SizedBox(
                      height: 20,
                    ),
                  Column(
                    children: [
                      defaultFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'name must not be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: IconBroken.User,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'phone number must not be empty';
                          }

                          return null;
                        },
                        label: 'Phone',
                        prefix: IconBroken.Call,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
