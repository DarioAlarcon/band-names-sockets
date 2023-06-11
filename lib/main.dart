import 'package:band_new_app/pages/home.dart';
import 'package:band_new_app/pages/status.dart';
import 'package:band_new_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService(),)
      ],
      child: MaterialApp(
        //theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: 'home',
        routes: {
          'home': ( _ ) => Homepage(),
          'status': ( _ )=> statusPage()
        },
      ),
    );
  }
}

