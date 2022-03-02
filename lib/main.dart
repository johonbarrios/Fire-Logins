import 'package:fire_logins/screens/home_screen.dart';
import 'package:fire_logins/screens/register_screen.dart';
import 'package:fire_logins/screens/subir_foto.dart';
import 'package:fire_logins/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

/*void main() {
  runApp(const MyApp());
}*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Autenticaciones',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            //primarySwatch: Colors.blue,
            brightness: Brightness.dark),
        home: StreamBuilder(
            stream: AuthService().firebaseAuth.authStateChanges(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                //return HomeScreen(snapshot.data);
                return SubirFoto();
              }
              return RegisterScreen();
            }));
  }
}
