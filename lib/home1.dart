import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:provider/provider.dart';
import 'provider/profile.dart';
import 'package:flutter/services.dart';
import 'carpoolor.dart';
import 'passanger.dart';

class MyHomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  MyHomePage({this.auth, this.onSignedOut});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
//for creating list of availbel roles
class Role{
  //defing class role 
  //to creat 2 carpooler and passanger
  Role(String title,bool cheked){
    this.title=title;
    this.cheked=cheked;
  }
  String title;
  bool cheked=false;  
}
//for creating list of availbel roles

enum bodyType {
  //enum agin it s like variable that takes 1 if the user is register
  //0 if he s trying to login 
  listOfRequests,
  listOfTrips,
  add,
}


class _MyHomePageState extends State<MyHomePage> {
  List<Role> _roles = [Role("carpoolor", false),Role("passanger", false)];
 
  //sign out function
  void _signOut() async {
    //when the user is login out it will call my auth object to log out the user
    try {
      await  widget.auth.signOut();
      widget. onSignedOut();
    } catch (e) {
      print(e);
    }
  } 
  //sign out function
 
  
  @override
Widget build(BuildContext context) {
    final profile=Provider.of<Profile>(context);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return  Scaffold(
        backgroundColor: Colors.lightGreen,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  
                  Container(
                      width: 125.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                         
                          IconButton(
                            icon: Icon(Icons.exit_to_app),
                            color: Colors.white,
                            onPressed: _signOut,
                          )
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  Text('welcome',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 25.0))
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              height: MediaQuery.of(context).size.height - 185.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
              ),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 45.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height - 300.0,
                          child:  roles(profile),//UiRoles(auth:widget.auth,onSignedOut: _signOut,),
                          )),
                     
                ],
              ),
            )
          ],
        ),
      );

  }
  Column roles(Profile profile)
  {
    return(Column(
        children: <Widget>[
        Expanded(
          child:
        ListView.builder(
            itemCount: _roles.length,
            itemBuilder: (BuildContext context,int index)
            {
              return(Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      CheckboxListTile(
                        value: _roles[index].cheked,
                        title: Text(_roles[index].title),
                        onChanged:(value)=>{
                          //on change function 
                          //when the user check his role 
                          //all the other roles will be uncheked 
                          //and the _role will be set to that role
                           setState(() {
                            _roles[index].cheked=true;
                            for (var i = 0; i < _roles.length; i++) {if (i!= index){_roles[i].cheked=false;} }
                            String role=_roles[index].title;
                            profile.setRole(role);
                            print('current role of the user is ${role}');
                           
                          })
                        },
                      ),                                                                                                                                                                                                                                        
                     
                    ],
                    
                  ),
                ),
              ));
            },
          )),
          Padding(
            //ui stuff
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
            //ui stuff again
            padding: EdgeInsets.all(12),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //function
            child: new Text('submit', style: new TextStyle(fontSize: 20.0,color: Colors.white)),
              onPressed: ()=>
              {
              if (profile.getRole()=="carpoolor")
              {
               profile.saveUserToDataBase(),
               Navigator.push(context, MaterialPageRoute(builder: (context)=>Carpoolor())),
               
              }else
              {
               
                 profile.saveUserToDataBase(),
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Passanger())),
               
              } 
          },
          )),
          ]
          ));
  }

}

