import 'package:aiproresume/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'common/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Assign publishable key to flutter_stripe

  Stripe.publishableKey =
      "pk_test_51O3C7yAsKkRyudp24y1BqvnwQo0uRx9ze4Oy5i040ZRE2mtyV05xbe0BtZS24j7nun9XuwllaXlAJNBV8lfc3cWc00VUsPF4mz";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Color _primaryColor = Mycolors().blue!;
  // Color _accentColor = Colors.white!;
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Pro Resume',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // primaryColor: _primaryColor,
        // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
        // scaffoldBackgroundColor: Colors.grey.shade100,
        // primarySwatch: Colors.blueGrey,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white!),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
