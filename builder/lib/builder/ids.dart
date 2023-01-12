import 'package:uuid/uuid.dart';

var uuid = const Uuid();

String newId() {
  return uuid.v1();
}