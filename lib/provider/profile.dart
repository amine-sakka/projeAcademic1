import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proxym/auth.dart';
import 'package:flutter/src/material/time.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Trip {
  // class trip to describ the trip
  String _destintion;
  int _nbOfSeats;
  String _timeOfTrip;//don
  String _userId;
  String id;
  List <String> listOfPassanger=[];
  Trip(this.id,this._userId,this._destintion,this._timeOfTrip,this._nbOfSeats);

  //getters
  String getDestintion(){return(this._destintion);} ///
  int getNbOfSeats(){return(this._nbOfSeats);}
  String getTimeOfTheTrip(){return(this._timeOfTrip);}
  String getUserHowPostedTheTri(){return(this._userId);}
  String getTripId(){return(this.id);}
  List getListOfPassangers(){return(this.listOfPassanger);}
  //getters

  //seters
  void setDestintion(String dest){this._destintion=dest;}
  void setNbOfSeats(int nbOfSeats){this._nbOfSeats=nbOfSeats;}
  void setTimeOfTheTrip(String time){this._timeOfTrip=time;}
  void setUserId(String userId){this._userId=userId;} 
  void increas(){this._nbOfSeats++;} 
  void decreasSeats(){
    
    if(this._nbOfSeats>1){this._nbOfSeats--;}
   
  }
  void addPassangerToTrip(String passangerID)
  {
    if (! this.getListOfPassangers().contains(passangerID)){
    this.listOfPassanger.add(passangerID);
    this.decreasSeats();
    }
  }
  void setPassangerList(List newPassangers){
    this.listOfPassanger=newPassangers;
  }
  //seters
  
}

class TripRequest {
  String _destintion;
  String _timeOfTrip;//don
  String _userId;
  String id;
  TripRequest(this.id,this._userId,this._destintion,this._timeOfTrip);

  //getters
  String getDestintion(){return(this._destintion);}
  String getTimeOfTheTrip(){return(this._timeOfTrip);}
  String getUserHowPostedTheTri(){return(this._userId);}
  String getTripRequestId(){return(this.id);}
  //getters

  //seters
  void setDestintion(String dest){this._destintion=dest;}
  void setTimeOfTheTrip(String time){this._timeOfTrip=time;}
  void setUserId(String userId){this._userId=userId;} 
  //seters

}


class Profile with ChangeNotifier{

  String _destintion="Ryadh";
  int _nbOfSeats=1;
  TimeOfDay _timeOfTrip=TimeOfDay.now();//done
  String _role=null;//done
  String _userId;
  List <String>_AvailbelDestination=["Ryadh","Sahloul"];
  List <Trip> _tripsAddedByCarpoolor=[];
  List <TripRequest> _tripsRequests=[];
  List <Trip> _allTripsOfTheDay=[];
  
  String getDestintion(){return(this._destintion);}
  int getNbOfSeats(){return(this._nbOfSeats);}
  String getTimeOfTheTrip(){return("${this._timeOfTrip.hour}: ${this._timeOfTrip.minute}");}
  String getRole(){return(this._role);}
  List getAvailbelDestination(){return(this._AvailbelDestination);}
  List getTrips(){return(this._tripsAddedByCarpoolor);}
  String getUderId(){return(this._userId);}
  List getRequests(){return(this._tripsRequests);}
  List getAllTripsOfToday(){return(this._allTripsOfTheDay);}


  void increasSeats(){this._nbOfSeats++;notifyListeners();}
  void decreasSeats(){
    
    if(this._nbOfSeats>1){this._nbOfSeats--;}
    notifyListeners();
  }

  void setDestintion(String dest){this._destintion=dest;notifyListeners();}
  void setNbOfSeats(int nbOfSeats){this._nbOfSeats=nbOfSeats;notifyListeners();}
  void setTimeOfTheTrip(TimeOfDay time){this._timeOfTrip=time;notifyListeners();}
  void setRole(String role){this._role=role;notifyListeners();}
  void setUserId(String userId){this._userId=userId;notifyListeners();}

  void saveUserToDataBase ()
  {
    const fireBaseUsersUrl="https://proxym-e08f4.firebaseio.com/Users.json";
    http.post(fireBaseUsersUrl,body:json.encode({
      "auth" :this._userId,
      "role"  :this._role,
    }));
     notifyListeners();
     print(this._userId);
  }
   void saveTripToDataBase()
  {
    const fireBaseTripUrl="https://proxym-e08f4.firebaseio.com/Trip.json";
    http.post(fireBaseTripUrl,body:json.encode({
      "carpoolor" :this._userId,
      "time" :this.getTimeOfTheTrip(),
      "destination": this._destintion,
      "nbOfAvilebalSeats":this._nbOfSeats,
      "listOfpassanger":[""],
    }));
       
  
    
   
  }
  void saveTripRequestToDataBase()
  {
    const fireBaseTripUrl="https://proxym-e08f4.firebaseio.com/TripRequest.json";
    http.post(fireBaseTripUrl,body:json.encode({
      "passanger" :this._userId,
      "time" :this.getTimeOfTheTrip(),
      "destination": this._destintion,
    }));
   
  }
 
  Future<void> getTripsFromDataBase() async
  {
    const fetchingUrl="https://proxym-e08f4.firebaseio.com/Trip.json";
    List <Trip> listOfTripsFromFire=[]; 
     try{
      var response= await http.get(fetchingUrl);
      //jason trips=response.body;
      var trips=json.decode(response.body);
      
      Map<String, dynamic> data =trips as  Map<String, dynamic>;
      data.forEach((tripID,value){
          if(value["carpoolor"]==this.getUderId())
          {
            //print("match");
          listOfTripsFromFire.add(
            Trip(tripID, value["carpoolor"], value["destination"], value["time"], value["nbOfAvilebalSeats"])
          );
          notifyListeners();
          }
          
          /*print(
            tripID
          );  */
      });
     }catch(e){
       print(e);

     }
     this._tripsAddedByCarpoolor=listOfTripsFromFire;
     notifyListeners();
    
  }
  Future<void> deleteTrip(String tripId) async {
    final url = 'https://proxym-e08f4.firebaseio.com/Trip/$tripId.json';
    final response = await http.delete(url);
    notifyListeners();
  }

  Future<void> updateTrip(Trip trip)
  {
    final url = 'https://proxym-e08f4.firebaseio.com/Trip/${trip.getTripId()}.json';
    http.patch(url,body:json.encode({
      "carpoolor" :trip.getUserHowPostedTheTri(),
      "time" :trip.getTimeOfTheTrip(),
      "destination": trip.getDestintion(),
      "nbOfAvilebalSeats":trip.getNbOfSeats(),
      "listOfpassanger":trip.getListOfPassangers(),
  }));

  }
Future<void> getTripsRequestsFromDataBase() async
  {
    const fetchingUrl="https://proxym-e08f4.firebaseio.com/TripRequest.json";
    List <TripRequest> listOfTripsRequestsFromFire=[]; 
     try{
      var response= await http.get(fetchingUrl);
      //jason trips=response.body;
      var trips=json.decode(response.body);
      
      Map<String, dynamic> data =trips as  Map<String, dynamic>;
      data.forEach((tripID,value){
          if(value["passanger"]==this.getUderId())
          {
            //print("match");
          listOfTripsRequestsFromFire.add(
            TripRequest(tripID, value["passanger"], value["destination"], value["time"])
          );
          notifyListeners();
          }
       
      });
     }catch(e){
       print(e);

     }
     this._tripsRequests=listOfTripsRequestsFromFire;
     notifyListeners();
    
  }

  Future<void> deleteTripRequest(String tripId) async {
    final url = 'https://proxym-e08f4.firebaseio.com/TripRequest/$tripId.json';
    final response = await http.delete(url);
    notifyListeners();
  }


  Future<void> updateTripRequest(TripRequest tripRequest)
  {
    final url = 'https://proxym-e08f4.firebaseio.com/TripRequest/${tripRequest.getTripRequestId()}.json';
    http.patch(url,body:json.encode({
      "passanger" :tripRequest.getUserHowPostedTheTri(),
      "time" :tripRequest.getTimeOfTheTrip(),
      "destination": tripRequest.getDestintion(),
      
  }));
   notifyListeners();
  
  }
  Future<void> getAllTripsFromDataBase() async
  {
    const fetchingUrl="https://proxym-e08f4.firebaseio.com/Trip.json";
    List <Trip> listOfTripsFromFire=[]; 
     try{
      var response= await http.get(fetchingUrl);
      //jason trips=response.body;
      var trips=json.decode(response.body);
      
      Map<String, dynamic> data =trips as  Map<String, dynamic>;
      data.forEach((tripID,value){
          if(value["nbOfAvilebalSeats"]>0){
            listOfTripsFromFire.add(
            Trip(tripID, value["carpoolor"], value["destination"], value["time"], value["nbOfAvilebalSeats"])
          );
          notifyListeners();
          }
          
          
      });
     }catch(e){
       print(e);

     }
     this._allTripsOfTheDay=listOfTripsFromFire;
     notifyListeners();
    
  }

    Future<void> joinATrip(Trip trip,String userID) async
    {
      final theTRipPassangers="https://proxym-e08f4.firebaseio.com/Trip/${trip.getTripId()}/listOfpassanger.json";
      List <String> listPassangers=[];
      try{
      var response= await http.get(theTRipPassangers);
      //jason trips=response.body;
      List passangers=json.decode(response.body);

    
      for (int i=0;i<passangers.length;i++){
        listPassangers.add(passangers[i]);
      }
     //print(listPassangers);

      //print(userID);
     // print(listPassangers.contains(userID));
      if(!listPassangers.contains(userID))
      {
        listPassangers.add(userID);
        trip.setPassangerList(listPassangers);
        trip.decreasSeats();
        this.updateTrip(trip);
        notifyListeners();
      }
    
     }catch(e){
       print(e);

     }
      
    }
    Future<void> cancellJoinATrip(Trip trip,String userID) async
    {
      final theTRipPassangers="https://proxym-e08f4.firebaseio.com/Trip/${trip.getTripId()}/listOfpassanger.json";
      List <String> listPassangers=[];
      try{
      var response= await http.get(theTRipPassangers);
      //jason trips=response.body;
      List passangers=json.decode(response.body);

    
      for (int i=0;i<passangers.length;i++){
        listPassangers.add(passangers[i]);
      }
   
      if(listPassangers.contains(userID))
      {
        listPassangers.remove(userID);
        trip.setPassangerList(listPassangers);
        trip.increas();
        this.updateTrip(trip);
        notifyListeners();
      }
    
     }catch(e){
       print(e);

     }

    }

  

}

