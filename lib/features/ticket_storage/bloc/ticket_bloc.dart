import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
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
          index: event.index,
        ));
      },
    );

    // Completer<File> completer = Completer();
    // print("Start download file from internet!");

    // // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
    // // final url = "https://pdfkit.org/docs/guide.pdf";
    // final url = event.url;
    // final filename = url.substring(url.lastIndexOf("/") + 1);
    // var request = await HttpClient().getUrl(Uri.parse(url));
    // var responseOne = await request.close();
    // var bytes = await consolidateHttpClientResponseBytes(responseOne);
    // var dir = await getApplicationDocumentsDirectory();
    // print("Download files");
    // print("${dir.path}/$filename");
    // File file = File("${dir.path}/$filename");
    // print('1');
    // await file.writeAsBytes(bytes, flush: true);
    // print('2');
    // completer.complete(file);
    // print('3');
    // // Future<File> str = completer.future;
    // completer.future.then((f) {
    //   string = f.path;
    // });
    // print('4');
    // print(string);
    // // var dir = await getTemporaryDirectory();
    // // File file = File('${dir.path}/data.pdf');
    // // await file.writeAsString(response.data, flush: true);
    // // print(file);
    // // String str = file.path;
    // print('5');
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
