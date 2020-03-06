import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'home.dart';
import 'home1.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  //best practise this whay we used it 
  //1 & 0 in basic 1 signedIn 1 not 
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  //state variable to indicte if the user signed in or not
  //facing propblem with firebase and firewall proxym
  AuthStatus authStatus = AuthStatus.notSignedIn;
  //AuthStatus authStatus = AuthStatus.signedIn; // just for now so i can work
  //on the home page
  initState() {
    //intialization of the satate 
    //if the user id is  null then the user is signed out 
    //dejea heya intialzer notSignedIn
    //kont najim n3mlha 0 w 1 but no best practis stuff kill me now
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    //when the user is in then authstate wil be signedin 
    //what s the diffrence bin loged in and signed in ?
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }
  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return (
          //Home(auth: widget.auth,onSignedOut: _signedOut,)
          MyHomePage(auth: widget.auth,onSignedOut: _signedOut,)
          );
    }
    //firewall proxym propblem
    //return (Home(auth: widget.auth,onSignedOut: _signedOut,));
  }
}