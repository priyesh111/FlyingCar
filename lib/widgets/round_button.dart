import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;

  RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});


  @override
  Widget build(BuildContext context) {
    // dthgthtrhththetth
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      child: Container(
        height: deviceHeight * 0.06,
        decoration: BoxDecoration(
          color: Color(0xffE8740C),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading == true
              ? CircularProgressIndicator(
                  color: Colors.green,
                )
              : Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: ConstFont.popinsMedium,
                      fontSize: 16),
                ),
        ),
      ),
    );
  }
}
