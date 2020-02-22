import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/utils/date_time_utils.dart';
import 'package:provider/provider.dart';

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
  // First index should match the index of the staff from _staffList
  final List<List<Appointment>> _appointmentsList;

  final double _cellWidth = 150.0;
  final double _cellHeight = 48.0;
  final double _leftColumnWidth = 48.0;

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
                  // Left side (hours column)
                  Container(
                    width: _leftColumnWidth,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: _cellHeight,
                          width: _leftColumnWidth,
                        ),
                        Expanded(
                          // Listen to the vertical scroll
                          child: NotificationListener<ScrollNotification>(
                            onNotification:
                                (ScrollNotification scrollNotification) {
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
                                _HoursColumn(_cellHeight, _leftColumnWidth),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Right side (header and events)
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
                                            child: Stack(
                                              children: <Widget>[
                                                if (staff.name == 'Mike')
                                                  Positioned(
                                                      top: 30,
                                                      width: _cellWidth,
                                                      child: Container(
                                                        height: 100,
                                                        color: Colors.yellow,
                                                      )),
                                                if (staff.name == 'Mike')
                                                  Positioned(
                                                      top: 190,
                                                      width: _cellWidth,
                                                      child: Container(
                                                        height: 100,
                                                        color: Colors.yellow,
                                                      ))
                                              ],
                                            ))
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

class AppointmentCoordinate {
  AppointmentCoordinate(
      {this.top, this.height, this.width, this.offsetWidth, this.appointment});

  int top;
  int height;
  double width;
  double offsetWidth;
  Appointment appointment;
}

class WeekCalendarUtils {
  final int _minuteStep = 5;

  /// filterAppointmentsWithinDay ensures appointments start time and end time are within a day.
  /// For example, if an appoinntment starts at 23:00 and ends next day 01:00
  /// the function will split the appointment to 23:00-23:59 and 00:00-01:00,
  /// and discard the one with the date that's different from the day.
  static List<Appointment> filterAppointmentsWithinDay(
      List<Appointment> appointments, DateTime day) {
    List<Appointment> filteredAppointments = [];
    DateTime endOfDay = DateTimeUtils.endOfDay(day);
    DateTime startOfDay = DateTimeUtils.startOfDay(day);

    for (Appointment appointment in appointments) {
      if (appointment.startTime.isBefore(startOfDay)) {
        appointment.startTime = startOfDay;
      }

      if (appointment.endTime.isAfter(endOfDay)) {
        appointment.endTime = endOfDay;
      }

      filteredAppointments.add(appointment);
    }

    return appointments;
  }

  static List<AppointmentCoordinate> toAppointmentCoordinates(
      List<Appointment> appointments, DateTime day) {
    DateTime startOfDay = DateTimeUtils.startOfDay(day);

    List<AppointmentCoordinate> coordinates = [];

    appointments.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });

    for (Appointment appointment in appointments) {
      AppointmentCoordinate coordinate = AppointmentCoordinate();

      coordinate.appointment = appointment;

      int differenceFromStartOfDayInMinutes =
          appointment.startTime.difference(startOfDay).inMinutes;
      coordinate.top = differenceFromStartOfDayInMinutes;

      int appointmentInMinutes =
          appointment.endTime.difference(appointment.startTime).inMinutes;
      coordinate.height = appointmentInMinutes;

      coordinates.add(coordinate);
    }

    // This algorithm is O(n^2). We can probably do better,
    // but given the input size is small it should work fine for now
    for (AppointmentCoordinate coordinate in coordinates) {
      int overlapCount = 0;
      bool hasOverlappedSelf = false;
      double offset = 0;

      for (AppointmentCoordinate compared in coordinates) {
        bool areOverlapping = coordinate.top < compared.top
            ? coordinate.top - coordinate.height < compared.top
            : compared.top - compared.height < coordinate.top;

        if (areOverlapping == false) {
          continue;
        }

        overlapCount++;

        if (identical(coordinate.appointment, compared.appointment)) {
          hasOverlappedSelf = true;
        }

        if (hasOverlappedSelf == false) {
          offset++;
        }
      }

      coordinate.offsetWidth = offset;
      coordinate.width = 1 / overlapCount;
    }

    return coordinates;
  }
}

/// _SyncScrollControllerManager manages synchronization of vertical scroll position
/// of left side and right side of the calendar
/// On the high level, it works by when left side scrolls, it tells the right side scroller
/// scroll to the same position.
/// For this to work, it has to prevent cyclic notification by marking which of them is the main
/// driver, and only scroll the sibling.
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

class _HoursColumn extends StatelessWidget {
  _HoursColumn(this._cellHeight, this._leftColumnWidth);

  final double _cellHeight;
  final double _leftColumnWidth;
  final List<DateTime> hours = List<DateTime>.generate(_HOURS, (i) {
    return DateTime(2020, 1, 1, i);
  });

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    List<Widget> hoursWidgetList = List<Widget>();

    for (DateTime hour in hours) {
      if (hour.hour == 0) {
        hoursWidgetList
            .add(Container(height: _cellHeight, width: _leftColumnWidth));
        continue;
      }

      hoursWidgetList.add(Container(
        height: _cellHeight,
        width: _leftColumnWidth,
        child: Text(
          '${DateFormat.j().format(hour)}',
          style: theme.textStyles.caption,
          textAlign: TextAlign.center,
        ),
      ));
    }

    return Column(children: hoursWidgetList);
  }
}
