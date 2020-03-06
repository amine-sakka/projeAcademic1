import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:provider/provider.dart';
import 'provider/profile.dart';
import 'package:flutter/services.dart';

enum bodyType {
  //enum agin it s like variable that takes 1 if the user is register
  //0 if he s trying to login 
  listOfRequests,
  listOfTrips,
  add,
}



class Carpoolor extends StatefulWidget {
  @override
  _CarpoolorState createState() => _CarpoolorState();
}

class _CarpoolorState extends State<Carpoolor> {
  bodyType bodyStuff =bodyType.listOfTrips;
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
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("carpolor"),
        backgroundColor: Colors.lightGreen,
      ),
      body: carpoolorBody(profile),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          setState(() {
                            this.bodyStuff=bodyType.add;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
         
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
          children: <Widget>[
            
            IconButton(icon: Icon(Icons.receipt),onPressed: ()=>{
            setState(() {
                            this.bodyStuff=bodyType.listOfRequests;
                          })
            },iconSize: 30,color: Colors.white,),
            SizedBox(width: 20,),
            IconButton(icon: Icon(Icons.local_library),onPressed: ()=>{
               setState(() {
                            this.bodyStuff=bodyType.listOfTrips;
                          })
            },iconSize: 30,color: Colors.white),
          ],
        ),
        shape: CircularNotchedRectangle(),
        color: Colors.lightGreen,
  ),
);
  }
  Widget carpoolorBody(Profile profile)
  {
    switch (this.bodyStuff) {
      case bodyType.listOfRequests:
        return(requests(profile));
      case bodyType.add:
        return(addTrip(profile));
      default:
        return(trips(profile));
    }
  }
  ListView addTrip(Profile profile)
  {
    List <String> destintions=profile.getAvailbelDestination();
  
   return(
      ListView(
        children: <Widget>[
          SizedBox(height:60,),
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
          SizedBox(height: 30,),
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
              Text("${profile.getTimeOfTheTrip() } "),
            ],
          ),
          SizedBox(height: 30,),
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
           SizedBox(height: 100.0,),       
           Padding(
            //ui stuff
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
            //ui stuff again
            padding: EdgeInsets.all(12),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //function
            child: new Text('creat a trip', style: new TextStyle(fontSize: 20.0,color: Colors.white)),
            onPressed: (){
              profile.saveTripToDataBase();
              setState(() {
                this.bodyStuff=bodyType.listOfTrips;
              });
              },
          
          
          ))
          ,
          
          
        ],
      )
    );
 }
  ListView requests(Profile profile)
  {
    List <String> destintions=profile.getAvailbelDestination();
  
   return(
      ListView(
        children: <Widget>[
          
        ],
      )
    );
  }
  Widget trips(Profile profile)
  {
   
   List trips=profile.getTrips();
   profile.getTripsFromDataBase();
   ListView listOfTrips =ListView.builder(
      itemCount: trips.length,
      itemBuilder: (BuildContext context, int index) {
        //String key = values.keys.elementAt(index);
        return (_buildTrip(trips[index],profile));
      },);
  
    return(
       listOfTrips
       //Text("${trips.length}")
    );
  }

  Widget _buildTrip(Trip trip,Profile profile) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
          onTap: () {
             Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsPage(trip: trip,)
                    ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
      
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          trip.getDestintion(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          trip.getTimeOfTheTrip() +" seats : "+trip.getNbOfSeats().toString(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey
                          )
                        )
                      ]
                    )
                  ]
                )
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsPage(trip: trip,)
                    ));
                }
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.black,
                onPressed: () {profile.deleteTrip(trip.getTripId());}
              )
            ],
          )
        ));
  }
 
}


class DetailsPage extends StatefulWidget {
  Trip trip;
  DetailsPage({this.trip});
  @override
  _DetailsPageState createState() => _DetailsPageState(this.trip);
}

class _DetailsPageState extends State<DetailsPage> {

  @override
  
  TimeOfDay _time= TimeOfDay.now();
 // int nbOfSeats= widget.trip.getNbOfSeats();
  Trip trip ;
  _DetailsPageState(this.trip);
  Future<void> _selectTime(BuildContext context,Profile profile) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time)
      {
        print(picked);
        if(picked.toString()!=widget.trip.getTimeOfTheTrip()){

          setState(() {
             this.trip.setTimeOfTheTrip(picked.hour.toString()+":"+picked.minute.toString());
          });
         
        }
        

      }
  }
  Widget build(BuildContext context) {
    final profile=Provider.of<Profile>(context);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
        appBar: AppBar(
           backgroundColor: Colors.lightGreen,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
         
          elevation: 0.0,
          title: Text('Details',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: Colors.white)),
          centerTitle: true,
         
        ),
        body:editTrip(profile,widget.trip) ,
        
    )
    ;
  }
  ListView editTrip(Profile profile,Trip trip)
  {
    List <String> destintions=profile.getAvailbelDestination();
  
   return(
      ListView(
        children: <Widget>[
          SizedBox(height:60,),
          Row(
            children: <Widget>[
              SizedBox(width: 24,),
              DropdownButton<String>(
                  icon: Icon(Icons.edit_location),
                  hint: Text("destination"),
                  value: trip.getDestintion(),
                  items: destintions.map((String item){
                    return DropdownMenuItem<String>(  value: item,
                    child: Text(item),);
                  }).toList(),
                  onChanged: (value){
                   // profile.setDestintion(value);
                    //print(profile.getDestintion());
                    trip.setDestintion(value);
                    },
                
                ),
                SizedBox(width: 50,),
                Text("${this.trip.getDestintion()}"), 
            ],
          ),
          SizedBox(height: 30,),
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
              Text("${trip.getTimeOfTheTrip() } "),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Icon(Icons.event_seat),
              SizedBox(width: 20,),
              Text("${widget.trip.getNbOfSeats()}"),
              SizedBox(width: 40,),
              RawMaterialButton(
                onPressed: () { setState(() {
                  this.trip.increas();
                }); },
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
                onPressed: () {
                  setState(() {
                     this.trip.decreasSeats();
                  });
                  ;},
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
           SizedBox(height: 100.0,),       
           Padding(
            //ui stuff
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
            //ui stuff again
            padding: EdgeInsets.all(12),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //function
            child: new Text('update trip', style: new TextStyle(fontSize: 20.0,color: Colors.white)),
            onPressed: (){
             // profile.saveTripToDataBase();
              setState(() {
                profile.updateTrip(this.trip);
                Navigator.of(context).pop();
              });
              },
          )),
          new FlatButton(
            child: new Text('cancel', style: new TextStyle(fontSize: 20.0)),
            onPressed:(){Navigator.of(context).pop();} ,
          ),
        ],
      )
    );
 }
}