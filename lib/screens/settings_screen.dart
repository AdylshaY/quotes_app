import 'package:flutter/material.dart';
import 'package:mindful_app/data/sp_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController txtName = TextEditingController();
  final List<String> _images = ['Lake', 'Mountain', 'Sea', 'Country'];
  String _selectedImage = 'Lake';
  final SpHelper helper = SpHelper();

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16.0,
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(
                hintText: 'Enter Your Name',
              ),
            ),
            DropdownButton<String>(
              value: _selectedImage,
              onChanged: (newValue) {
                setState(() => _selectedImage = newValue ?? 'Lake');
              },
              items: _images.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveSettings().then((value) {
            String message = value
                ? 'Settings have been saved'
                : 'Error: the settings were not saved';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 3),
              ),
            );
          });
        },
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }

  Future<bool> saveSettings() async {
    return await helper.setSettings(txtName.text, _selectedImage);
  }

  Future<void> getSettings() async {
    Map<String, String> settings = await helper.getSettings();
    _selectedImage = settings['image'] ?? 'Lake';
    txtName.text = settings['name'] ?? '';
    if(_selectedImage == '') _selectedImage = 'Lake';
    setState(() {});
  }

  @override
  void dispose() {
    txtName.dispose();
    super.dispose();
  }
}
