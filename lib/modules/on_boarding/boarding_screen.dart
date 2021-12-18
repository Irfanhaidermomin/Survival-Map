import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:survival_map/modules/login/social_login_screen.dart';
import 'package:survival_map/shared/components/componets.dart';
import 'package:survival_map/shared/network/local/cache_helper.dart';
import 'package:survival_map/shared/styles/colors.dart';

class BoardingModel {
  String image;
  String title;
  String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value)
    {
      if (value) {
        navigateAndFinish(
          context,
          LoginScreen(),
        );
      }
    });
  }


  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/applogo.png',
      title: 'Welcome',
      body: 'Hello in App',
    ),
    BoardingModel(
      image: 'assets/images/applogo.png',
      title: 'Next ..',
      body: 'Second',
    ),
    BoardingModel(
      image: 'assets/images/applogo.png',
      title: 'Next ...',
      body: 'third',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(function: submit, text: 'SHIP'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (int value) {
                  if (value == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotWidth: 10,
                    dotHeight: 10,
                    spacing: 5,
                    expansionFactor: 4,
                  ),
                  controller: boardController,
                  count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                          duration: Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image(image: AssetImage('${model.image}'))),
          SizedBox(
            height: 20,
          ),
          Text(
            '${model.title}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '${model.body}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      );
}
