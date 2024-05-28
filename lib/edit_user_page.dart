import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class EditUserPage extends StatefulWidget {
  final Map user;

  const EditUserPage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, status, id, gender;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    id = widget.user['id'].toString();
    name = widget.user['name'];
    email = widget.user['email'];
    status = widget.user['status'];
    gender = widget.user['gender'];
  }

  Future<void> updateUser() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.put(
      Uri.parse('${Config.apiUrl}/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'status': status,
        'gender': gender,
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // Handle error
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Edit User',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (MediaQuery.of(context).size.width > 600) {
              // For screens wider than 600 pixels
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: IntrinsicHeight(
                    child: Card(
                      color: Colors.blueGrey[100],
                      child: _buildForm(),
                    ),
                  ),
                ),
              );
            } else {
              // For screens 600 pixels wide or less
              return Center(
                child: IntrinsicHeight(
                  child: Card(
                    color: Colors.blueGrey[100],
                    child: _buildForm(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: id,
              enabled: false,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter name';
                return null;
              },
              onSaved: (value) => name = value ?? '',
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter email';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
              onSaved: (value) => email = value ?? '',
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
                  gender = value!;
                });
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
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: updateUser,
                    child: const Text('Update User'),
                  ),
          ],
        ),
      ),
    );
  }
}
