// Events
abstract class AllStationEvent {}

class FetchStationsEvent extends AllStationEvent {
  final String searchQuery;
  final String type; // 'src' or 'dst'

  FetchStationsEvent({
    required this.searchQuery,
    required this.type,
  });
}

class ClearStationsEvent extends AllStationEvent {}