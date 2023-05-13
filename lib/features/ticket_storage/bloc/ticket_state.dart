// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final double currentFileSize;
  final int index;

  LoadingTicketState({
    required this.fileSize,
    required this.currentFileSize,
    required this.index,
  });
}
