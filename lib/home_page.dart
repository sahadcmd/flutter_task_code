import 'package:flutter/material.dart';
import 'package:flutter_task/add_user_page.dart';
import 'package:flutter_task/user_detail_page.dart';
import 'package:flutter_task/edit_user_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List users = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(Config.apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Error fetching users: ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching users: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('User List')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('User List')),
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'USER LIST',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (MediaQuery.of(context).size.width < 600) {
                  // For small screens, show only the icon
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddUserPage()),
                      );
                    },
                    tooltip: 'Add New User',
                  );
                } else {
                  // For large screens, show the text label and icon
                  return IconButton(
                    icon: const Row(
                      children: [
                        Text('New User'),
                        Icon(Icons.add),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddUserPage()),
                      );
                    },
                    tooltip: 'Add New User',
                  );
                }
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(160, 52, 56, 57),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.white,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueGrey),
                    columns: const [
                      DataColumn(
                        label: Center(
                          child: Text(
                            'Name',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    rows: users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Center(child: Text(user['name'])),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailPage(user: user),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            } else {
              // Large screen layout
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blueGrey),
                        columns: const [
                          DataColumn(
                              label: Text(
                            'ID',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Name',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Email',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Gender',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Status',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Actions',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          )),
                        ],
                        rows: users.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user['id'].toString())),
                              DataCell(Text(user['name'])),
                              DataCell(Text(user['email'])),
                              DataCell(Text(user['gender'])),
                              DataCell(Text(user['status'])),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserDetailPage(user: user),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditUserPage(user: user),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
