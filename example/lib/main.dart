import 'package:awesome_location_picker/awesome_location_picker.dart';
import 'package:awesome_location_picker/widget/awesome_location_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
    );
  }
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: AwesomeLocationPicker(
        onChanged: (country, state, city) {
          print("Selected: ${country?.name}, ${state?.name}, ${city?.name}");
        },
        showInSingleLine: true,
      ),
    );
  }
}
