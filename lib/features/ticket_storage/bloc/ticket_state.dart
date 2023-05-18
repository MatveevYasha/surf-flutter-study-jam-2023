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
  final Future<File>? path;

  LoadingTicketState({
    required this.fileSize,
    required this.currentFileSize,
    required this.index,
    this.path,
  });
}

class DeleteTicketState extends TicketState {
  final int index;

  DeleteTicketState({required this.index});
}
