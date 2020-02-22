import 'package:flutter_test/flutter_test.dart';
import 'package:kedul_app_main/utils/date_time_utils.dart';
import 'package:kedul_app_main/widgets/week_calendar.dart';

List<Appointment> appointmentList = [
  Appointment(
      name: '1',
      startTime: DateTime(2020, 2, 21, 23, 0),
      endTime: DateTime(2020, 2, 22, 1, 0)),
  Appointment(
      name: '1',
      startTime: DateTime(2020, 2, 22, 13, 0),
      endTime: DateTime(2020, 2, 22, 15, 0)),
  Appointment(
      name: '1',
      startTime: DateTime(2020, 2, 22, 14, 0),
      endTime: DateTime(2020, 2, 22, 16, 0)),
  Appointment(
      name: '1',
      startTime: DateTime(2020, 2, 22, 17, 0),
      endTime: DateTime(2020, 2, 22, 18, 0)),
  Appointment(
      name: '1',
      startTime: DateTime(2020, 2, 22, 23, 0),
      endTime: DateTime(2020, 2, 23, 1, 0))
];

void main() {
  group('transforms appointment list to coordinates', () {
    List<Appointment> filteredAppointmentList = [];
    List<AppointmentCoordinate> appointmentCoordinates = [];
    DateTime day = DateTime(2020, 2, 22);

    test('filterAppointmentWithinDay', () {
      DateTime endOfDay = DateTimeUtils.endOfDay(day);
      DateTime startOfDay = DateTimeUtils.startOfDay(day);

      filteredAppointmentList =
          WeekCalendarUtils.filterAppointmentsWithinDay(appointmentList, day);

      for (int i = 0; i < appointmentList.length; i++) {
        Appointment prevAppointment = appointmentList[0];
        Appointment nextAppointment = filteredAppointmentList[0];

        if (prevAppointment.startTime.isBefore(startOfDay)) {
          expect(nextAppointment.startTime.isAtSameMomentAs(startOfDay), true);
        }

        if (prevAppointment.endTime.isAfter(endOfDay)) {
          expect(nextAppointment.endTime.isAtSameMomentAs(endOfDay), true);
        }
      }
    });

    test('toAppointmentCoordinates', () {
      appointmentCoordinates = WeekCalendarUtils.toAppointmentCoordinates(
          filteredAppointmentList, day);

      print(appointmentCoordinates);
    });
  });
}
