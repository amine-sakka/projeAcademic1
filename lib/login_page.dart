import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:provider/provider.dart';
import 'provider/profile.dart';
class LoginPage extends StatefulWidget {
  //intit fil java 
  LoginPage({this.auth, this.onSignedIn});
  //vars 
  final BaseAuth auth;//auth status mte3 the user
  final VoidCallback onSignedIn;//callbac so we can talk with root.dart wrapper
  //dart stuff
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType {
  //enum agin it s like variable that takes 1 if the user is register
  //0 if he s trying to login 
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  // this shit is usfuell form key allow you to maniplate the info ili jayin mil form
  final formKey = new GlobalKey<FormState>(); //form stuff 
  //variables 
  String _email;
  String _password;
  //bich mn93odch n3ml fi page login w page sign up we use state
  FormType _formType = FormType.login;//this shit takes login or register so we know what to render for the
  //user

  bool validateAndSave() {
    //usfuel validation in flutter + best practise stuff
    //we define variable tha tkae the form current state
    //we can skip this but best practise stuff 
    //practise s7i7a ? how to write practise ?
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(Profile profile) async {
    //here if the info are correct we do stuff
    if (validateAndSave()) {
      try { 
        if (_formType == FormType.login) {
          //if the shity user is trying to login 
          //try it
          String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
          profile.setUserId(userId);
          print('Signed in: ${profile.getUderId()}');
        } else {
          //if the shity user is trying to register 
          //try it
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          profile.setUserId(userId);
          print('Registered user: ${profile.getUderId()}');
        }
        widget.onSignedIn();
        //ya root row ili user d5ael 
        //telling the root component widget that the user is inn so the root can updtae its state to 
        //fama user
      }
      catch (e) {
        //errer stuff
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    //if the user cliked the button register update the state to registering 
    formKey.currentState.reset();//resting the form to empty
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    //if the user cliked the button login update the state to login
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
    Widget build(BuildContext context) {
      final profile=Provider.of<Profile>(context);
      //design stuff goes here
      return new Scaffold(
        /*appBar: new AppBar(
          title: new Text('login'),
        ),*/
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: formKey,
            child:ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              left: 24.0,right: 24.0,
            ),
            children: logo() +buildInputs(profile) +buildSubmitButtons(profile),
          ), 
          ),
          /*child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              left: 24.0,right: 24.0,
            ),
            children: buildInputs() +buildSubmitButtons(),
          ),*/
        )

        /*new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            ),
          )
        )*/
      );
    }
      List <Widget> logo (){
      return([Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/images/logos/logo.png'),
      ),
    )]);
    }
    List<Widget> buildInputs(Profile profile) {
      //input fileds depends on the state of the login page
      //if login something 
      //if registr something else
      return [
        SizedBox(height: 40.0,),
        new TextFormField(
          //zina stuff ui stuff i mean 
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          //validation and saving stuff
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(height: 10.0,),
        new TextFormField(
          //zina stuff ui stuff i mean 
           keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            labelText: 'password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          obscureText: true,
          //validation and saving info stuff
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    }

    List<Widget> buildSubmitButtons(Profile profile) {
      //buutons kif kif depends on the state of the dame widget
      if (_formType == FormType.login) {
        return [
          Padding(
            //ui stuff
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
            //ui stuff again
            padding: EdgeInsets.all(12),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //function
            child: new Text('Login', style: new TextStyle(fontSize: 20.0,color: Colors.white)),
            onPressed:()=>{ validateAndSubmit(profile)},
          ))
          ,
          new FlatButton(
            child: new Text('Create an account', style: new TextStyle(fontSize: 20.0)),
            onPressed: moveToRegister,
          ),
        ];
      } else {
        return [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child:RaisedButton(
              //ui stuff again
            padding: EdgeInsets.all(12),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //function
            child: new Text('Create an account', style: new TextStyle(fontSize: 20.0,color: Colors.white),),
            onPressed: ()=>{ validateAndSubmit(profile)},
          ),),
          
          new FlatButton(
            child: new Text('Have an account? Login', style: new TextStyle(fontSize: 20.0)),
            onPressed: moveToLogin,
          ),
        ];
      }
    }
}