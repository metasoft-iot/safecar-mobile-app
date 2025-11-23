import 'package:equatable/equatable.dart';

abstract class WorkshopsEvent extends Equatable {
  const WorkshopsEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkshops extends WorkshopsEvent {
  const LoadWorkshops();
}

class LoadWorkshopById extends WorkshopsEvent {
  final int workshopId;

  const LoadWorkshopById({required this.workshopId});

  @override
  List<Object?> get props => [workshopId];
}

