import 'package:flutter/cupertino.dart';

class CategoryModel with ChangeNotifier {
  String categoryId;
  String name;
  String? image;
  String? coverimage;
  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.coverimage,
    this.image,
  });
}
