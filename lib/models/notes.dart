import 'package:isar/isar.dart';

// this line is needed to generate the file to store the data
// and run 'flutter pub run build_runner build'
part 'notes.g.dart';

@collection
class Notes {
  Id id = Isar.autoIncrement;
  late String text;
}