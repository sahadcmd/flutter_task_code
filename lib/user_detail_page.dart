import 'package:flutter/material.dart';
import 'edit_user_page.dart';

class UserDetailPage extends StatelessWidget {
  final Map user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: IntrinsicHeight(
            child: Card(
              color: Colors.blueGrey[100],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${user['id']}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Name: ${user['name']}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Email: ${user['email']}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Gender: ${user['gender']}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Status: ${user['status']}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserPage(user: user),
                          ),
                        );
                      },
                      child: const Text('Edit User'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
