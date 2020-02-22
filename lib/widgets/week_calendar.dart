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
  _SyncScrollControllerManager _syncScrollController =
      _SyncScrollControllerManager();

  final double cellWidth = 150.0;
  final double cellHeight = 80.0;
  final double leftColumnWidth = 40.0;

  @override
  void initState() {
    super.initState();
    _syncScrollController
        .registerScrollController(_leftSideVerticalScrollController);
    _syncScrollController
        .registerScrollController(_rightSideVerticalScrollController);
  }

  @override
  void dispose() {
    _syncScrollController
        .unregisterScrollController(_leftSideVerticalScrollController);
    _syncScrollController
        .unregisterScrollController(_rightSideVerticalScrollController);

    _leftSideVerticalScrollController.dispose();
    _rightSideVerticalScrollController.dispose();

    super.dispose();
  }

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
                    // Listen to the vertical scroll
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollNotification) {
                        // Scroll right side vertical scroller simultanously
                        _syncScrollController.processScrollNotification(
                            scrollNotification,
                            _leftSideVerticalScrollController);
                        return false;
                      },
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        controller: _leftSideVerticalScrollController,
                        children: List<int>.generate(21, (i) => i + 1)
                            .map<Widget>((e) {
                          return Container(
                            height: cellHeight,
                            width: leftColumnWidth,
                            color: Colors.red,
                            child: Center(child: Text('$e')),
                          );
                        }).toList(),
                      ),
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
                                // Scroll left side vertical scroller simultanously
                                _syncScrollController.processScrollNotification(
                                    scrollNotification,
                                    _rightSideVerticalScrollController);
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

class _SyncScrollControllerManager {
  List<ScrollController> _registeredScrollControllers =
      new List<ScrollController>();

  ScrollController _scrollingController;
  bool _scrollingActive = false;

  void registerScrollController(ScrollController controller) {
    _registeredScrollControllers.add(controller);
  }

  void unregisterScrollController(ScrollController controller) {
    _registeredScrollControllers.remove(controller);
  }

  void processScrollNotification(
      ScrollNotification scrollNotification, ScrollController sender) {
    if (scrollNotification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (scrollNotification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (scrollNotification is ScrollUpdateNotification) {
        _registeredScrollControllers.forEach((controller) {
          if (!identical(controller, _scrollingController)) {
            if (controller.hasClients) {
              controller.jumpTo(_scrollingController.offset);
            }
          }
        });
        return;
      }
    }
  }
}
