import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:httpapp/Model/User.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP'),
      ),
      body: FutureBuilder(
      future: getUserProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Container(
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                        child: Image.network(snapshot.data!.profilePictureurl)),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!.firstName),
                        Text(snapshot.data!.lastName),
                        Text(snapshot.data!.email),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    ),
    );
  }
}

Future<User> getUserProfileData() async {
  var request = Uri.parse('https://randomuser.me/api/');
  late http.Response response;

  try {
    response = await http.get(request);
    Map jsonMap = jsonDecode(response.body);
    List<dynamic> results = jsonMap['results'];
    late User user;

    for (var item in results) {
      var firstName = item['name']['first'];
      var lastName = item['name']['last'] + " " + item['name']['last'];
      var email = item['email'];
      var url = item['picture']['medium'];

      user = User(
          email: email,
          firstName: firstName,
          lastName: lastName,
          profilePictureurl: url);
    }
    return user;
  } catch (e) {
    return Future.error(e.toString());
}
}