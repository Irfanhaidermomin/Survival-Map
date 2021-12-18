import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:survival_map/models/user_model.dart';
import 'package:survival_map/modules/chat_details/chat_details_screen.dart';
import 'package:survival_map/shared/adaptive/adaptivw_indicator.dart';
import 'package:survival_map/shared/components/componets.dart';
import 'package:survival_map/shared/components/constants.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getUsers();
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Conditional.single(
            context: context,
            conditionBuilder: (context) => cubit.users.length > 0,
            widgetBuilder: (context) => cubit.users.length == 0
                ? Center(
                    child: Text(
                      'You don\'t have chat between Doctors',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  )
                : ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        buildChatItem(cubit.users[index], context),
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 20
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    itemCount: cubit.users.length,
                  ),
            fallbackBuilder: (context) => Center(
                child: AdaptiveIndicator(
              os: getOS(),
            )),
          );
        },
      );
    });
  }

  Widget buildChatItem(UserModel model, context) => InkWell(
        onTap: () {
          navigateTo(
            context,
            ChatDetailsScreen(
              userModel: model,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                '${model.name}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      );
}
