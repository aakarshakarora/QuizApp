import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Screens/SplashScreen/roleCheck.dart';
import 'package:quiz_app/Theme/theme.dart';
import 'CreateGroup/F_View/createGroup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

const dayColor = Color(0xFFd56352);
var nightColor = Color(0xFF1e2230);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: MaterialApp(
        title: 'Proctored Quiz App',
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        home: RoleCheck(),
      ),
    );
  }
}
