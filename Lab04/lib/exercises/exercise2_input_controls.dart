import 'package:flutter/material.dart';

/// Exercise 2 – Input Widgets: Slider, Switch, RadioListTile, DatePicker
/// Goal: Build interactive UI that lets users control values.
class Exercise2Screen extends StatefulWidget {
  const Exercise2Screen({super.key});

  @override
  State<Exercise2Screen> createState() => _Exercise2ScreenState();
}

class _Exercise2ScreenState extends State<Exercise2Screen> {
  // State variables for input widgets
  double _sliderValue = 50.0;
  bool _switchValue = true;
  String _selectedRadio = 'Option A';
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2: Input Controls'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Input Widgets',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 1. Slider
            Text('Slider Value: ${_sliderValue.toStringAsFixed(1)}'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 10,
              label: _sliderValue.round().toString(),
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            const Divider(),

            // 2. Switch
            SwitchListTile(
              title: const Text('Enable Notifications / Feature'),
              subtitle: Text(_switchValue ? 'Active' : 'Inactive'),
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
            const Divider(),

            // 3. RadioListTile group
            const Text('Select Category:', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Option A (Action)'),
              value: 'Option A',
              groupValue: _selectedRadio,
              onChanged: (value) {
                setState(() {
                  _selectedRadio = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Option B (Drama)'),
              value: 'Option B',
              groupValue: _selectedRadio,
              onChanged: (value) {
                setState(() {
                  _selectedRadio = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Option C (Comedy)'),
              value: 'Option C',
              groupValue: _selectedRadio,
              onChanged: (value) {
                setState(() {
                  _selectedRadio = value!;
                });
              },
            ),
            const Divider(),

            // 4. DatePicker button and display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : 'Selected Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pick Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
