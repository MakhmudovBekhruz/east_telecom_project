
import 'package:east_telecom_project/bloc/map/map_cubit.dart';
import 'package:east_telecom_project/ui/map/map_search_bar.dart';
import 'package:east_telecom_project/utils/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<MapCubit>();
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        if (state is MapShowPlaceInfo) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: googlePlex,
                  onMapCreated: (controller) {
                    cubit.mapController = controller;
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: Set.from(cubit.markersList),
                  polylines: Set.from(cubit.polyline),
                ),
                Positioned(
                  top: 10.0,
                  right: 15.0,
                  left: 15.0,
                  child: Column(
                    children: <Widget>[
                      const MapSearchBar(
                        placeType: PlaceType.FROM,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const MapSearchBar(
                        placeType: PlaceType.TO,
                      ),
                      TextButton(
                        onPressed: cubit.showRouting,
                        child: const Text("Calculate route"),
                      )
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Prediction? p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: apiKey,
                    mode: Mode.overlay,
                    language: "en",
                    types: [],
                    strictbounds: false,
                    onError: (value) {
                      print(value.errorMessage);
                    },
                    components: []);

                cubit.displayPrediction(p, PlaceType.DEFAULT);
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
