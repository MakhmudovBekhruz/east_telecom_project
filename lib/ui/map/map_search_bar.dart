import 'package:east_telecom_project/bloc/map/map_cubit.dart';
import 'package:east_telecom_project/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapSearchBar extends StatelessWidget {
  const MapSearchBar({Key? key, required this.placeType}) : super(key: key);
  final PlaceType placeType;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<MapCubit>();
    return Container(
      height: 50.0,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: placeType == PlaceType.TO ? 'To' : 'From',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 15.0, top: 15.0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                iconSize: 30.0,
                onPressed: () {},
              ),
            ),
            controller: placeType == PlaceType.TO
                ? cubit.toController
                : cubit.fromController,
            onTap: () async {
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
                components: [],
              );
              cubit.displayPrediction(p, placeType);
            },
          ),
        ],
      ),
    );
  }
}
