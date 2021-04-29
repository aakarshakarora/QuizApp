import 'package:flutter/material.dart';

class BackgroundRegister extends StatelessWidget {
  final Widget child;
  final bool check;
  const BackgroundRegister({
    Key key,
    @required this.child,
    @required this.check,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          check==true?
          Positioned(
            // top: 300,
            // left: 125,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              child: Image.asset(
                "assets/images/stud.jpg",
                //width: size.width * 0.35,
              ),
            ),
          ):
          Positioned(
            // top: 300,
            // left: 125,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              child: Image.asset(
                "assets/images/fac.jpg",
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
