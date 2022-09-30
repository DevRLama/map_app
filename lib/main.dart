import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.901705, 80.973952),
    zoom: 14.4746,
  );


  TextEditingController textController = TextEditingController();
  String location='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (cameraPosition)async{
              _kGooglePlex = cameraPosition;
            },
            onCameraIdle: () async {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                _kGooglePlex.target.latitude,
                _kGooglePlex.target.longitude,
              );

              // update the ui with the address
              textController.text =
              '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';

              print('${textController.text}');
              setState(() {
                textController;
              });
            },
          ),
          Center(
            child: Icon(
              Icons.location_on_rounded,
              color: Colors.red,
              size: 42,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 30),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  isDense: true,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: Colors.black12,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: Colors.black12,
                    ),
                  ),
                  border: OutlineInputBorder()
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, {'lat':_kGooglePlex.target.latitude,'long': _kGooglePlex.target.longitude});

        },
        child: Icon(Icons.check),
      ),
    );
  }
}