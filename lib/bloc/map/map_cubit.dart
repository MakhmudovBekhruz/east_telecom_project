import 'package:bloc/bloc.dart';
import 'package:east_telecom_project/utils/globals.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

part 'map_state.dart';

enum PlaceType { FROM, TO, DEFAULT }

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapInitialState()) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
  }

  late final GoogleMapController mapController;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: apiKey);
  final List<Polyline> polyline = [];
  List<LatLng> routeCoords = [];
  List<Marker> markersList = [];
  late PlaceDetails from;
  late PlaceDetails to;

  Future<void> displayPrediction(Prediction? p, PlaceType placeType) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      switch (placeType) {
        case PlaceType.FROM:
          from = detail.result;
          fromController.text = detail.result.name;
          Marker marker = Marker(
              markerId: const MarkerId('fromMarker'),
              draggable: false,
              infoWindow: InfoWindow(
                title: p.description ?? '',
              ),
              onTap: () {
                emit(MapShowPlaceInfo("Lat/Long : ($lat, $lng)"));
              },
              position: LatLng(lat, lng));
          markersList.add(marker);
          break;
        case PlaceType.TO:
          to = detail.result;
          toController.text = detail.result.name;
          Marker marker = Marker(
              markerId: const MarkerId('toMarker'),
              draggable: false,
              infoWindow: InfoWindow(
                title: p.description ?? '',
              ),
              onTap: () {
                emit(MapShowPlaceInfo("Lat/Long : ($lat, $lng)"));
              },
              position: LatLng(lat, lng));
          markersList.add(marker);
          break;
        case PlaceType.DEFAULT:
          Marker marker = Marker(
              markerId: const MarkerId('toMarker'),
              draggable: false,
              infoWindow: InfoWindow(
                title: p.description,
              ),
              onTap: () {
                emit(MapShowPlaceInfo("Lat/Long : ($lat, $lng)"));
              },
              position: LatLng(lat, lng));
          markersList.add(marker);
          break;
      }
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 20.0)));
    }
  }

  showRouting() async {
    if (from.geometry == null || to.geometry == null) {
      emit(const MapShowPlaceInfo("You need to select from/to locations"));
      return;
    }
    LatLng origin =
        LatLng(from.geometry!.location.lat, from.geometry!.location.lng);
    LatLng end = LatLng(to.geometry!.location.lat, to.geometry!.location.lng);
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(end.latitude, end.longitude),
    );
    var points = result.points;
    routeCoords.clear();
    routeCoords
        .addAll(points.map((e) => LatLng(e.latitude, e.longitude)).toList());

    polyline.add(Polyline(
        polylineId: const PolylineId("test"),
        visible: true,
        points: routeCoords,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap));
    emit(const ShowRouting());
  }
}
