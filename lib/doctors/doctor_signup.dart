import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telemedicine/admin/login.dart';
import 'package:telemedicine/main.dart';
import 'package:telemedicine/doctors/doctor_login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class D_SignupPage extends StatefulWidget{
  @override
  _D_SignupPageState createState() => _D_SignupPageState();
}

class _D_SignupPageState extends State<D_SignupPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';

  Future signUp() async{
    if(passwordConfirmed()){
      //create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
      );

      //add details to firestore db
      addDetails();
      Navigator.push(context, MaterialPageRoute(builder: (context) => D_LoginPage()));
    }
  }

  Future addDetails() async{
    await FirebaseFirestore.instance.collection('Doctors').add({
      'firstname': _fnameController.text.trim(),
      'lastname': _lnameController.text.trim(),
      'email': _emailController.text.trim(),
      'age': int.parse(_ageController.text.trim()),
      'speciality': _specialityController.text.trim(),
    });
  }

  bool passwordConfirmed(){
    if(_passwordController.text.trim() == _confirmpasswordController.text.trim()){
      return true;
    }
    else{
      errorMessage = "Passwords don't match";
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return new Scaffold(
      body: Form(
        key: _key,
      child: new SingleChildScrollView(
        child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15, 55, 0, 0),
                  child: Text('REGISTER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35, left: 20, right: 30),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _fnameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _lnameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _specialityController,
                  decoration: InputDecoration(
                    labelText: "Speciality",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _passwordController,
                  validator: validatePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _confirmpasswordController,
                  validator: validatePassword,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10,),
                Container(
                  child: Text(errorMessage),
                ),
                SizedBox(height: 10,),
                
                
                Container(
                  height: 40,
                  child: Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(20),
                    shadowColor: Colors.greenAccent,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async{
                        signUp();
                      },
                      child: const Text("SIGNUP",
                      style: TextStyle(color: Colors.white, fontFamily: "Montserrat", fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => D_LoginPage()));
                      },
                      child: Text("Login",
                      style: TextStyle(
                        fontFamily: 'Monteserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60,),
              ],
            ),
          ),
        ],
      ),
      
      ),
     )
    );
  }
}

String? validateEmail(String? formEmail) {
  if(formEmail == null || formEmail.isEmpty){
    return 'E-mail address is required';
  }  
  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regex = RegExp(pattern);
  if(!regex.hasMatch(formEmail)){
    return 'Invalid Email';
  }

  return null;
}

String? validatePassword(String? formPassword) {
  if(formPassword == null || formPassword.isEmpty){
    return 'Password is required';
  }
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
  RegExp regex = RegExp(pattern);
  if(!regex.hasMatch(formPassword)){
    return '''Password must be atleast 6 characters long, 
    include an uppercase letter and a digit''';
  }

  return null;
}
