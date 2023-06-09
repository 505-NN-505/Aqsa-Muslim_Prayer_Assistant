import 'package:aqsa_muslim_prayer_assistant/screens/timer/timer.dart';
import 'package:aqsa_muslim_prayer_assistant/utilities/storage_service.dart';
import 'package:aqsa_muslim_prayer_assistant/utilities/time_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/al_adhan_api_bloc.dart';

class AlAdhanApi extends StatefulWidget {
  const AlAdhanApi({super.key});

  @override
  State<AlAdhanApi> createState() => _AlAdhanApiState();
}

class _AlAdhanApiState extends State<AlAdhanApi> {
  late String currentWakt = "Isha";
  late String currentStartTime = "";
  late int remainingTime = 0;
  late int remainingTimeIftar = 0;
  late String mealTime = "";
  Map<String, String> timingMap = {};

  void resetTimer() {
    print(timingMap);
    currentStartTime = TimeChecker.convertToAmPm(timingMap["Isha"]!);
    timingMap.forEach((k, v) {
      if (TimeChecker.isTimeGreaterEqual(v)) {
        currentWakt = k;
        currentStartTime = TimeChecker.convertToAmPm(v);
      }
    });

    if (TimeChecker.isTimeGreaterEqual(timingMap["Fajr"]!) &&
        TimeChecker.isTimeLessEqual(timingMap["Sunrise(Forbidden)"]!)) {
      remainingTime = TimeChecker.calculateRemainingTimeInSeconds(
          timingMap["Sunrise(Forbidden)"]!);
    } else if (TimeChecker.isTimeGreaterEqual(timingMap["Fajr"]!) &&
        TimeChecker.isTimeLessEqual(timingMap["Dhuhr"]!)) {
      remainingTime = 0;
    } else if (TimeChecker.isTimeGreaterEqual(timingMap["Dhuhr"]!) &&
        TimeChecker.isTimeLessEqual(timingMap["Asr"]!)) {
      remainingTime =
          TimeChecker.calculateRemainingTimeInSeconds(timingMap["Asr"]!);
    } else if (TimeChecker.isTimeGreaterEqual(timingMap["Asr"]!) &&
        TimeChecker.isTimeLessEqual(timingMap["Maghrib"]!)) {
      remainingTime =
          TimeChecker.calculateRemainingTimeInSeconds(timingMap["Maghrib"]!);
    } else if (TimeChecker.isTimeGreaterEqual(timingMap["Maghrib"]!) &&
        TimeChecker.isTimeLessEqual(timingMap["Isha"]!)) {
      remainingTime =
          TimeChecker.calculateRemainingTimeInSeconds(timingMap["Isha"]!);
    } else if (TimeChecker.isTimeGreaterEqual(timingMap["Isha"]!) ||
        TimeChecker.isTimeLessEqual(timingMap["Fajr"]!)) {
      remainingTime =
          TimeChecker.calculateRemainingTimeInSeconds(timingMap["Fajr"]!);
    }

    if (currentWakt == "Maghrib" || currentWakt == "Isha") {
      remainingTimeIftar =
          TimeChecker.calculateRemainingTimeInSeconds(timingMap["Imsak"]!);
      mealTime = "Suhur";
    } else {
      remainingTimeIftar =
          TimeChecker.calculateRemainingTimeInSeconds(timingMap["Maghrib"]!);
      mealTime = "Iftar";
    }
    print(currentWakt);
    print(currentStartTime);
    print(remainingTime);
    print(remainingTimeIftar);
  }

  @override
  Widget build(BuildContext context) {
    if (timingMap.isNotEmpty && remainingTime == 0) {
      resetTimer();
    }
    if (timingMap.isNotEmpty && remainingTimeIftar == 0) {
      resetTimer();
    }
    return BlocBuilder<AlAdhanApiBloc, AlAdhanApiState>(
      builder: (context, state) {
        if (state is AlAdhanApiLoaded) {
          timingMap["Imsak"] = state.model.data?.timings?.imsak ?? "N/A";
          timingMap["Fajr"] = state.model.data?.timings?.fajr ?? "N/A";
          timingMap["Sunrise(Forbidden)"] =
              state.model.data?.timings?.sunrise ?? "N/A";
          timingMap["Dhuhr"] = state.model.data?.timings?.dhuhr ?? "N/A";
          timingMap["Asr"] = state.model.data?.timings?.asr ?? "N/A";
          timingMap["Sunset(Forbidden)"] =
              state.model.data?.timings?.sunset ?? "N/A";
          timingMap["Maghrib"] = state.model.data?.timings?.maghrib ?? "N/A";
          timingMap["Isha"] = state.model.data?.timings?.isha ?? "N/A";

          resetTimer();

          return Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Now: ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  "$currentWakt",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text(
                                  "Starting: ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  currentStartTime,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Suhur: ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Text(
                                    TimeChecker.convertToAmPm(
                                        timingMap["Imsak"]!),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Iftar: ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Text(
                                    TimeChecker.convertToAmPm(
                                        timingMap["Maghrib"]!),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                'Time Remaining',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'for ${currentWakt}',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              TimerPage(duration: remainingTime),
                            ],
                          ),
                        )),
                    Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Countdown to',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    mealTime,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              TimerPage(duration: remainingTimeIftar),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Text('');
        }
      },
    );
  }
}
