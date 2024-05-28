import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'config.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String status = 'active';
  String? gender;
  bool isLoading = false;

  final String draftKeyName = 'draft_name';
  final String draftKeyEmail = 'draft_email';
  final String draftKeyGender = 'draft_gender';
  final String draftKeyStatus = 'draft_status';

  @override
  void initState() {
    super.initState();
    loadDraft();
  }

  Future<void> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString(draftKeyName) ?? '';
      _emailController.text = prefs.getString(draftKeyEmail) ?? '';
      gender = prefs.getString(draftKeyGender);
      status = prefs.getString(draftKeyStatus) ?? 'active';
    });
  }

  Future<void> saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(draftKeyName, _nameController.text);
    prefs.setString(draftKeyEmail, _emailController.text);
    if (gender != null) prefs.setString(draftKeyGender, gender!);
    prefs.setString(draftKeyStatus, status);
  }

  Future<void> createUser() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(Config.apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ead06f9bb2d778382385489cce21ac3326bd3f6c82091de44b3ce42e3ed386c8',
        },
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'status': status,
          'gender': gender,
        }),
      );

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(draftKeyName);
        await prefs.remove(draftKeyEmail);
        await prefs.remove(draftKeyGender);
        await prefs.remove(draftKeyStatus);

        if (!mounted) return;
        Navigator.pop(context);
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String generateRandomId() {
    // Generate a random ID for demonstration purposes
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (MediaQuery.of(context).size.width > 600) {
              // For screens wider than 600 pixels
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: IntrinsicHeight(
                    child: Card(
                      color: Colors.blue[100],
                      child: _newUserForm(),
                    ),
                  ),
                ),
              );
            } else {
              // For screens 600 pixels wide or less
              return Center(
                child: IntrinsicHeight(
                  child: Card(
                    color: Colors.blue[100],
                    child: _newUserForm(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _newUserForm() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        // onChanged: saveDraft,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'ID'),
              enabled: false, // ID is read-only
              initialValue: generateRandomId(), // Generate a random ID
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter name';
                return null;
              },
              onChanged: (value) => saveDraft(), // Handle null value
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter email';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
              onChanged: (value) => saveDraft(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['male', 'female']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
                saveDraft();
              },
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Status'),
              value: status == 'active',
              onChanged: (bool value) {
                setState(() {
                  status = value ? 'active' : 'inactive';
                });
                saveDraft();
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: createUser,
                    child: const Text('Create User'),
                  ),
          ],
        ),
      ),
    );
  }
}
