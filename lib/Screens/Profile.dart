import 'package:app/Objects/Location.dart';
import 'package:app/Objects/user.dart';
import 'package:flutter/material.dart';
//import 'package:momentum/Objects/user.dart';

class Profile extends StatelessWidget {
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Áreas de atuação'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Container(
          child: Center(
              child: InitialList()
              //child: _displayUserData(user.profileData),
            ),
        ),
      ),
    );
  }



  /** _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
               image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
              
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "Logged in as: ${profileData['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
}*/

}

class InitialList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InitialListItem(),
        InitialListItem()
      ],
    );
  }
}

class InitialListItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text('Title'),
        subtitle: Text('Subtitle'),
      ),
    );
  }

}
