part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitialState extends MapState {
  const MapInitialState();

  @override
  List<Object> get props => [];
}

class MapShowPlaceInfo extends MapState {
  final String message;

  const MapShowPlaceInfo(this.message);
}

class ShowRouting extends MapState {
  const ShowRouting();
}
