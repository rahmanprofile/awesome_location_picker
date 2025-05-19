# Awesome Location Picker

A powerful and easy-to-use Flutter widget that lets users pick a **Country**, **State**, and **City** with cascading dropdowns.  
Perfect for apps requiring detailed location input with smooth user experience.

---

## Features

- Select from a list of countries with emoji flags
- Automatically load states/provinces when a country is selected
- Automatically load cities when a state is selected
- Supports inline (single row) or stacked (column) dropdown layouts
- Customizable text styles for dropdown items
- Provides callbacks to get selected values at every change
- Loading indicators during data fetch

---

## Installation

Add this package to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  awesome_location_picker: ^1.0.0


import 'package:flutter/material.dart';
import 'package:awesome_location_picker/awesome_location_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Location Picker Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Location Picker Example'),
        ),
        body: const LocationPickerDemo(),
      ),
    );
  }
}

class LocationPickerDemo extends StatefulWidget {
  const LocationPickerDemo({super.key});

  @override
  State<LocationPickerDemo> createState() => _LocationPickerDemoState();
}

class _LocationPickerDemoState extends State<LocationPickerDemo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AwesomeLocationPicker(
        onChanged: (country, state, city) {
          // Callback triggered when user selects or changes a location
          print('Selected Country: ${country?.name}');
          print('Selected State: ${state?.name}');
          print('Selected City: ${city?.name}');
        },
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        showInSingleLine: false, // false = stacked dropdowns, true = inline dropdowns
      ),
    );
  }
}
