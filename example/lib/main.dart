import 'package:awesome_location_picker/awesome_location_picker.dart';
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
      title: 'Awesome Location Picker Demo',
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
      appBar: AppBar(title: Text("Awesome Location Picker")),
      body: AwesomeLocationPicker(
        onChanged: (country, state, city) {
          debugPrint(
            'Selected fields are :- ${country.name}, ${state.name}, ${city.name}',
          );
        },
        borderColor: Colors.black54,
      ),
    );
  }
}
