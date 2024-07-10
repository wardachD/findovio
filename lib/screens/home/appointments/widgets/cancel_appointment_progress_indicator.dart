import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AppointmentCancellationButton extends StatefulWidget {
  final int appointmentId;
  final VoidCallback callback;

  const AppointmentCancellationButton({
    Key? key,
    required this.callback,
    required this.appointmentId,
  }) : super(key: key);

  @override
  State<AppointmentCancellationButton> createState() =>
      _AppointmentCancellationButtonState();
}

class _AppointmentCancellationButtonState
    extends State<AppointmentCancellationButton> {
  bool _isLoading = false;

  Future<void> sendStatusUpdate(int appointmentId, String status) async {
    var userPy = Provider.of<FirebasePyUserProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the current Firebase user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if user is authenticated
      if (user != null) {
        // Get the Firebase user token
        String? token = await user.getIdToken();

        // Check if token is available
        if (token != null && token.isNotEmpty) {
          // Include the token in the headers
          var response = await http.put(
            Uri.parse(Consts.dbApiSendStatusChange(appointmentId, status)),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            userPy.updateWithFetch();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text('Wizyta została anulowana'),
                duration: Duration(milliseconds: 3000),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text('Nie udało się anulować wizyty.'),
                duration: Duration(milliseconds: 3000),
              ),
            );
          }
        } else {
          // Token is not available
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text('Token użytkownika niedostępny.'),
              duration: Duration(milliseconds: 3000),
            ),
          );
        }
      } else {
        // User is not authenticated
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text('Użytkownik niezalogowany.'),
            duration: Duration(milliseconds: 3000),
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions
      print('Błąd podczas wysyłania aktualizacji statusu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('Błąd: $e, skontaktuj się z administratorem.'),
          duration: const Duration(milliseconds: 3000),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        widget.callback();
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await sendStatusUpdate(
            widget.appointmentId, AppointmentStatus.cancelled);
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.37,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _isLoading
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AnimateGradient(
                    duration: const Duration(milliseconds: 1200),
                    primaryBegin: Alignment.centerRight,
                    primaryEnd: Alignment.centerRight,
                    secondaryBegin: Alignment.centerLeft,
                    secondaryEnd: Alignment.centerLeft,
                    primaryColors: const [
                      Colors.white,
                      Colors.orangeAccent
                    ],
                    secondaryColors: const [
                      Colors.orangeAccent,
                      Color.fromARGB(0, 255, 255, 255)
                    ]),
              ) // Show a loader while waiting for the response
            : const Text(
                'Anuluj wizytę',
                style: TextStyle(
                  color: Color.fromARGB(255, 34, 34, 34),
                ),
              ),
      ),
    );
  }
}
