import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_map/modules/edit_profile/edit_screen.dart';
import 'package:survival_map/modules/login/social_login_screen.dart';
import 'package:survival_map/shared/components/componets.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/cubit/states.dart';
import 'package:survival_map/shared/styles/colors.dart';
import 'package:survival_map/shared/styles/icon_broken.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // AppCubit.get(context).getUsers();
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (AppCubit.get(context).userModel == null) {
            AppCubit.get(context).getUserData();
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var userModel = AppCubit.get(context).userModel;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('Account', style: Theme.of(context).textTheme.bodyText1,),
                  // SizedBox(height: 10,),
                  // myDivider(),
                  // SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        navigateTo(context, EditProfileScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(
                                '${userModel!.image}',
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userModel.name}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Manage your Account',
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              ],
                            ),
                            Spacer(),
                            Expanded(
                              child: Icon(
                                IconBroken.Arrow___Right_2,
                                color: defaultColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Mode', style: Theme.of(context).textTheme.bodyText1,),
                  SizedBox(height: 10,),
                  myDivider(),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      // Icon(
                      //   Icons.brightness_2_outlined,
                      //   color: cubit.isDark! ? Colors.white : Colors.black,
                      // ),
                      Text(
                        'Tab to change mode',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Spacer(),
                      Expanded(
                        child: DayNightSwitcher(
                          isDarkModeEnabled: cubit.isDark!,
                          onStateChanged: (isDarkModeEnabled) =>
                              cubit.changeAppMode(),
                        ),
                      )
                    ],
                  ),
                  Text('About', style: Theme.of(context).textTheme.bodyText1,),
                  SizedBox(height: 10,),
                  myDivider(),
                  SizedBox(height: 10,),
                  // SwitchListTile(
                  //   value: cubit.isDark!,
                  //   onChanged: (b) {
                  //     cubit.changeAppMode();
                  //   },
                  //   title: Text('Dark Mode'),
                  //   // subtitle: Text('Dark or Light'),
                  //   secondary: Icon(
                  //     Icons.brightness_2_outlined,
                  //     color: cubit.isDark! ? Colors.white : Colors.black,
                  //   ),
                  // ),
                  ListTile(
                    title: Text('Help Center'),
                    leading: Icon(
                      IconBroken.Info_Circle,
                      color: cubit.isDark! ? Colors.white : Colors.black,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(
                      IconBroken.Logout,
                      color: cubit.isDark! ? Colors.white : Colors.black,
                    ),
                    onTap: () {
                      navigateTo(context, LoginScreen());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
