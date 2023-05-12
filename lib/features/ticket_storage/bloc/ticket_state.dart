part of 'ticket_bloc.dart';

@immutable
abstract class TicketState {}

class TicketInitial extends TicketState {}

class AddedTicketState extends TicketState {
  final String url;

  AddedTicketState({required this.url});
}

class LoadingTicketState extends TicketState {
  final int fileSize;
  final int currentFileSize;

  LoadingTicketState({
    required this.fileSize,
    required this.currentFileSize,
  });
}
