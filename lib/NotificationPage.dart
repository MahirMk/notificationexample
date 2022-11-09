import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  TextEditingController _msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 123,
                    title: "Hi....",
                    channelKey:  "basic_channel",
                    body: "I am Notification Body",
                  ),
                );
              },
              child: Text("Basic"),
            ),
            ElevatedButton(
              onPressed: () async {
                AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: 123,
                      title: "Hi....",
                      channelKey:  "basic_channel",
                      body: "I am Notification Body",
                      payload: {"name":"FlutterCampus"},
                      autoDismissible: false,
                      bigPicture:
                     //"https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png"
                      "asset://img/flutter.png",
                      notificationLayout: NotificationLayout.BigPicture,
                    ),
                    actionButtons: [
                      NotificationActionButton(
                        key: "open",
                        label: "Open File",
                        buttonType: ActionButtonType.InputField,
                        enabled: true,
                      ),
                      NotificationActionButton(
                        key: "delete",
                        label: "Delete File",
                        icon: "resource://drawable/notification1.png",
                      ),
                    ]
                );
                AwesomeNotifications().actionStream.listen((action) {
                  if(action.buttonKeyPressed == "open"){
                  TextButton(
                  onPressed: () async{
                    var msg = _msg.text.toString();
                    print("msg : "+msg);
                  });
                  }
                  else if(action.buttonKeyPressed == "delete"){
                    print("Delete button is pressed.");
                  }
                });
              },
              child: Text("Badge"),
            ),
          ],
        ),
      ),
    );
  }
}
