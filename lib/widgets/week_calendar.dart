import 'package:flutter/material.dart';

class Staff {
  Staff({this.name});

  String name;
}

class Appointment {
  Appointment({this.name, this.startTime, this.endTime});

  String name;
  DateTime startTime;
  DateTime endTime;
}

const int _HOURS = 24;

class WeekCalendar extends StatefulWidget {
  WeekCalendar(this._staffList, this._appointmentsList);

  final List<Staff> _staffList;
  final List<List<Appointment>> _appointmentsList;

  @override
  _WeekCalendarState createState() =>
      _WeekCalendarState(_staffList, _appointmentsList);
}

class _WeekCalendarState extends State<WeekCalendar> {
  _WeekCalendarState(this._staffList, this._appointmentsList);

  ScrollController _leftSideVerticalScrollController = ScrollController();
  ScrollController _rightSideVerticalScrollController = ScrollController();
  ScrollController _rightSideHorizontalScrollController = ScrollController();
  _SyncScrollControllerManager _syncScrollController =
      _SyncScrollControllerManager();

  final List<Staff> _staffList;
  final List<List<Appointment>> _appointmentsList;

  final double _cellWidth = 150.0;
  final double _cellHeight = 48.0;
  final double _leftColumnWidth = 40.0;

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
                    width: _leftColumnWidth,
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
                        children: <Widget>[
                          Container(
                            height: _cellHeight,
                            width: _leftColumnWidth,
                          ),
                          _Hours(_cellHeight, _leftColumnWidth),
                        ],
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
                      width: _cellWidth * _staffList.length,
                      child: Column(
                        children: <Widget>[
                          // Header
                          Container(
                              color: Colors.green,
                              child: Row(
                                  children: _staffList.map<Widget>((staff) {
                                return Container(
                                  height: _cellHeight,
                                  width: _cellWidth,
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
                                            _staffList.map<Widget>((staff) {
                                      return Column(children: <Widget>[
                                        Container(
                                            height: _HOURS * _cellHeight,
                                            width: _cellWidth,
                                            color: Colors.yellow)
                                      ]);
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

class _Hours extends StatelessWidget {
  _Hours(this._cellHeight, this._leftColumnWidth);

  final double _cellHeight;
  final double _leftColumnWidth;

  @override
  Widget build(BuildContext context) {
    List<int> hours = List<int>.generate(_HOURS, (i) {
      return i;
    });

    List<Widget> hoursWidgetList = List<Widget>();

    for (int hour in hours) {
      hoursWidgetList.add(Container(
        height: _cellHeight,
        width: _leftColumnWidth,
        color: Colors.red,
        child: Center(child: Text('$hour')),
      ));
    }

    return Column(children: hoursWidgetList);
  }
}