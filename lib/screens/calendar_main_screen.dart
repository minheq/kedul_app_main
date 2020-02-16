import 'package:flutter/material.dart';
import 'package:kedul_app_main/storage/secure_storage_model.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';

final secureStorageModel = SecureStorageModel();

class CalendarMainScreen extends StatefulWidget {
  static const String routeName = '/calendar_main';

  @override
  _CalendarMainScreenState createState() {
    return _CalendarMainScreenState();
  }
}

class _CalendarMainScreenState extends State<CalendarMainScreen> {
  _CalendarMainScreenState();

  Future<void> loadData() async {
    final jwt = await secureStorageModel.read('access_token');
    print(jwt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 96),
                Text("Calendar Main Screen"),
                PrimaryButton(
                  onPressed: loadData,
                  title: 'print',
                )
              ],
            )));
  }
}
