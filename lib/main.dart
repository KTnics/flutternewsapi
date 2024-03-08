import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Favoritesprovider.dart';
import 'RegisterPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:
  FirebaseOptions(apiKey: "AIzaSyBdjdih5W696IOJIQyMEhpzvWCAvdfzOLQ",
      appId: "1:901543636420:web:4767e70b7c275985030891",
      messagingSenderId: "901543636420",
      projectId:"project2-e8088",
  )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override


  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SavedArticlesProvider()),
        // Add other providers if needed
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(


          primarySwatch: Colors.blue,
        ),
          debugShowCheckedModeBanner: false,
        home: RegisterPage(),
      ),
    );
  }
}
