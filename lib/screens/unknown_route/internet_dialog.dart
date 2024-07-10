import 'package:flutter/material.dart';

class InternetAlertDialog extends StatelessWidget {
  const InternetAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              backgroundColor: Colors.black,
              title: Center(
                child: Text(
                  'Ups, brak internetu 😭',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Niestety do korzystania z aplikacji potrzebujesz połączenie z internetem.\n\nSwoje rezerwacje możesz również sprawdzić w mailu.',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Włącz internet by znów cieszyć się aplikacją.',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            barrierColor: const Color.fromARGB(211, 255, 255, 255),
            barrierDismissible:
                false, // Dialog can't be dismissed by tapping outside
          );
        },
        child: const Text('Show Dialog'),
      ),
    );
  }
}
