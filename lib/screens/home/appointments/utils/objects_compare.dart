import 'package:findovio/models/user_appointment.dart';

Future<List<UserAppointment>>? areFutureListsEqual(
  Future<List<UserAppointment>>? futureList1,
  Future<List<UserAppointment>>? futureList2,
) async {
  final list1 = await futureList1;
  final list2 = await futureList2;

  if (list1?.length != list2?.length) {
    return Future.value(
        futureList1); // If the lengths are different, return null.
  }

  for (int i = 0; i < list1!.length; i++) {
    // Compare individual elements of the lists
    if (list1[i].id != list2?[i].id && list1[i].status != list2?[i].status) {
      return Future.value(
          futureList1); // If any elements are different, return null.
    }
  }
  return Future.value(
      futureList2); // If all elements are the same, return futureList2.
}
