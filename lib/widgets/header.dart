import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteif/helper/colors.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Theme.of(context).brightness == Brightness.light
          ? BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.veryLightGray, AppColors.whiteSmoke],
            ))
          : BoxDecoration(color: Colors.grey[850]),
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Noteif',
        style: TextStyle(
          fontFamily: 'Chewy',
          fontSize: 30.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
