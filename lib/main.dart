import 'package:flutter/material.dart';
import 'package:proxym/login_page.dart';
import 'auth.dart';
import 'root_page.dart';
import 'package:provider/provider.dart';
import 'provider/profile.dart';

void main()
{runApp(new Proxym());}
class Proxym extends StatelessWidget {
  @override
  // i don t belive i need roots for now 
  //keep on mind that
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
       builder: (ctx)=>Profile(),
          child: new MaterialApp(
         title: "proxym",
         theme: new ThemeData(
           primarySwatch: Colors.green,
           fontFamily: "Nunito",

         ),
         //defining home here
         home:RootPage(auth: Auth(),),
      ),
    );
  }
}