part of 'cubit.dart';

@immutable
abstract class MapStates {}

class MapInitial extends MapStates {}
class MapChangeBottomNavBarState extends MapStates {}

class MapChangeMapState extends MapStates {}
class MapCurrentLocationState extends MapStates {}

class MapChangeLocationState extends MapStates {}

class MapAddLocationSuccessState extends MapStates {}

class MapGetLocationSuccessState extends MapStates {}

class MapAddLocationErrorState extends MapStates {}
