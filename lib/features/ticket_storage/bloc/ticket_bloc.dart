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
    // final response = await dio.get(event.url);
    emit(AddedTicketState(url: event.url));
  }

// здесь сделать стрим
  FutureOr<void> _loading(LoadingTicketEvent event, emit) async {
    int totall = 0;
    print('1');
    final response = await dio.get(
      event.url,
      onReceiveProgress: (count, total) {
        print('2');
        totall = total;
        double value = (count / total);
        emit(LoadingTicketState(
            currentFileSize: count.toDouble(),
            fileSize: total,
            index: event.index));
      },
    );
    print('3');
    emit(LoadingTicketState(
        currentFileSize: totall.toDouble(),
        fileSize: totall,
        index: event.index));
  }
}
