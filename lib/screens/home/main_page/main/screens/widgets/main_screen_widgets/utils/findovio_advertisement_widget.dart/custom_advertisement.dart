import 'package:findovio/models/findovio_advertisement_model.dart';
import 'package:flutter/material.dart';

class CustomAdvertisement extends StatelessWidget {
  final FindovioAdvertisement advertisement;

  const CustomAdvertisement({super.key, required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 4.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  advertisement.url,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Center(
                      child: Text('Nie można załadować obrazka.'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                advertisement.title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                advertisement.content,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 32.0),
              InkWell(
                onTap: () => {Navigator.of(context).pop()},
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: const Text(
                    'Zamknij',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
