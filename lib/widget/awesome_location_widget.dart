import 'package:flutter/material.dart';
import '../model/awesome_city.dart';
import '../model/awesome_country.dart';
import '../model/awesome_state.dart';
import '../service/request_provider.dart';

class AwesomeLocationPicker extends StatefulWidget {
  final Function(AwesomeCountry?, AwesomeState?, AwesomeCity?)? onChanged;
  final TextStyle? textStyle;
  final bool showInSingleLine;

  const AwesomeLocationPicker({
    super.key,
    this.onChanged,
    this.textStyle,
    this.showInSingleLine = false,
  });

  @override
  State<AwesomeLocationPicker> createState() => _AwesomeLocationPickerState();
}

class _AwesomeLocationPickerState extends State<AwesomeLocationPicker> {
  List<AwesomeCountry> countries = [];
  List<AwesomeState> states = [];
  List<AwesomeCity> cities = [];

  AwesomeCountry? selectedCountry;
  AwesomeState? selectedState;
  AwesomeCity? selectedCity;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    setState(() => isLoading = true);
    countries = await RequestProvider.instance.fetchCountries();
    setState(() => isLoading = false);
  }

  Future<void> fetchStates(int countryId) async {
    setState(() {
      isLoading = true;
      states = [];
      cities = [];
      selectedState = null;
      selectedCity = null;
    });
    states = await RequestProvider.instance.fetchStates(countryId);
    setState(() => isLoading = false);
  }

  Future<void> fetchCities(int stateId) async {
    setState(() {
      isLoading = true;
      cities = [];
      selectedCity = null;
    });
    cities = await RequestProvider.instance.fetchCities(stateId);
    setState(() => isLoading = false);
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) labelBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      style: widget.textStyle,
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(labelBuilder(e), maxLines: 1, overflow: TextOverflow.ellipsis),
      ))
          .toList(),
      onChanged: (val) {
        onChanged(val);
        widget.onChanged?.call(selectedCountry, selectedState, selectedCity);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : widget.showInSingleLine
        ? Row(
      children: [
        Expanded(child: _buildDropdown<AwesomeCountry>(
          hint: 'Country',
          value: selectedCountry,
          items: countries,
          labelBuilder: (c) => "${c.emoji} ${c.name}",
          onChanged: (val) {
            selectedCountry = val;
            if (val != null) fetchStates(val.id);
          },
        )),
        const SizedBox(width: 8),
        Expanded(child: _buildDropdown<AwesomeState>(
          hint: 'State',
          value: selectedState,
          items: states,
          labelBuilder: (s) => s.name,
          onChanged: (val) {
            selectedState = val;
            if (val != null) fetchCities(val.id);
          },
        )),
        const SizedBox(width: 8),
        Expanded(child: _buildDropdown<AwesomeCity>(
          hint: 'City',
          value: selectedCity,
          items: cities,
          labelBuilder: (c) => c.name,
          onChanged: (val) => selectedCity = val,
        )),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDropdown<AwesomeCountry>(
          hint: 'Select Country',
          value: selectedCountry,
          items: countries,
          labelBuilder: (c) => "${c.emoji} ${c.name}",
          onChanged: (val) {
            selectedCountry = val;
            if (val != null) fetchStates(val.id);
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown<AwesomeState>(
          hint: 'Select State',
          value: selectedState,
          items: states,
          labelBuilder: (s) => s.name,
          onChanged: (val) {
            selectedState = val;
            if (val != null) fetchCities(val.id);
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown<AwesomeCity>(
          hint: 'Select City',
          value: selectedCity,
          items: cities,
          labelBuilder: (c) => c.name,
          onChanged: (val) => selectedCity = val,
        ),
      ],
    );
  }
}
