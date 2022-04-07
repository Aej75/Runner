import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'functions/constants.dart';
import 'functions/tapped.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  Duration duration = const Duration();
  Timer? timer;

  getCurrentUID() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  //for geolocator
  late double getLat = 0.0;
  late double getLong = 0.0;
  double _speed = 0.0;
  double _trip = 0.0;
  int steps = 0;
  late int updatedSpeed;
  late int updatedDistance;
  late String time;
  late String _currentDate;
  late String _currentTime;


  late double initialLat;
  late double initialLong;

  late LocationSettings locationSettings;
  late StreamSubscription<Position> positionStream;
  late StreamSubscription<ServiceStatus> serviceStatusStream;

  void newSpeed() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          // forceLocationManager: true,
          intervalDuration: const Duration(seconds: 1),
          timeLimit: const Duration(seconds: 60),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Runner app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((position) {
      _onSpeedChange((position.speed * 18) / 5);
      _totalDistance(position.speed * 2.23694);
      if (kDebugMode) {
        print(
            '${position.latitude.toString()}, ${position.longitude.toString()}');
      }
    });
  }

  void checkService() {
    Geolocator.getServiceStatusStream().listen((status) {
      if (kDebugMode) {
        print('status = $status');
      }
    });
  }

  List speedData = [];


  late double newSpeedForStep = 0;

  void _onSpeedChange(double newSpeed) {
    setState(() {
      _speed = newSpeed;
      updatedSpeed = _speed.toInt();
      speedData.add(updatedSpeed);
      newSpeedForStep = (newSpeed * 5) / 18;

      if (newSpeedForStep > 1.7 && newSpeedForStep < 2.6) {
        steps = steps + 1;
      } else if (newSpeedForStep > 2.6 && newSpeedForStep < 5) {
        steps = steps + 2;
      }else{
        steps = steps + 3;
      }
    });
  }

  getCurrentTAD() {
    DateTime now = DateTime.now();

    _currentDate =
        '${now.year.toString()}-${now.month.toString()}-${now.day.toString()}';
    _currentTime = '${now.hour.toString()}:${now.minute}';

    // return Container(
    //   height: 22,
    //   width: 65,
    //   color: kBodyForegroundColor,
    //   child: Center(
    //     child: Text(
    //       '${now.year.toString()}-${now.month.toString()}-${now.day.toString()}',
    //       style: const TextStyle(color: kForegroundColor, fontSize: 17),
    //     ),
    //   ),
    // );
  }

  void _totalDistance(double distance) {
    setState(() {
      _trip += distance;
      updatedDistance = _trip.toInt();
    });
  }

  @override
  void initState() {
    super.initState();
    reset();
    getLatLong();
  }

  void reset() {
    setState(() {
      duration = const Duration();
    });
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
      positionStream.cancel();
      _speed = 0.0;
      _trip = 0.0;
      steps = 0;
    }
    setState(() {
      timer?.cancel();
    });
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(24));
    time = '$hours:$minutes:$seconds';
    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(fontSize: kBigFont, color: kForegroundColor),
    );
  }

  Future<Position> getLatLong() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Future.error('Denied Forever');
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    getLat = currentPosition.latitude;
    getLong = currentPosition.longitude;

    initialLat = currentPosition.latitude;
    initialLong = currentPosition.longitude;

    return currentPosition;
  }

  Widget buildButtons() {
    FutureBuilder(
      builder: (context, data) {
        if (data.hasData) {
          return Text(data.data.toString());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: getLatLong(),
    );

    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || !isCompleted
        ? Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      if (isRunning) {
                        stopTimer(resets: false);
                        positionStream.pause();
                      } else {
                        startTimer(resets: false);
                        positionStream.resume();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kBodyForegroundColor,
                        elevation: 0.0,
                        shadowColor: Colors.transparent),
                    child: Text(
                      isRunning ? "pause" : "Resume",
                      style: const TextStyle(color: kForegroundColor),
                    )),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      stopTimer();
                      addDetails();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kBodyForegroundColor,
                        elevation: 0.0,
                        shadowColor: Colors.transparent),
                    child: const Text(
                      "Stop",
                      style: TextStyle(color: kForegroundColor),
                    )),
              )
            ],
          )
        : Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      startTimer();
                      getLatLong();
                      newSpeed();
                      checkService();
                      getCurrentTAD();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: kBodyForegroundColor,
                      elevation: 0.0,
                    ),
                    child: const Text(
                      "Start",
                      style: TextStyle(color: kForegroundColor),
                    )),
              ),
            ],
          );
  }

  final Completer<GoogleMapController> _controller = Completer();

  cameraPosition() {
    CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(getLat, getLong),
      zoom: 8,
      tilt: 50.0,
    );
    return _initialCameraPosition;
  }

  myCameraPosition() {
    CameraPosition _myCameraPosition = CameraPosition(
      target: LatLng(getLat, getLong),
      zoom: 22,
      tilt: 50.0,
    );
    return _myCameraPosition;
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(getLat, getLong),
        zoom: 18,
        tilt: 50.0,
      )),
    );
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference details = FirebaseFirestore.instance.collection(
      (FirebaseAuth.instance.currentUser?.uid == null)
          ? "default"
          : FirebaseAuth.instance.currentUser!.uid);

  void addDetails() async {
    await details
        .add({
          'distance': updatedDistance,
          'speed': speedData
              .reduce((value, element) => value > element ? value : element),
          'time': time,
          'steps': steps,
          'currentDate': _currentDate,
          'currentTime': _currentTime,
        })
        .then((value) => print('successfully added $speedData, $updatedDistance '))
        .catchError((error) {
          print('$error');
        });
  }

  void getDetails() async {
    List itemList = [];
    try {
      await details.get().then((value) => value.docs.forEach((element) {
            itemList.add(element.data);
          }));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Map<PolylineId, Polyline> polylines = {};

  void getDirections() async {
    PolylinePoints polylinePoints = PolylinePoints();
    String googleApiKey = "AIzaSyDeFZhOLtYq5pcyWev72P-oRajtcFZmbJY";
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(initialLat, initialLong),
        PointLatLng(getLat, getLong));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    addPolyline(polylineCoordinates);
  }

  addPolyline(List<LatLng> polyLineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline =
        Polyline(polylineId: id, color: Colors.deepPurpleAccent, width: 8);
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
        future: getLatLong(),
        builder: (context, data) {
          if (data.hasData) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      height: 500,
                      child: Card(
                        child: GoogleMap(
                          zoomControlsEnabled: false,
                          initialCameraPosition: cameraPosition(),
                          markers: {
                            Marker(
                                markerId: const MarkerId('_kGooglePlex'),
                                infoWindow:
                                    const InfoWindow(title: 'Current position'),
                                icon: BitmapDescriptor.defaultMarker,
                                position: LatLng(getLat, getLong)),
                          },
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          polylines: Set<Polyline>.of(polylines.values),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100.0,
                            color: kBodyForegroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Steps',
                                    style: TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kSmallFont),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '$steps steps',
                                    style: const TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kBigFont),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Container(
                            height: 100.0,
                            color: kBodyForegroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Distance',
                                    style: TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kSmallFont),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${_trip.toString().substring(0, 3)} meters',
                                    style: const TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kBigFont),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100.0,
                            color: kBodyForegroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Speed',
                                    style: TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kSmallFont),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${_speed.toString().substring(0, 3)} kmph',
                                    style: const TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kBigFont),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Container(
                            height: 100.0,
                            color: kBodyForegroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Time',
                                    style: TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kSmallFont),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  buildTime(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    buildButtons(),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _goToMyLocation,
                child: const Icon(Icons.gps_fixed),
              ),
              backgroundColor: kBaseColor,
            );
          } else {
            return const SafeArea(
              child: Scaffold(
                  backgroundColor: kBackgroundColor,
                  bottomNavigationBar: LinearProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
