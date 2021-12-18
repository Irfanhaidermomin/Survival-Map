import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:survival_map/layout/survival_map_layout.dart';
import 'package:survival_map/modules/login/social_login_screen.dart';
import 'package:survival_map/modules/on_boarding/boarding_screen.dart';
import 'package:survival_map/shared/components/constants.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/cubit/states.dart';
import 'package:survival_map/shared/network/local/cache_helper.dart';
import 'package:survival_map/shared/styles/themes.dart';

import 'modules/map/cubit/cubit.dart';
import 'shared/bloc_observer.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  Widget? widget;
  uId = CacheHelper.getData(key: 'uId') ?? CacheHelper.getData(key: 'uId');
  print(uId);
  if (onBoarding != null) {
    if (uId != null)
      widget = SurvivalMapLayout();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MapCubit()
              ..getUserLocation()
              ..setCurrentLocation()
              ..storeAndCalculateDistance(),
          ),
          BlocProvider(
            create: (BuildContext context) => AppCubit()
              ..changeAppMode(
                fromShared: isDark,
              )..getUserData(),
          ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: AppCubit.get(context).isDark!
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: SplashScreenView(
                navigateRoute: startWidget,
                duration: 5000,
                imageSize: 130,
                imageSrc: "assets/images/applogo.png",
                text: "Survival Map",
                textType: TextType.ColorizeAnimationText,
                textStyle: TextStyle(
                  fontSize: 40.0,
                ),
                colors: [
                  Colors.purple,
                  Colors.cyan,
                  Colors.yellow,
                  Colors.lightBlue,
                ],
                backgroundColor: AppCubit.get(context).isDark!
                    ? HexColor('333739')
                    : Colors.white,
              ),
            );
          },
        ));
  }
}
