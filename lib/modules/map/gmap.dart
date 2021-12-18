import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:survival_map/modules/map/cubit/cubit.dart';
import 'package:survival_map/shared/adaptive/adaptivw_indicator.dart';
import 'package:survival_map/shared/components/constants.dart';
import 'package:survival_map/shared/cubit/cubit.dart';
import 'package:survival_map/shared/styles/colors.dart';

class GMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MapCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => cubit.currentLocation != null,
          widgetBuilder: (context) => Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(cubit.currentLocation!.latitude,
                      cubit.currentLocation!.longitude),
                  zoom: 14,
                ),
                myLocationEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                indoorViewEnabled: true,
                // trafficEnabled: true,
                onMapCreated: (GoogleMapController controller) async {
                  cubit.mapController = controller;
                  if (AppCubit.get(context).isDark!) {
                    cubit
                        .getJsonFile("assets/nightmode.json")
                        .then(cubit.setMapStyle);
                  } else {
                    cubit
                        .getJsonFile("assets/daymode.json")
                        .then(cubit.setMapStyle);
                  }
                },
                markers: cubit.markers.toSet(),
                // circles: cubit.circles.toSet(),
              ),
              // Show zoom buttons
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: defaultColor, // button color
                            child: InkWell(
                              splashColor: defaultColor.shade50,
                              // inkwell color
                              child: SizedBox(
                                width: 45,
                                height: 45,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                cubit.mapController!.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ClipOval(
                          child: Material(
                            color: defaultColor, // button color
                            child: InkWell(
                              splashColor: defaultColor.shade50,
                              // inkwell color
                              child: SizedBox(
                                width: 45,
                                height: 45,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                cubit.mapController!.animateCamera(
                                  CameraUpdate.zoomOut(),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Show current location button
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                    child: ClipOval(
                      child: Material(
                        color: AppCubit.get(context).isDark!
                            ? HexColor('333739')
                            : Colors.white,
                        // button color
                        child: InkWell(
                          splashColor: Colors.white70, // inkwell color
                          child: SizedBox(
                            width: 46,
                            height: 46,
                            child: Icon(
                              Icons.my_location,
                              color: AppCubit.get(context).isDark!
                                  ? Colors.white
                                  : HexColor('333739'),
                            ),
                          ),
                          onTap: () {
                            cubit.mapController!.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                    cubit.currentLocation!.latitude,
                                    cubit.currentLocation!.longitude,
                                  ),
                                  zoom: 17.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          fallbackBuilder: (context) =>
              Center(
                  child: AdaptiveIndicator(
                    os: getOS(),
                  )),
        );
      },
    );
  }
}
