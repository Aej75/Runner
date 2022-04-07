import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fyp2/functions/constants.dart';
import 'bottomNavBar.dart';
import 'functions/auth.dart';
import 'home.dart';
import 'main.dart';

class Login extends StatefulWidget {
  Login({required this.auth});

  //
  final BaseAuth auth;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String _email = "";
  String _password = "";

  late FormType _formType = FormType.login;
  final formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  storeNewUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(firebaseUser).set(
        {'firstName': _firstName, 'lastName': _lastName, 'phoneNumber': _phoneNumber})
        .then((value) =>
        print('successfully added $_firstName , $_lastName, $_phoneNumber')).catchError((error) {
      print('$error');
    }
    );
  }

  String? confirmNum(value) {
    if (value.isEmpty) {
      return "Enter your Phone Number!";
    } else if (value.length < 10 || value.length > 10) {
      return "Enter a valid number";
    } else {
      return null;
    }
  }

  String? confirmPass(value) {
    if (value!.isEmpty) {
      return "Cannot be empty";
    } else if (value != _pass.text) {
      return "Password doesn't match";
    }
    return null;
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          await widget.auth.signInWithEmailAndPassword(_email, _password);
          setState(() {
            Navigator.pushNamed(context, '/bottomNav');
            var snackBar = const SnackBar(content: Text('Successfully Login!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          if (kDebugMode) {
            print('Registered');
          }
        } else {
          await widget.auth.createUserWithEmailAndPassword(_email, _password);
          var snackBar =
          const SnackBar(content: Text('Account successfully created!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          storeNewUser();
          setState(() {
            _formType = FormType.login;
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        var snackBar = SnackBar(content: Text('Error $e'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      // on FirebaseAuthException catch (e) {
      //   if (e.code == 'user-not-found') {
      //     var snackBar = const SnackBar(content: Text('No user found for that email.'));
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //
      //   } else if (e.code == 'wrong-password') {
      //     var snackBar = const SnackBar(content: Text('Wrong password provided for that user.'));
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //
      //   }
      // }

      // var snackBar = SnackBar(content: Text('Error $e'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
  }

  void moveToRegister() {
    setState(() {
      formKey.currentState?.reset();
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    setState(() {
      formKey.currentState?.reset();
      _formType = FormType.login;
    });
  }

  String? validatePass(value) {
    // apply this condition if you wat to validate password
    if (value.isEmpty) {
      return "Required";
    } else if (value.length < 6) {
      return "Password cannot be less than 6 digit";
    } else if (value.length > 15) {
      return "Password cannot be more than 15 digit";
    } else {
      return null;
    }
  }

  String? validateName(value) {
    if (value.isEmpty) {
      return "Required";
    } else {
      return null;
    }
  }

  checkIfLoggedIn(){
    if(Home.firstName == "Guest" || FirebaseAuth.instance.currentUser != null){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    checkIfLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(checkIfLoggedIn()){return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: kBodyForegroundColor,
            body: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                alignment: Alignment.center,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildInputs() + buildButtonInputs(),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );}else{return const BottomNavBar();}
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        Image.asset(
          'images/runner.png',
          width: 170.0,
        ),
        const SizedBox(
          height: 20.0,
        ),
        const Text(
          'Welcome to Runner!,',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: kForegroundColor,
              fontSize: 27.0,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 6.0,
        ),
        const Text(
          'Please login to continue with the app',
          style: TextStyle(fontSize: 15.0, color: kForegroundColor),
        ),
        const SizedBox(
          height: 35.0,
        ),
        TextFormField(
            style: const TextStyle(color: kForegroundColor),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // for Email
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: kForegroundColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kForegroundColor),
                ),
                labelText: 'Email Address',
                labelStyle: TextStyle(color: kForegroundColor),
                enabledBorder: OutlineInputBorder()),
            validator: MultiValidator([
              RequiredValidator(errorText: 'The field cannot be Empty!'),
              EmailValidator(errorText: 'Invalid Email'),
            ]),
            onChanged: (value) {
              setState(() {
                _email = value.trim();
              });
            }),
        const SizedBox(
          height: 15.0,
        ),
        Theme(
          data: ThemeData(primaryColor: kForegroundColor),
          child: TextFormField(
            style: const TextStyle(color: kForegroundColor),
            controller: _pass,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //Password
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kForegroundColor),
                ),
                labelText: 'Password',
                fillColor: kForegroundColor,
                labelStyle: TextStyle(color: kForegroundColor)),
            obscureText: true,
            // validator: (value) => value!.isEmpty ? 'Password can\'t be empty': null, //this step is not for realtime validation
            validator: validatePass,
            onChanged: (value) {
              setState(() {
                _password = value.trim();
              });
            },
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ];
    } else {
      return [
        Image.asset(
          'images/runner.png',
          width: 170.0,
        ),
        const SizedBox(
          height: 20.0,
        ),
        const Text(
          'Welcome to Runner!,',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: kForegroundColor,
              fontSize: 27.0,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 6.0,
        ),
        const Text(
          'Please Sign Up to continue with the app',
          style: TextStyle(fontSize: 15.0, color: kForegroundColor),
        ),
        const SizedBox(
          height: 35.0,
        ),
        TextFormField(
            style: const TextStyle(color: kForegroundColor),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // for Email
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: kForegroundColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kForegroundColor),
                ),
                labelText: 'First Name',
                labelStyle: TextStyle(color: kForegroundColor),
                enabledBorder: OutlineInputBorder()),
            validator: validateName,
            onChanged: (value) {
              setState(() {
                _firstName = value;
              });
            }),
        const SizedBox(
          height: 15.0,
        ),
        TextFormField(
            style: const TextStyle(color: kForegroundColor),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // for Email
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: kForegroundColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kForegroundColor),
                ),
                labelText: 'Last Name',
                labelStyle: TextStyle(color: kForegroundColor),
                enabledBorder: OutlineInputBorder()),
            validator: validateName,
            onChanged: (value) {
              setState(() {
                _lastName = value;
              });
            }),
        const SizedBox(
          height: 15.0,
        ),
        TextFormField(
            style: const TextStyle(color: kForegroundColor),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // for Email
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: kForegroundColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kForegroundColor),
                ),
                labelText: 'Email Address',
                labelStyle: TextStyle(color: kForegroundColor),
                enabledBorder: OutlineInputBorder()),
            validator: MultiValidator([
              RequiredValidator(errorText: 'The field cannot be Empty!'),
              EmailValidator(errorText: 'Invalid Email'),
            ]),
            onChanged: (value) {
              setState(() {
                _email = value.trim();
              });
            }),
        const SizedBox(
          height: 15.0,
        ),
        Theme(
          data: ThemeData(primaryColor: kForegroundColor),
          child: TextFormField(
            style: const TextStyle(color: kForegroundColor),
            controller: _pass,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //Password
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kForegroundColor),
                ),
                labelText: 'Password',
                fillColor: kForegroundColor,
                labelStyle: TextStyle(color: kForegroundColor)),
            obscureText: true,
            // validator: (value) => value!.isEmpty ? 'Password can\'t be empty': null, //this step is not for realtime validation
            validator: validatePass,
            onChanged: (value) {
              setState(() {
                _password = value.trim();
              });
            },
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        TextFormField(
          style: const TextStyle(color: kForegroundColor),
          controller: _confirmPass,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          //Password

          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              labelText: 'Confirm Password',
              labelStyle: TextStyle(color: kForegroundColor)),
          obscureText: true,
          // validator: (value) => value!.isEmpty ? 'Password can\'t be empty': null, //this step is not for realtime validation
          validator: confirmPass,
        ),
        const SizedBox(
          height: 15.0,
        ),
        TextFormField(
          style: const TextStyle(color: kForegroundColor),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          //Password

          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              labelText: 'Phone Number',
              labelStyle: TextStyle(color: kForegroundColor)),
          obscureText: false,
          // validator: (value) => value!.isEmpty ? 'Password can\'t be empty': null, //this step is not for realtime validation
          validator: confirmNum,
          onChanged: (value) {
            setState(() {
              _phoneNumber = value;
            });
          },
        ),
        const SizedBox(
          height: 15.0,
        ),
      ];
    }
  }

  List<Widget> buildButtonInputs() {
    if (_formType == FormType.login) {
      return [
        SizedBox(
          width: double.infinity,
          height: 45.0,
          child: ElevatedButton(
            onPressed: validateAndSubmit,
            style: ElevatedButton.styleFrom(
                primary: kBackgroundColor,
                elevation: 0.0,
                shadowColor: Colors.transparent),
            child: const Center(
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          width: double.infinity,
          height: 45.0,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/bottomNav');
              });
            },
            style: ElevatedButton.styleFrom(
                primary: kBackgroundColor,
                elevation: 0.0,
                shadowColor: Colors.transparent),
            child: const Center(
              child: Text(
                'Login in as a Guest',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No account yet?',
                style: TextStyle(color: kForegroundColor),
              ),
              GestureDetector(
                  onTap: moveToRegister,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: kForegroundColor, fontWeight: FontWeight.w700),
                    ),
                  ))
            ],
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.black,
          ),
          onPressed: () {}, //left work !!!!!!!!!!!
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: kForegroundColor),
          ),
        ),
      ];
    } else {
      return [
        SizedBox(
          width: double.infinity,
          height: 45.0,
          child: ElevatedButton(
            onPressed: validateAndSubmit,
            style: ElevatedButton.styleFrom(primary: Colors.black),
            child: const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already has an account?'),
              GestureDetector(
                  onTap: moveToLogin,
                  child: const Text(
                    'login',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ))
            ],
          ),
        ),
      ];
    }
  }
}
