import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:survival_map/models/message_model.dart';
import 'package:survival_map/models/user_model.dart';
import 'package:survival_map/shared/adaptive/adaptivw_indicator.dart';
import 'package:survival_map/shared/components/constants.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/cubit/states.dart';
import 'package:survival_map/shared/styles/colors.dart';
import 'package:survival_map/shared/styles/icon_broken.dart';

// ignore: must_be_immutable
class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;

  ChatDetailsScreen({
    required this.userModel,
  });

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var messages = AppCubit.get(context).messages;
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userModel.image),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(userModel.name),
                  ],
                ),
                leading: IconButton(
                  icon: Icon(IconBroken.Arrow___Left_2),
                  color: defaultColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Conditional.single(
                context: context,
                conditionBuilder: (context) => messages.length > 0,
                widgetBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var message = messages[index];
                              if (AppCubit.get(context).userModel!.uId ==
                                  message.senderId)
                                return buildMyMessage(message);

                              return buildMessage(message);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              height: 15,
                            ),
                            itemCount: messages.length,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            height: 50,
                            padding: EdgeInsetsDirectional.only(
                              start: 15,
                              end: 0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey,
                                )),
                            child: TextFormField(
                              controller: messageController,
                              maxLines: 999,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Aa',
                                suffixIcon: MaterialButton(
                                  height: 10,
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    AppCubit.get(context).sendMessage(
                                      receiverId: userModel.uId,
                                      dateTime: DateTime.now().toString(),
                                      text: messageController.text,
                                    );
                                    messageController.clear();
                                  },
                                  color: defaultColor,
                                  elevation: 10,
                                  minWidth: 1,
                                  child: Icon(
                                    IconBroken.Send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                fallbackBuilder: (context) => messages.length == 0
                    ? Column(
                        children: [
                          Spacer(),
                          Center(
                            child: Text(
                              'No Messages yet',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              height: 50,
                              padding: EdgeInsetsDirectional.only(
                                start: 15,
                                end: 0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey,
                                  )),
                              child: TextFormField(
                                controller: messageController,
                                maxLines: 999,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Aa',
                                  suffixIcon: MaterialButton(
                                    height: 10,
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      AppCubit.get(context).sendMessage(
                                        receiverId: userModel.uId,
                                        text: messageController.text,
                                        dateTime: TimeOfDay.now().toString(),
                                      );
                                      messageController.clear();
                                    },
                                    color: defaultColor,
                                    elevation: 10,
                                    minWidth: 1,
                                    child: Icon(
                                      IconBroken.Send,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: AdaptiveIndicator(
                        os: getOS(),
                      )),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Text(model.text),
        ),
      );

  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(
              .2,
            ),
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            model.text,
          ),
        ),
      );
}
