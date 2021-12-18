import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:survival_map/layout/survival_map_layout.dart';
import 'package:survival_map/modules/register/cubit/cubit.dart';
import 'package:survival_map/modules/register/cubit/states.dart';
import 'package:survival_map/shared/adaptive/adaptivw_indicator.dart';
import 'package:survival_map/shared/components/componets.dart';
import 'package:survival_map/shared/components/constants.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/network/local/cache_helper.dart';
import 'package:survival_map/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is CreateUserErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is CreateUserSuccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) async {
              navigateAndFinish(
                context,
                SurvivalMapLayout(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: defaultAppBar(context: context, title: ''),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: AppCubit.get(context).isDark!
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          suffix: RegisterCubit.get(context).suffix,
                          onSubmit: (value) {},
                          isPassword: RegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            RegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              state is! RegisterLoadingState,
                          widgetBuilder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              text: 'register',
                              isUpperCase: true,
                              background: defaultColor),
                          fallbackBuilder: (context) =>
                              Center(
                                  child: AdaptiveIndicator(
                                    os: getOS(),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
