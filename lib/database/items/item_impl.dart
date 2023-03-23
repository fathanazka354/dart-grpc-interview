import 'package:grpc_tutorial/database/data.dart';
import 'package:grpc_tutorial/database/items/item_interface.dart';
import 'package:grpc_tutorial/helper/helper_method.dart';

import '../../src/generated/groceries.pbgrpc.dart';

final itemsServices = IItemsServices();

class ItemsServices implements IItemsServices {
  @override
  Item createItem(Item item) {
    items
        .add({'id': item.id, 'name': item.name, 'categoryId': item.categoryId});
    return item;
  }

  @override
  Empty deleteItem(Item item) {
    items.removeWhere((element) => element['id'] == item.id);
    return Empty();
  }

  @override
  Item editItem(Item item) {
    try {
      var itemIndex = items.indexWhere((element) => element['id'] == item.id);
      categories[itemIndex]['name'] = item.name;
    } catch (e) {
      print('🔴 ERROR:: $e');
    }
    return item;
  }

  @override
  Item getItemByName(String name) {
    var item = Item();
    var result = items.where((element) => element['name'] == name).toList();
    if (result.isNotEmpty) {
      item = helper.getItemFromMap(result.first);
    }
    return item;
  }

  @override
  List<Item> getItems() {
    return items.map((item) {
      return helper.getItemFromMap(item);
    }).toList();
  }

  @override
  Item getItemById(int id) {
    var item = Item();
    var result = items.where((element) => element['id'] == id).toList();
    if (result.isNotEmpty) {
      item = helper.getItemFromMap(result.first);
    }
    return item;
  }

  @override
  List<Item> getItemsByCategory(int categoryId) {
    var result = <Item>[];
    var jsonList =
        items.where((element) => element['categoryId'] == categoryId).toList();
    result = jsonList.map((item) => helper.getItemFromMap(item)).toList();
    return result;
  }
}
