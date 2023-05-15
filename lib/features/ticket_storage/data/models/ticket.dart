// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'ticket.g.dart';

@HiveType(typeId: 1)
class Ticket {
  @HiveField(0)
  String url;

  Ticket({
    required this.url,
  });
}
