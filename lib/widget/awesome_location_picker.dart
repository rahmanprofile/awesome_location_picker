import 'package:flutter/material.dart';
import '../model/awesome_city.dart';
import '../model/awesome_country.dart';
import '../model/awesome_state.dart';
import '../service/request_provider.dart';

/// AwesomeLocationPicker is a comprehensive Flutter widget that provides users
/// with an intuitive interface to select their location by choosing a country,
/// then a state within that country, and finally a city within the selected state.
///
/// This widget supports two layout modes:
/// - Single line: displays all three dropdowns horizontally in a row.
/// - Multi line (default): displays dropdowns vertically, stacked with spacing.
///
/// The widget exposes an `onChanged` callback to notify the parent widget whenever
/// any of the selected location parts changes, providing the selected country, state,
/// and city respectively.
///
/// The `textStyle` property allows customization of dropdown text appearance.
///
/// Internally, the widget fetches location data asynchronously using
/// the `RequestProvider` service, maintaining loading states and resetting
/// dependent dropdowns appropriately when selections change.
class AwesomeLocationPicker extends StatefulWidget {
  /// Callback that gets triggered whenever the selection changes.
  /// It provides the currently selected country, state, and city as parameters.
  final Function(Country, States, Cities) onChanged;

  /// Optional styling to be applied on all dropdown text items.
  final TextStyle? textStyle;

  /// You can change outline border color default is Black54.
  final Color? borderColor;

  /// Controls whether the dropdowns appear in a single horizontal line or stacked vertically.
  /// Defaults to false, meaning dropdowns are stacked vertically.
  final bool showInSingleLine;

  /// Creates an instance of AwesomeLocationPicker.
  ///
  /// [onChanged] allows the parent widget to receive updates on user selections.
  /// [textStyle] customizes text appearance.
  /// [showInSingleLine] toggles between horizontal and vertical layouts.
  const AwesomeLocationPicker({
    super.key,
    required this.onChanged,
    required this.borderColor,
    this.textStyle,
    this.showInSingleLine = false,
  });

  @override
  State<AwesomeLocationPicker> createState() => _AwesomeLocationPickerState();
}

class _AwesomeLocationPickerState extends State<AwesomeLocationPicker> {
  /// List holding fetched countries, initially empty.
  List<Country> countries = [];

  /// List holding fetched states for selected country, initially empty.
  List<States> states = [];

  /// List holding fetched cities for selected state, initially empty.
  List<Cities> cities = [];

  /// Currently selected country, null if none selected yet.
  Country? selectedCountry;

  /// Currently selected state, null if none selected yet.
  States? selectedState;

  /// Currently selected city, null if none selected yet.
  Cities? selectedCity;

  /// Loading flag indicating whether data is currently being fetched.
  /// When true, shows a progress indicator instead of dropdowns.
  bool isLoading = false;

  _AwesomeLocationPickerState();

  /// Called when this widget is inserted into the widget tree.
  /// Immediately triggers the initial loading of countries data.
  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  /// Asynchronously fetches the list of countries from the backend API.
  ///
  /// Sets loading state to true before the fetch and resets after completion.
  /// The fetched countries list is stored in `countries`.
  Future<void> fetchCountries() async {
    setState(() => isLoading = true);
    countries = await RequestProvider.instance.fetchCountries();
    setState(() => isLoading = false);
  }

  /// Fetches the list of states for the given [countryId].
  ///
  /// Resets the currently selected state and city, and their respective lists,
  /// as the country has changed and dependent data must be updated.
  /// Also sets and unsets the loading state flag accordingly.
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

  /// Fetches the list of cities for the given [stateId].
  ///
  /// Resets the currently selected city and the cities list,
  /// since the state has changed and city options must update.
  /// Manages loading state accordingly.
  Future<void> fetchCities(int stateId) async {
    setState(() {
      isLoading = true;
      cities = [];
      selectedCity = null;
    });
    cities = await RequestProvider.instance.fetchCities(stateId);
    setState(() => isLoading = false);
  }

  /// Helper method to build a generic dropdown form field.
  ///
  /// Parameters:
  /// - [hint]: Label to display above the dropdown.
  /// - [value]: The currently selected value.
  /// - [items]: List of selectable items.
  /// - [onChanged]: Callback invoked when the user selects an item.
  /// - [labelBuilder]: Function to convert an item of type T to a display string.
  ///
  /// This method returns a [DropdownButtonFormField] widget with consistent
  /// styling, expansion behavior, and change handling.
  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) labelBuilder,
  }) {
    // Defensive check: if current value is not in items, reset to null to avoid error
    final safeValue =
        (value != null && items.contains(value)) ? value : null as T?;

    return DropdownButtonFormField<T>(
      value: safeValue,
      key: ValueKey(items), // or ValueKey(items.length) or some stable key|
      decoration: InputDecoration(
        labelText: hint,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor ?? Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: widget.borderColor ?? Colors.black54, width: 2),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor ?? Colors.black54),
        ),
      ),

      style: widget.textStyle,
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(labelBuilder(e),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: (val) {
        onChanged(val);
        widget.onChanged.call(selectedCountry!, selectedState!, selectedCity!);
      },
    );
  }

  /// Builds the widget tree to render the location picker UI.
  ///
  /// Shows a loading spinner while fetching data.
  /// Once loaded, displays either a horizontal row of dropdowns or
  /// vertical column based on [showInSingleLine].
  ///
  /// Dropdowns are linked so that changing the country resets states and cities,
  /// and changing the state resets cities.
  @override
  Widget build(BuildContext context) {
    if (widget.showInSingleLine) {
      // Horizontal layout with dropdowns side by side with spacing.
      return Row(
        children: [
          Expanded(
            child: _buildDropdown<Country>(
              hint: 'Country',
              value: selectedCountry,
              items: countries,
              labelBuilder: (c) => c.name,
              onChanged: (val) {
                selectedCountry = val;
                if (val != null) fetchStates(val.id);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDropdown<States>(
              hint: 'State',
              value: selectedState,
              items: states,
              labelBuilder: (s) => s.name,
              onChanged: (val) {
                selectedState = val;
                if (val != null) fetchCities(val.id);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDropdown<Cities>(
              hint: 'City',
              value: selectedCity,
              items: cities,
              labelBuilder: (c) => c.name,
              onChanged: (val) => selectedCity = val,
            ),
          ),
        ],
      );
    } else {
      // Vertical layout with dropdowns stacked with spacing.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          _buildDropdown<Country>(
            hint: 'Select Country',
            value: selectedCountry,
            items: countries,
            labelBuilder: (c) => c.name,
            onChanged: (val) {
              selectedCountry = val;
              if (val != null) fetchStates(val.id);
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown<States>(
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
          _buildDropdown<Cities>(
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
}
