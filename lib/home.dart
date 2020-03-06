import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:provider/provider.dart';
import 'provider/profile.dart';
import 'package:flutter/services.dart';


/*
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

enum FormType {
  //enum agin it s like variable that takes 1 if the user is register
  //0 if he s trying to login 
  rol,
  passanger,
  carpooler,
  listOfTrips,
}


class _MyHomePageState extends State<MyHomePage> {
 
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
  List<Role> _roles = [Role("carpoolor", false),Role("passanger", false)];
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return ChangeNotifierProvider(
        builder: (ctx)=>Profile(),
        child: Scaffold(
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
                          child:  UiRoles(auth:widget.auth,onSignedOut: _signOut,),
                          )),
                     
                ],
              ),
            )
          ],
        ),
      ),
    );

  }

}
//UiRoles
class UiRoles extends StatefulWidget {
  final VoidCallback onSignedOut;
  final BaseAuth auth;
  UiRoles({this.auth,this.onSignedOut});
  @override
  _UiRolesState createState() => _UiRolesState();
}

class _UiRolesState extends State<UiRoles> {
  //this widget will handel the role chosed by the user 
  //caro
  List<Role> _roles = [Role("carpoolor", false),Role("passanger", false)];
  FormType _formType=FormType.rol;
  String role=null;


  final formKey = new GlobalKey<FormState>();

   initState() {
    //intialization of the satate 
    //if the user id is  null then the user is signed out 
    //dejea heya intialzer notSignedIn
    //kont najim n3mlha 0 w 1 but no best practis stuff kill me now
    super.initState();
    if (this.role==null) {
      setState(() {
          this._formType=FormType.rol;
      });
    };
  }
    //date stuff
  DateTime _date =DateTime.now();
  TimeOfDay _time= TimeOfDay.now();

  Future<void> _selectTime(BuildContext context,Profile profile) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time)
      {
        print(picked);
        profile.setTimeOfTheTrip(picked);

      }
  }
    //date stuff
  @override
  Widget build(BuildContext context) {
    final profile=Provider.of<Profile>(context);
    this.role=profile.getRole();
    /*switch (this._formType) {
      case  FormType.carpooler:
         return(
            Form(
            key: formKey,
            child: carpoolorForm(profile,formKey),
           )
           //Container(child: Text("${profile.getRole()}"))
           );
      case FormType.passanger:
        return(
          Form(
            key: formKey,
            child:passangerForm(profile, formKey),
          )

          //Container(child: Text("${profile.getRole()}"),)
        );
        case FormType.listOfTrips:
        return(
          Form(
            key: formKey,
            child:tripList(profile, formKey),
          )

          //Container(child: Text("${profile.getRole()}"),)
        );
      default:
      return roles(role,profile);
    }*/
    return roles(role,profile);
    
  }
   void sendData(Profile profile) async {
    //here if the info are correct we do stuff
   
      String userId = await widget.auth.currentUser();
      print(userId);
      profile.saveUserToDataBase(userId);
      
      if (profile.getRole()=="passanger"){
        profile.saveTripRequestToDataBase(userId);
      }
      else{

        profile.saveTripToDataBase(userId);
      }
  }
  Column roles(String role,Profile profile)
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
                            role=_roles[index].title;
                            profile.setRole(role);
                           // print('current role of the user is ${role}');
                           
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Carpoolor(auth: widget.auth)))
              
              }else
              {
                if(profile.getRole()=="passanger")
                {
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Passanger()))
                }else{
                  setState(() {this._formType=FormType.rol;
                  }),
                  profile.setRole(null)
                }
              
              } 
          },
          )),
          ]
          ));
  }
 ListView carpoolorForm(Profile profile,GlobalKey<FormState> formKey ){
    List <String> destintions=profile.getAvailbelDestination();
   
   return(
      ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 24,),
              DropdownButton<String>(
                  icon: Icon(Icons.edit_location),
                  hint: Text("destination"),
                  items: destintions.map((String item){
                    return DropdownMenuItem<String>(  value: item,
                    child: Text(item),);
                  }).toList(),
                  onChanged: (value){
                    profile.setDestintion(value);
                    //print(profile.getDestintion());
                    },
                
                ),
                SizedBox(width: 50,),
                Text("${profile.getDestintion()}"), 
            ],
          ),
          SizedBox(height: 20,),
          Row(
            
            children: <Widget>[
              SizedBox(width: 20,),
               RawMaterialButton(
                 onPressed: (){_selectTime(context,profile); },
                child: Row(
                  children: <Widget>[
                    new Icon(
                  Icons.time_to_leave,
                  color: Colors.black,
                  size: 20.0,),
                  SizedBox(width: 10,),
                  Text("chose time")
                  ],
                ),
                
              ),
              
              SizedBox(width: 60,),
              Text("${profile.getTimeOfTheTrip().hour } : ${profile.getTimeOfTheTrip().minute } "),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Icon(Icons.event_seat),
              SizedBox(width: 20,),
              Text("${profile.getNbOfSeats()}"),
              SizedBox(width: 40,),
              RawMaterialButton(
                onPressed: () {profile.increasSeats();},
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 15.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.lightGreen,
                padding: const EdgeInsets.all(15.0),
              ),
              RawMaterialButton(
                onPressed: () {profile.decreasSeats();},
                child: new Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 15.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.lightGreen,
                padding: const EdgeInsets.all(15.0),
              ),
              
            ],
          ),
           SizedBox(height: 40.0,),       
           Padding(
            //ui stuff
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
            //ui stuff again
            padding: EdgeInsets.all(12),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //function
            child: new Text('submit', style: new TextStyle(fontSize: 20.0,color: Colors.white)),
            onPressed: (){sendData(profile);},
          
          
          ))
          ,
          new FlatButton(
            child: new Text('go back', style: new TextStyle(fontSize: 20.0)),
            onPressed: (){
              profile.setRole(null);
              setState(() {
                this._formType=FormType.rol;
              });
            },
          ),
          
        ],
      )
    );
 }
 ListView passangerForm(Profile profile,GlobalKey<FormState> formKey ){
    List <String> destintions=profile.getAvailbelDestination();
   
   return(
      ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 24,),
              DropdownButton<String>(
                  icon: Icon(Icons.edit_location),
                  hint: Text("destination"),
                  items: destintions.map((String item){
                    return DropdownMenuItem<String>(  value: item,
                    child: Text(item),);
                  }).toList(),
                  onChanged: (value){
                    profile.setDestintion(value);
                    print(profile.getDestintion());},
                
                ),
                SizedBox(width: 50,),
                Text("${profile.getDestintion()}"), 
            ],
          ),
          SizedBox(height: 20,),
          Row(
            
            children: <Widget>[
              SizedBox(width: 20,),
               RawMaterialButton(
                 onPressed: (){_selectTime(context,profile); },
                child: Row(
                  children: <Widget>[
                    new Icon(
                  Icons.time_to_leave,
                  color: Colors.black,
                  size: 20.0,),
                  SizedBox(width: 10,),
                  Text("chose time")
                  ],
                ),
                
              ),
              
              SizedBox(width: 60,),
              Text("${profile.getTimeOfTheTrip().hour } : ${profile.getTimeOfTheTrip().minute } "),
            ],
          ),
          SizedBox(height: 20,),
         
           SizedBox(height: 40.0,),       
           Padding(
            //ui stuff
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
            //ui stuff again
            padding: EdgeInsets.all(12),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //function
            child: new Text('submit', style: new TextStyle(fontSize: 20.0,color: Colors.white)),
            onPressed: (){sendData(profile);},
          ))
          ,
          new FlatButton(
            child: new Text('go back', style: new TextStyle(fontSize: 20.0)),
            onPressed: (){
              profile.setRole(null);
              setState(() {
                this._formType=FormType.rol;
              });
            },
          ),
          
        ],
      )
    );
 }
 ListView tripList(Profile profile,GlobalKey<FormState> formKey ){
      return(
      ListView(
        children: <Widget>[
          Text("listView")
          
        ],
      )
    );

 }

}

//UiRoles

class Carpoolor extends StatefulWidget {
 
  final BaseAuth auth;
 Carpoolor({this.auth});
  @override
  _CarpoolorState createState() => _CarpoolorState();
}

class _CarpoolorState extends State<Carpoolor> {
  //this widget will handel the role chosed by the user 
  //caro
  List<Role> _roles = [Role("carpoolor", false),Role("passanger", false)];
  FormType _formType=FormType.rol;
  String role=null;


  
  @override
  Widget build(BuildContext context) {
    final profile=Provider.of<Profile>(context);
    this.role=profile.getRole();
  
    return (Text("${this.role}"));
    
  }
   void sendData(Profile profile) async {
    //here if the info are correct we do stuff
   
      String userId = await widget.auth.currentUser();
      print(userId);
      profile.saveUserToDataBase(userId);
      
      if (profile.getRole()=="passanger"){
        profile.saveTripRequestToDataBase(userId);
      }
      else{

        profile.saveTripToDataBase(userId);
      }
  }
 
 

}
*/