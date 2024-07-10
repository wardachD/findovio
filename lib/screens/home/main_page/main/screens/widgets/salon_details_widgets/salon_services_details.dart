import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/main_page/main/screens/Booking/screens/booking_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';

class SalonServicesDetails extends StatefulWidget {
  final SalonModel salonModel;
  final Function callbackTop;
  final Function callbackBottom;
  final Function callbackImageHeight;
  final ValueNotifier callbackSetImageHeight;

  const SalonServicesDetails(
      {super.key,
      required this.salonModel,
      required this.callbackTop,
      required this.callbackBottom,
      required this.callbackImageHeight,
      required this.callbackSetImageHeight});

  @override
  State<SalonServicesDetails> createState() => _SalonServicesDetailsState();
}

class _SalonServicesDetailsState extends State<SalonServicesDetails>
    with TickerProviderStateMixin {
  final ValueNotifier<bool> isScrollingUpNotifier = ValueNotifier(false);
  Set<Services> selectedServices = {};
  late Future<List<SalonSchedule>> futureSalonSchedules;
  late Future<List<SalonWorkingHours>> futureSalonWorkingHours;
  late ScrollController _scrollController;
  bool isScroll = false;
  double currentOffset = 0;
  double _initialSwipeOffset = 0;
  double deltaOffset = 0;

  void _toggleService(Services service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        if (selectedServices.length < 3) {
          selectedServices.add(service);
        }
      }
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {});
    futureSalonSchedules =
        fetchSalonSchedules(http.Client(), widget.salonModel.id);
    futureSalonWorkingHours =
        fetchSalonWorkingHours(http.Client(), widget.salonModel.id);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: selectedServices.isNotEmpty
              ? const EdgeInsets.only(bottom: 45)
              : const EdgeInsets.all(0),
          child: RawGestureDetector(
            gestures: {
              AllowMultipleGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                      AllowMultipleGestureRecognizer>(
                () => AllowMultipleGestureRecognizer(),
                (AllowMultipleGestureRecognizer instance) {
                  instance
                    ..onStart = (DragStartDetails details) {
                      _initialSwipeOffset = details.localPosition.dy;
                    }
                    ..onUpdate = (DragUpdateDetails details) {
                      currentOffset = details.localPosition.dy;
                      deltaOffset = currentOffset - _initialSwipeOffset;
                      if (deltaOffset > 10 &&
                          _scrollController.position.extentBefore == 0) {
                        widget.callbackBottom();
                      }
                      if (deltaOffset < -10) widget.callbackTop();
                    }
                    ..onEnd = (DragEndDetails details) {};
                },
              )
            },
            behavior: HitTestBehavior.deferToChild,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.salonModel.categories.length,
              itemBuilder: (context, index) {
                if (widget.salonModel.categories[index].isAvailable == false) {
                  return const SizedBox();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.orange,
                              offset: Offset(0, 1),
                            ),
                          ]),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.salonModel.categories[index].name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...widget.salonModel.categories[index].services
                        .map<Widget>((service) {
                      if (service.isAvailable != null &&
                          service.isAvailable == false) {
                        return const SizedBox();
                      }
                      return InkWell(
                        splashColor: const Color.fromARGB(255, 255, 243, 225),
                        onTap: () {
                          _toggleService(service);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: DottedBorder(
                            padding: const EdgeInsets.all(5),
                            radius: const Radius.circular(20),
                            borderType: BorderType.RRect,
                            color: selectedServices.contains(service)
                                ? Colors.orange
                                : Colors.white,
                            strokeWidth: 1.5,
                            dashPattern: const [5, 5],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(8),
                              height: 65,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    selectedServices.contains(service)
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: selectedServices.contains(service)
                                        ? Colors.orange
                                        : Colors.grey,
                                    size: 21,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          service.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        Text(
                                          '${service.durationMinutes} minut',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${service.price} PLN',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                splashColor: selectedServices.isNotEmpty
                    ? Colors.orange
                    : Colors.transparent,
                onTap: () {
                  if (selectedServices.isNotEmpty) {
                    Get.to(() => BookingScreen(
                          salon: widget.salonModel,
                          services: selectedServices.toList(),
                          schedule: futureSalonSchedules,
                          workingHours: futureSalonWorkingHours,
                        ));
                  }
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: selectedServices.isNotEmpty ? 1 : 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Zarezerwuj',
                          style:
                              TextStyle(color: Color.fromARGB(255, 41, 41, 41)),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          alignment: Alignment.center,
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: const Color.fromARGB(172, 255, 153, 0),
                          ),
                          child: Text(
                            selectedServices.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

class AllowMultipleGestureRecognizer extends VerticalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
