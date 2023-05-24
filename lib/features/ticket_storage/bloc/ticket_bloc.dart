import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:surf_flutter_study_jam_2023/main.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketInitial()) {
    on<AddTicketEvent>(_addTicket);
    on<LoadingTicketEvent>(_loading);
    on<DeleteTicketEvent>(_delete);
  }

  FutureOr<void> _addTicket(AddTicketEvent event, emit) async {
    emit(AddedTicketState(url: event.url));
  }

  FutureOr<void> _loading(LoadingTicketEvent event, emit) async {
    int fileSize = 0;
    // ignore: unused_local_variable
    final response = await dio.get(
      event.url,
      onReceiveProgress: (count, total) {
        fileSize = total;
        emit(LoadingTicketState(
          currentFileSize: count.toDouble(),
          fileSize: total,
          index: event.index,
        ));
      },
    );
    emit(LoadingTicketState(
      currentFileSize: fileSize.toDouble(),
      fileSize: fileSize,
      index: event.index,
    ));
  }

  FutureOr<void> _delete(DeleteTicketEvent event, emit) async {
    emit(DeleteTicketState(index: event.index));
  }
}
