import 'package:equatable/equatable.dart';
import '../domain/model/workshop.entity.dart';

abstract class WorkshopsState extends Equatable {
  const WorkshopsState();

  @override
  List<Object?> get props => [];
}

class WorkshopsInitial extends WorkshopsState {
  const WorkshopsInitial();
}

class WorkshopsLoading extends WorkshopsState {
  const WorkshopsLoading();
}

class WorkshopsLoaded extends WorkshopsState {
  final List<Workshop> workshops;

  const WorkshopsLoaded({required this.workshops});

  @override
  List<Object?> get props => [workshops];
}

class WorkshopDetailLoaded extends WorkshopsState {
  final Workshop workshop;
  final List<Workshop> allWorkshops;

  const WorkshopDetailLoaded({
    required this.workshop,
    required this.allWorkshops,
  });

  @override
  List<Object?> get props => [workshop, allWorkshops];
}

class WorkshopsError extends WorkshopsState {
  final String message;

  const WorkshopsError({required this.message});

  @override
  List<Object?> get props => [message];
}

