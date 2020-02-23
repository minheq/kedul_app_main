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
  WeekCalendar(this._staffList, this._appointmentsList, this._day);

  final DateTime _day;
  final List<Staff> _staffList;
  final List<List<Appointment>> _appointmentsList;

  @override
  _WeekCalendarState createState() =>
      _WeekCalendarState(_staffList, _appointmentsList, _day);
}

class _WeekCalendarState extends State<WeekCalendar> {
  _WeekCalendarState(this._staffList, this._appointmentsList, this._day);

  ScrollController _leftSideVerticalScrollController = ScrollController();
  ScrollController _rightSideVerticalScrollController = ScrollController();
  ScrollController _rightSideHorizontalScrollController = ScrollController();
  _SyncScrollControllerManager _syncScrollController =
      _SyncScrollControllerManager();

  final DateTime _day;
  final List<Staff> _staffList;
  // First index should match the index of the staff from _staffList
  final List<List<Appointment>> _appointmentsList;

  final double _cellWidth = 150.0;
  final double _cellHeight = 60.0;
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
    ThemeModel theme = Provider.of<ThemeModel>(context);
    List<Widget> appointmentColumns = [];

    // Calculate
    for (int i = 0; i < _staffList.length; i++) {
      List<Appointment> staffAppointmentList = _appointmentsList[i];
      List<Appointment> filteredAppointmentList =
          WeekCalendarUtils.filterAppointmentsWithinDay(
              staffAppointmentList, _day);

      List<AppointmentCoordinate> appointmentCoordinates =
          WeekCalendarUtils.toAppointmentCoordinates(filteredAppointmentList,
              _day, _cellWidth, DateTimeUtils.minutesInADay.toDouble());

      List<Widget> appointmentCoordinateWidgets = [];

      for (AppointmentCoordinate coordinate in appointmentCoordinates) {
        appointmentCoordinateWidgets.add(Positioned(
            top: coordinate.top,
            width: coordinate.width,
            left: coordinate.left,
            child: Container(
              height: coordinate.height,
              color: Colors.yellow,
            )));
      }

      appointmentColumns.add(Column(children: <Widget>[
        Container(
            height: _HOURS * _cellHeight,
            width: _cellWidth,
            child: Stack(
              children: appointmentCoordinateWidgets,
            ))
      ]));
    }

    // Hours column
    final List<DateTime> hours = List<DateTime>.generate(_HOURS, (i) {
      return DateTime(2020, 1, 1, i);
    });
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
                    child: Column(
                      children: <Widget>[
                        // Top cell placeholder
                        Container(
                          height: _cellHeight,
                          width: _leftColumnWidth,
                        ),
                        // Hours column
                        Expanded(
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
                                Column(children: hoursWidgetList),
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
                                    Row(children: appointmentColumns)
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
      {this.top, this.height, this.width, this.left, this.appointment});

  double height;
  double top;
  double width;
  double left;
  Appointment appointment;
}

class WeekCalendarUtils {
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
      List<Appointment> appointments,
      DateTime day,
      double columnWidth,
      double columnHeight) {
    DateTime startOfDay = DateTimeUtils.startOfDay(day);

    List<AppointmentCoordinate> coordinates = [];

    // Order appointments by their start time
    appointments.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });

    // Create coordinates and give them top position and height
    for (Appointment appointment in appointments) {
      AppointmentCoordinate coordinate = AppointmentCoordinate();

      coordinate.appointment = appointment;

      int differenceFromStartOfDayInMinutes =
          appointment.startTime.difference(startOfDay).inMinutes;
      coordinate.top = differenceFromStartOfDayInMinutes.toDouble();

      int appointmentInMinutes =
          appointment.endTime.difference(appointment.startTime).inMinutes;
      coordinate.height = appointmentInMinutes.toDouble();

      coordinates.add(coordinate);
    }

    // Update coordinates with width and offsetWidth
    // Note that we want coordinates to not overlap each other when shown in column
    //
    // How it works:
    // Assuming we have 5 appointments, denoted by [startTime, endtime]
    // [[0, 3], [2.5, 4], [3, 5], [6, 8], [7, 9]] (there will be 2 overlapping groups)
    //
    // In the first iteration, where start and end is 0
    // prevCoordinate = [0, 3], nextCoordinate = [2.5, 4]
    // the ranges are overlapping so end will increment, start=0 and end=1
    // Next iteration:
    // prevCoordinate = [2.5, 4], nextCoordinate = [3, 5]
    // the ranges are overlapping so end will increment, start=0 and end=2
    // Next iteration:
    // prevCoordinate = [3, 5], nextCoordinate = [6, 8]
    // the ranges are NOT overlapping. we take the sublist of appointments from start=0 to end=2
    // and add it to overlapping coordinates group list [[[0, 3], [2.5, 4], [3, 5]]]
    // then we set start and end to be end + 1, so start=3 and end=3
    // Next iteration:
    // prevCoordinate = [6, 8], nextCoordinate = [7, 9]
    // the ranges are overlapping so end will increment, start=3 and end=4
    // Next iteration:
    // end is 4, which is the last item, we add the remainer of the appointments to the group list
    // from start=3 and end=4
    // we increment end to exit the while loop

    List<List<AppointmentCoordinate>> overlappingCoordinatesGroup = [];

    int start = 0;
    int end = 0;

    while (end != appointments.length) {
      if (end == appointments.length - 1) {
        overlappingCoordinatesGroup.add(coordinates.sublist(start));
        end++;
        continue;
      }

      AppointmentCoordinate prevCoordinate = coordinates[end];
      AppointmentCoordinate nextCoordinate = coordinates[end + 1];

      bool areCoordinatesOverlapping =
          nextCoordinate.top - nextCoordinate.height < prevCoordinate.top;

      if (areCoordinatesOverlapping) {
        end++;
        continue;
      }

      end = end + 1;
      overlappingCoordinatesGroup.add(coordinates.sublist(start, end));
      start = end;
    }

    // Unroll overlapping groups and combine them into final list of coordinates
    final List<AppointmentCoordinate> finalCoordinates = [];

    for (List<AppointmentCoordinate> group in overlappingCoordinatesGroup) {
      double coordinateWidthRatio = 1 / group.length;

      for (int i = 0; i < group.length; i++) {
        AppointmentCoordinate coordinate = group[i];

        coordinate.width = columnWidth * coordinateWidthRatio;
        coordinate.left = coordinate.width * i;

        finalCoordinates.add(coordinate);
      }
    }

    return finalCoordinates;
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
