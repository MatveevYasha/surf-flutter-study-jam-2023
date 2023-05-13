import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:surf_flutter_study_jam_2023/main.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketInitial()) {
    on<AddTicketEvent>(_addTicket);
    on<LoadingTicketEvent>(_loading);
  }

  FutureOr<void> _addTicket(AddTicketEvent event, emit) async {
    emit(AddedTicketState(url: event.url));
  }

// здесь сделать стрим
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
            index: event.index));
      },
    );
    emit(LoadingTicketState(
        currentFileSize: fileSize.toDouble(),
        fileSize: fileSize,
        index: event.index));
  }
}
