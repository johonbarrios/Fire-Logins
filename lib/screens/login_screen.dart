import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //const LoginScreen({ Key? key }) : super(key: key);
  TextEditingController correoController = TextEditingController();
  TextEditingController claveController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(fontSize: 26.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: correoController,
            decoration: InputDecoration(
                labelText: "correo",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                )),
          ),
          SizedBox(
            height: 12.0,
          ),
          TextField(
            obscureText: true,
            controller: claveController,
            decoration: InputDecoration(
                labelText: "Clave",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                )),
          ),
          SizedBox(
            height: 18.0,
          ),
          loading
              ? CircularProgressIndicator()
              : Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        if (correoController.text == "" ||
                            claveController == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Se reguieren datos!"),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          User? result = await AuthService().Login(
                              correoController.text,
                              claveController.text,
                              context);
                          if (result != null) {
                            print("Succes");
                            //print(result.email);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(result)),
                                (route) => false);
                          }
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Text(
                        'Accessar',
                        style: TextStyle(fontSize: 22.0),
                      )),
                ),
        ]),
      ),
    );
  }
}
