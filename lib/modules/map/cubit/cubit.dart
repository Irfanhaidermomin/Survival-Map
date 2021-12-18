import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:survival_map/shared/components/componets.dart';

part 'state.dart';

class MapCubit extends Cubit<MapStates> {
  MapCubit() : super(MapInitial());

  static MapCubit get(context) => BlocProvider.of(context);

  // Variables
  Position? currentLocation;

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  setCurrentLocation() async {
    currentLocation = await getCurrentLocation();
    emit(MapCurrentLocationState());
  }
  GoogleMapController? mapController;

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController!.setMapStyle(mapStyle);
    emit(MapChangeMapState());
  }
  bool infected = false;
  Position? currentPosition;
  Position? previousPosition;

  // ignore: cancel_subscriptions
  StreamSubscription<Position>? positionStream;
  double totalDistance = 0;
  List<Position> locations = [];

  Future storeAndCalculateDistance() async {
    positionStream = Geolocator.getPositionStream(
      distanceFilter: 5,
      desiredAccuracy: LocationAccuracy.high,
      intervalDuration: Duration(seconds: 15),
    ).listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          currentPosition = position;
          locations.add(currentPosition!);
          if (locations.length > 1) {
            previousPosition = locations.elementAt(locations.length - 2);
            var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
              previousPosition!.latitude,
              previousPosition!.longitude,
              currentPosition!.latitude,
              currentPosition!.longitude,
            );
            totalDistance += _distanceBetweenLastTwoLocations;
            print('Total Distance: $totalDistance');
            print('currentPosition: $currentPosition');
            print('previousPosition: $previousPosition');

            // To Store location in data base
            if (infected == true && totalDistance > 1) {
              FirebaseFirestore.instance.collection('Users_Location').add({
                'name': 'Corona',
                'location': GeoPoint(
                    currentPosition!.latitude, currentPosition!.longitude)
              }).then((value) {
                emit(MapAddLocationSuccessState());
                print('add succs');
              }).catchError((error) {
                emit(MapAddLocationErrorState());
              });
            }
          }
        }).catchError((err) {
          print(err);
        });
      } else {
        print("GPS is off.");
        showToast(
            text: 'Make sure your GPS is on in Settings !',
            state: ToastStates.WARNING);
      }
    });
  }

  // void storeUserLocation() async{
  //
  //     if (infected == true && totalDistance > 1) {
  //       await FirebaseFirestore.instance.collection('Users_Location').add({
  //         'name': 'Corona',
  //         'location':
  //             GeoPoint(previousPosition.latitude, previousPosition.longitude)
  //       }).then((value) {
  //         emit(MapAddLocationSuccessState());
  //       }).catchError((error) {
  //         emit(MapAddLocationErrorState());
  //       });
  //     }
  // }

  List<Marker> markers = [];
  Set<Circle> circles = HashSet<Circle>();

  void getUserLocation() {
    FirebaseFirestore.instance
        .collection('Users_Location')
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((change) {
        markers.add(
          Marker(
            markerId: MarkerId(change.doc.id),
            infoWindow: InfoWindow(
              title: change.doc.data()!['name'].toString(),
            ),
            position: LatLng(change.doc.data()!['location'].latitude,
                change.doc.data()!['location'].longitude),
          ),
        );
        //to make a circle
        // circles.add(
        //   Circle(
        //       circleId: CircleId(change.doc.id),
        //       center: LatLng(change.doc.data()['location'].latitude,
        //           change.doc.data()['location'].longitude),
        //       radius: 20,
        //       strokeWidth: 2,
        //       fillColor: Colors.red[400]),
        // );
      });
      emit(MapGetLocationSuccessState());
    });
  }
}
