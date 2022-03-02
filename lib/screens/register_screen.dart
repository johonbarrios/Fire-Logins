import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_logins/services/auth_service.dart';
import 'package:fire_logins/screens/home_screen.dart';
import 'package:fire_logins/screens/login_screen.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //const RegisterScreen({ Key? key }) : super(key: key);
  TextEditingController correoController = TextEditingController();
  TextEditingController claveController = TextEditingController();
  TextEditingController confclaveController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrarse',
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
            height: 12.0,
          ),
          TextField(
            obscureText: true,
            controller: confclaveController,
            decoration: InputDecoration(
                labelText: "Confirmar la clave",
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
                      //
                      setState(() {
                        loading = true;
                      });

                      if (correoController.text == "" ||
                          claveController == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Se reguieren datos!"),
                          backgroundColor: Colors.red,
                        ));
                      } else if (claveController.text !=
                          confclaveController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("La clave debe ser igual!"),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        User? result = await AuthService().register(
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
                      'Registrar',
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                ),
          SizedBox(height: 18.0),
          TextButton(
              onPressed: () {
                /*Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);*/
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Si ya estar registrado! LOGÍN')),
          SizedBox(height: 20.0),
          Divider(),
          SizedBox(height: 20.0),
          loading
              ? CircularProgressIndicator()
              : SignInButton(Buttons.Google, text: 'Continuar con Google',
                  onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await AuthService().signInWithGoogle();
                  setState(() {
                    loading = false;
                  });
                })
        ]),
      ),
    );
  }
} //
