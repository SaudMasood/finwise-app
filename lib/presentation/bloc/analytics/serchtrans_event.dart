import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadSearchData extends SearchEvent {
  const LoadSearchData();
}

class PerformSearch extends SearchEvent {
  final String searchText;
  final String category;
  final DateTime? date;
  final String type;

  const PerformSearch({
    required this.searchText,
    required this.category,
    required this.date,
    required this.type,
  });

  @override
  List<Object?> get props => [
    searchText,
    category,
    date,
    type,
  ];
}