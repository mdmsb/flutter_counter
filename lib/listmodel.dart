import 'package:hive/hive.dart';

part 'listmodel.g.dart';

@HiveType(typeId: 1)
class TasbeehModel {
  TasbeehModel(
      {required this.title,
      required this.text,
      required this.target,
      required this.count});
  @HiveField(0)
  String title;

  @HiveField(1)
  String text;

  @HiveField(2)
  int target;

  @HiveField(3)
  int count;
}
