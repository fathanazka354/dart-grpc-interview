// ignore_for_file: missing_return

import 'package:grpc_tutorial/database/categories/categories_impl.dart';

import '../../src/generated/groceries.pbgrpc.dart';

abstract class ICategoriesServices {
  factory ICategoriesServices() => CategoriesServices();

  Category getCategoryByName(String name) {}
  Category getCategoryById(int id) {}
  Category createCategory(Category category) {}
  Category editCategory(Category category) {}
  Empty deleteCategory(Category category) {}
  List<Category> getCategories() {}
}

final categoriesServices = ICategoriesServices();
