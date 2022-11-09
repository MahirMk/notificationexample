import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudNotificationExample extends StatefulWidget {

  @override
  State<CloudNotificationExample> createState() => _CloudNotificationExampleState();
}

class _CloudNotificationExampleState extends State<CloudNotificationExample> {

  var token="";

  getdata()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      token = prefs.getString("token");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Notification"),
      ),
      body: Text("Token : "+token),
    );
  }
}
