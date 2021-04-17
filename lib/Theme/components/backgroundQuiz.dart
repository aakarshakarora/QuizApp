import 'package:flutter/material.dart';

class BackgroundQuiz extends StatelessWidget {
  final Widget child;
  const BackgroundQuiz({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            // top: 300,
            // left: 125,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              child: Image.asset(
                "assets/images/createQuiz.jpg",
                //width: size.width * 0.35,
              ),
            ),
          ),

          child,
        ],
      ),
    );
  }
}
