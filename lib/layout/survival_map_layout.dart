import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:survival_map/modules/chats/chats_screen.dart';
import 'package:survival_map/modules/doctors/doctors_screen.dart';
import 'package:survival_map/modules/edit_profile/edit_screen.dart';
import 'package:survival_map/modules/map/cubit/cubit.dart';
import 'package:survival_map/modules/map/gmap.dart';
import 'package:survival_map/modules/settings/settings.dart';
import 'package:survival_map/shared/adaptive/adaptivw_indicator.dart';
import 'package:survival_map/shared/components/componets.dart';
import 'package:survival_map/shared/components/constants.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/cubit/states.dart';
import 'package:survival_map/shared/styles/colors.dart';
import 'package:survival_map/shared/styles/icon_broken.dart';

class SurvivalMapLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is MapAddLocationSuccessState) {
            showToast(
                text: 'You are infected and the app follow you',
                state: ToastStates.SUCCESS);
          }
          // if (AppCubit.get(context).userModel == null) {
          //   AppCubit.get(context).getUserData();
          // }
        },
        builder: (context, state) {
          final PageStorageBucket bucket = PageStorageBucket();
          var cubit = AppCubit.get(context);
          var userModel = AppCubit.get(context).userModel;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
              // centerTitle: true,
              actions: [
                cubit.userModel != null
                    ? InkWell(
                  onTap: () {
                    navigateTo(context, EditProfileScreen());
                  },
                  child: CircleAvatar(
                    radius: 24,
                    child: CircleAvatar(
                      radius: 21.0,
                      backgroundImage:
                      NetworkImage('${cubit.userModel!.image}'),
                    ),
                  ),
                )
                    : AdaptiveIndicator(
                  os: getOS(),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            body: PageStorage(
              child: cubit.currentScreen,
              bucket: bucket,
            ),
            floatingActionButton: MapCubit.get(context).infected
                ? FloatingActionButton(
                    child: Icon(Icons.stop),
                    backgroundColor: Colors.red,
                    // splashColor: Colors.white,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      MapCubit.get(context).infected = false;
                      MapCubit.get(context).positionStream!.cancel();
                    },
                  )
                : FloatingActionButton(
                    child: Icon(Icons.coronavirus_outlined),
                    backgroundColor: defaultColor,
                    // splashColor: Colors.white,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      dialog(context);
                    },
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 15,
              color: AppCubit.get(context).isDark!
                  ? HexColor('333739')
                  : Colors.white,
              child: Container(
                height: 55,
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          cubit.currentScreen = GMap();
                          cubit.changeBottomNav(0);
                        },
                        splashColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        highlightColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Icon(
                                IconBroken.Location,
                                color: cubit.currentIndex == 0
                                    ? defaultColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          cubit.currentScreen = ChatsScreen();
                          cubit.changeBottomNav(1);
                        },
                        splashColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        highlightColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Icon(
                                IconBroken.Chat,
                                color: cubit.currentIndex == 1
                                    ? defaultColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          cubit.currentScreen = DoctorsScreen();
                          cubit.changeBottomNav(2);
                        },
                        splashColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        highlightColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Icon(
                                IconBroken.User1,
                                color: cubit.currentIndex == 2
                                    ? defaultColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          cubit.currentScreen = Settings();
                          cubit.changeBottomNav(3);
                        },
                        splashColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        highlightColor: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Icon(
                                IconBroken.Setting,
                                color: cubit.currentIndex == 3
                                    ? defaultColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            "Do you infected Covid-19 ?",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Text(
              "If you click Yes, we will follow you and show your location on a map everywhere you visit. And you can stop tracking you if you click stop."),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: MaterialButton(
                shape: StadiumBorder(),
                minWidth: 100,
                color: defaultColor,
                child: new Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  MapCubit.get(context).infected = true;
                  Navigator.of(context).pop();
                },
              ),
            ),
            MaterialButton(
              shape: StadiumBorder(),
              minWidth: 100,
              color: Colors.redAccent,
              child: new Text("No", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
