import 'package:flutter/material.dart';

List<Staff> staffList = [
  Staff(name: 'Mike'),
  Staff(name: 'Bob'),
  Staff(name: 'Aria'),
  Staff(name: 'Alexa'),
];

List<List<Appointment>> appointmentList = [
  [Appointment(name: '1'), Appointment(name: '1'), Appointment(name: '1')],
  [Appointment(name: '2'), Appointment(name: '2'), Appointment(name: '2')],
  [Appointment(name: '3'), Appointment(name: '3'), Appointment(name: '3')],
  [Appointment(name: '3'), Appointment(name: '3'), Appointment(name: '3')],
];

class Staff {
  Staff({this.name});

  String name;
}

class Appointment {
  Appointment({this.name});

  String name;
}

class WeekCalendar extends StatefulWidget {
  @override
  _WeekCalendarState createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  ScrollController _leftSideVerticalScrollController = ScrollController();
  ScrollController _rightSideVerticalScrollController = ScrollController();
  ScrollController _rightSideHorizontalScrollController = ScrollController();

  final double cellWidth = 150.0;
  final double cellHeight = 80.0;
  final double leftColumnWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, boxConstraint) {
          return Container(
              color: Colors.grey,
              height: boxConstraint.maxHeight,
              child: Row(
                children: <Widget>[
                  // Left side
                  Container(
                    width: leftColumnWidth,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _leftSideVerticalScrollController,
                      children:
                          List<int>.generate(21, (i) => i + 1).map<Widget>((e) {
                        return Container(
                          height: cellHeight,
                          width: leftColumnWidth,
                          color: Colors.red,
                          child: Center(child: Text('$e')),
                        );
                      }).toList(),
                    ),
                  ),
                  // Right side
                  Expanded(
                      child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: _rightSideHorizontalScrollController,
                    child: Container(
                      width: cellWidth * staffList.length,
                      child: Column(
                        children: <Widget>[
                          // Header
                          Container(
                              color: Colors.green,
                              child: Row(
                                  children: staffList.map<Widget>((staff) {
                                return Container(
                                  height: cellHeight,
                                  width: cellWidth,
                                  color: Colors.blue,
                                  child: Center(child: Text(staff.name)),
                                );
                              }).toList())),
                          // Grid
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification:
                                  (ScrollNotification scrollNotification) {
                                _leftSideVerticalScrollController
                                    .jumpTo(scrollNotification.metrics.pixels);
                                return false;
                              },
                              child: ListView(
                                  controller:
                                      _rightSideVerticalScrollController,
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    Row(
                                        children:
                                            staffList.map<Widget>((staff) {
                                      return Column(
                                          children: List<int>.generate(
                                                  20, (i) => i + 1)
                                              .map<Widget>((e) {
                                        return Container(
                                          height: cellHeight,
                                          width: cellWidth,
                                          color: Colors.yellow,
                                          child: Center(child: Text('$e')),
                                        );
                                      }).toList());
                                    }).toList())
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ));
        },
      ),
    );
  }
}
