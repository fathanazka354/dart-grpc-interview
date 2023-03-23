import 'package:grpc_tutorial/database/items/item_impl.dart';

import '../../src/generated/groceries.pbgrpc.dart';

abstract class IItemsServices {
  factory IItemsServices() => ItemsServices();
  Item getItemByName(String name) {}
  Item getItemById(int id) {}
  Item createItem(Item item) {}
  Item editItem(Item item) {}
  Empty deleteItem(Item item) {}
  List<Item> getItems() {}
  List<Item> getItemsByCategory(int categoryId) {}
}
