import 'package:findgamemates/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class DialogUtils{

  static void createLoadingDialog(BuildContext context, String title, String desc){
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
          color: CustomThemeData.cardColor,
          fontWeight: FontWeight.bold
      ),
      barrierDismissible: false,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.1,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulseRise,
              colors: [
                CustomThemeData.primaryColor,
                CustomThemeData.accentColor,
                CustomThemeData.cardColor
              ],
            ),
          ),
          const SizedBox(width: 20,),
          Flexible(child: Text(desc)),
        ],
      ),
    );
  }

}