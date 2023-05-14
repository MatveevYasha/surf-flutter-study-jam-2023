// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ticket_bloc.dart';

@immutable
abstract class TicketEvent {}

class AddTicketEvent extends TicketEvent {
  final String url;

  AddTicketEvent({required this.url});
}

class LoadingTicketEvent extends TicketEvent {
  final String url;
  final int index;

  LoadingTicketEvent({
    required this.url,
    required this.index,
  });
}

class DeleteTicketEvent extends TicketEvent {
  final int index;

  DeleteTicketEvent({
    required this.index,
  });
}
