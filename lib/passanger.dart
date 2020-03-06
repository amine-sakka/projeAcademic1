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



class Passanger extends StatefulWidget {
  @override
  _PassangerState createState() => _PassangerState();
}

class _PassangerState extends State<Passanger> {
  bodyType bodyStuff =bodyType.listOfRequests;
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
        title: Text("Passanger"),
        backgroundColor: Colors.lightGreen,
      ),
      body: PassangerBody(profile),
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
  Widget PassangerBody(Profile profile)
  {
    switch (this.bodyStuff) {
      case bodyType.listOfRequests:
        return(requests(profile));
      case bodyType.add:
        return(addTripRequest(profile));
      default:
        return(trips(profile));
    }
  }
  ListView addTripRequest(Profile profile)
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
            child: new Text('creat a request', style: new TextStyle(fontSize: 20.0,color: Colors.white)),
            onPressed: (){
              profile.saveTripRequestToDataBase();
              setState(() {
                this.bodyStuff=bodyType.listOfRequests;
              });
              },
          
          
          ))
          ,
          
          
        ],
      )
    );
 }
  Widget trips(Profile profile)
  {
   List trips=profile.getAllTripsOfToday();
   profile.getAllTripsFromDataBase();
   ListView listOfTrips =ListView.builder(
      itemCount: trips.length,
      itemBuilder: (BuildContext context, int index) {
        //String key = values.keys.elementAt(index);
        return (_buildTrip(trips[index],profile));
      },);
  
    return(
       listOfTrips
    );
  }
  Widget requests(Profile profile)
  {
   
   List tripsReq=profile.getRequests();
   profile.getTripsRequestsFromDataBase();
   ListView listOfTripsReq =ListView.builder(
      itemCount: tripsReq.length,
      itemBuilder: (BuildContext context, int index) {
        //String key = values.keys.elementAt(index);
        return (_buildTripRequests(tripsReq[index],profile));
      },);
  
    return(
      listOfTripsReq
    );
  }

  Widget _buildTripRequests(TripRequest tripRequest,Profile profile) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
          onTap: () {
           Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsPage(tripRequest: tripRequest,)
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
                          tripRequest.getDestintion(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          tripRequest.getTimeOfTheTrip(),
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
                      builder: (context) => DetailsPage(tripRequest: tripRequest,)
                    ));
                }
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.black,
                onPressed: () {
                  profile.deleteTripRequest(tripRequest.getTripRequestId())
                  ;}
              )
            ],
          )
        ));
  }
  
   Widget _buildTrip(Trip trip,Profile profile) {
    Color color=Colors.white10;
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Container(
          color: color,
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
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () {profile.joinATrip(trip,profile.getUderId().toString());color=Colors.lightBlueAccent;}
              ),
              IconButton(
                icon: Icon(Icons.cancel),
                color: Colors.black,
                onPressed: () {profile.cancellJoinATrip(trip,profile.getUderId().toString());}
              )
            ],
          )
        ));
  }
 
}


class DetailsPage extends StatefulWidget {
  TripRequest tripRequest;
  DetailsPage({this.tripRequest});
  @override
  _DetailsPageState createState() => _DetailsPageState(this.tripRequest);
}

class _DetailsPageState extends State<DetailsPage> {

  @override
  
  TimeOfDay _time= TimeOfDay.now();
 // int nbOfSeats= widget.trip.getNbOfSeats();
  TripRequest tripRequest ;
  _DetailsPageState(this.tripRequest);
  Future<void> _selectTime(BuildContext context,Profile profile) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time)
      {
        print(picked);
        if(picked.toString()!=widget.tripRequest.getTimeOfTheTrip()){

          setState(() {
             this.tripRequest.setTimeOfTheTrip(picked.hour.toString()+":"+picked.minute.toString());
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
        body:editTrip(profile,widget.tripRequest) ,
        
    )
    ;
  }
  ListView editTrip(Profile profile,TripRequest tripRequest)
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
                  value: tripRequest.getDestintion(),
                  items: destintions.map((String item){
                    return DropdownMenuItem<String>(  value: item,
                    child: Text(item),);
                  }).toList(),
                  onChanged: (value){
                   // profile.setDestintion(value);
                    //print(profile.getDestintion());
                    tripRequest.setDestintion(value);
                    },
                
                ),
                SizedBox(width: 50,),
                Text("${this.tripRequest.getDestintion()}"), 
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
              Text("${tripRequest.getTimeOfTheTrip() } "),
            ],
          ),
          SizedBox(height: 30,),
          
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
                profile.updateTripRequest(this.tripRequest);
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