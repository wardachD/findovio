import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:flutter/material.dart';

class BookingDetails extends StatelessWidget {
  final UserAppointment userAppointment;
  final Future<SalonModel> salonModel;

  const BookingDetails({
    Key? key,
    required this.userAppointment,
    required this.salonModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Szczegóły',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        // Informacje o salonie
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<SalonModel>(
                future:
                    salonModel, // Zakładam, że salonInfo to Future<SalonModel>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Wyświetl loader podczas oczekiwania na dane
                  } else if (snapshot.hasError) {
                    return Text(
                        'Wystąpił błąd: ${snapshot.error}'); // Wyświetl komunikat w przypadku błędu
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text(
                        'Brak danych'); // Wyświetl komunikat, jeśli brak danych
                  } else {
                    final salon = snapshot.data!;

                    // Tutaj możesz użyć danych z salon, np.:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nazwa salonu: ${salon.name}'),
                        Text('Miasto: ${salon.addressCity}'),
                        // Tutaj możesz wyświetlić więcej informacji o salonie na podstawie danych z 'salon'
                        // Np. salon.addressPostalCode, salon.addressStreet, itd.

                        // Możesz również użyć danych z UserAppointment, np.:
                        Text('ID rezerwacji: ${userAppointment.id}'),
                        Text('Status rezerwacji: ${userAppointment.status}'),
                        // Możesz dodać więcej informacji z UserAppointment, jeśli są dostępne
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
        // Informacje o usługach
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informacje o usługach',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Wyświetlenie listy zabookowanych usług
              for (final service in userAppointment.services)
                _buildDetailRow(service.title, '${service.price} zł'),
              const SizedBox(height: 12),
              // Wyświetlenie całkowitej kwoty
              _buildDetailRow(
                'Razem',
                '${userAppointment.totalAmount} zł',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
