import 'dart:io';
import 'dart:math';
import 'package:grpc/grpc.dart';
import 'package:grpc_tutorial/src/generated/groceries.pbgrpc.dart';

class Client {
  ClientChannel channel;
  GroceriesServiceClient stub;
  var response;
  bool executionInProgress = true;

  Future<void> main() async {
    channel = ClientChannel('localhost',
        port: 50000,
        options: // No credentials in this example
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

    stub = GroceriesServiceClient(channel,
        options: CallOptions(timeout: Duration(seconds: 30)));

    while (executionInProgress) {
      try {
        print('---- Welcome to the dart store API ---');
        print('   ---- what do you want to do ---');
        print('👉 1: Liat semua hewan/benda/buah');
        print('👉 2: Tambah hewan/benda/buah baru');
        print('👉 3: Update hewan/benda/buah');
        print('👉 4: Mendapatkan hewan/benda/buah berdasarkan nama');
        print('👉 5: Hapus hewan/benda/buah \n');
        print('👉 6: Liat semua kategori');
        print('👉 7: Tambah kategori baru');
        print('👉 8: Update kategory');
        print('👉 9: Mendapatkan kategory berdasarkan nama');
        print('👉 10: Hapus kategory \n');
        print('👉 11: Mendapatkan semua kategory');

        var option = int.parse(stdin.readLineSync());

        switch (option) {
          case 1:
            response = await stub.getAllItems(Empty());
            print(' --- Daftar --- ');
            response.items.forEach((item) {
              print(
                  '✅: ${item.name} (id: ${item.id} | categoryId: ${item.categoryId})');
            });
            break;
          case 2:
            print('Masukkan nama barang/hewan/benda');
            var name = stdin.readLineSync();
            var item = await _findItemByName(name);
            if (item.id != 0) {
              print(
                  '🔴 product already exists: name ${item.name} | id: ${item.id} ');
            } else {
              print('Enter product\'s category name');
              var categoryName = stdin.readLineSync();
              var category = await _findCategoryByName(categoryName);
              if (category.id == 0) {
                print(
                    '🔴 category $categoryName does not exists, try creating it first');
              } else {
                item = Item()
                  ..name = name
                  ..id = _randomId()
                  ..categoryId = category.id;
                response = await stub.createItem(item);
                print(
                    '✅ product created | name ${response.name} | id ${response.id} | category id ${response.categoryId}');
              }
            }

            break;

          case 3:
            print('Masukkan nama barang/hewan/benda');
            var name = stdin.readLineSync();
            var item = await _findItemByName(name);
            if (item.id != 0) {
              print('Enter new product name');
              name = stdin.readLineSync();
              response = await stub.editItem(
                  Item(id: item.id, name: name, categoryId: item.categoryId));
              if (response.name == name) {
                print(
                    '✅ product updated | name ${response.name} | id ${response.id}');
              } else {
                print('🔴 product update failed 🥲');
              }
            } else {
              print('🔴 product $name not found, try creating it!');
            }
            break;
          case 4:
            print('Masukkan nama barang/hewan/benda');
            var name = stdin.readLineSync();
            var item = await _findItemByName(name);
            if (item.id != 0) {
              print(
                  '✅ product found | name ${item.name} | id ${item.id} | category id ${item.categoryId}');
            } else {
              print('🔴 product not found | no product matches the name $name');
            }
            break;
          case 5:
            print('Masukkan nama barang/hewan/benda');
            var name = stdin.readLineSync();
            var item = await _findItemByName(name);
            if (item.id != 0) {
              await stub.deleteItem(item);
              print('✅ item deleted');
            } else {
              print('🔴 product $name does not exist ');
            }

            break;
          case 6:
            response = await stub.getAllCategories(Empty());
            print(' --- Store product categories --- ');
            response.categories.forEach((category) {
              print('👉: ${category.name} (id: ${category.id})');
            });

            break;
          case 7:
            print('Enter category name');
            var name = stdin.readLineSync();
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print(
                  '🔴 category already exists: category ${category.name} (id: ${category.id})');
            } else {
              category = Category()
                ..id = Random(999).nextInt(9999)
                ..name = name;
              response = await stub.createCategory(category);
              print(
                  '✅ category created: name ${category.name} (id: ${category.id})');
            }
            break;
          case 8:
            print('Enter category name');
            var name = stdin.readLineSync();
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print('Enter new category name');
              name = stdin.readLineSync();
              response = await stub
                  .editCategory(Category(id: category.id, name: name));
              if (response.name == name) {
                print(
                    '✅ category updated | name ${response.name} | id ${response.id}');
              } else {
                print('🔴 category update failed 🥲');
              }
            } else {
              print('🔴 category $name not found, try creating it');
            }

            break;
          case 9:
            print('Enter category name');
            var name = stdin.readLineSync();
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print(
                  '✅ category found | name ${category.name} | id ${category.id}');
            } else {
              print(
                  '🔴 category not found | no category matches the name $name');
            }

            break;
          case 10:
            print('Enter category name');
            var name = stdin.readLineSync();
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              await stub.deleteCategory(category);
              print('✅ category deleted');
            } else {
              print('🔴 category $name not found ');
            }
            break;
          case 11:
            print('Enter category name');
            var name = stdin.readLineSync();
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              var _result = await stub.getItemsByCategory(category);
              print('--- all products of the $name category --- ');

              _result.items.forEach((item) {
                print('👉 ${item.name}');
              });
            } else {
              print('🔴 category $name not found');
            }

            break;
          default:
            print('invalid option 🥲');
        }
      } catch (e) {
        print(e);
      }
      print('Do you wish to exit the store (Y/n)');
      var result = stdin.readLineSync() ?? 'y';
      executionInProgress = result.toLowerCase() != 'y';
    }

    await channel.shutdown();
  }

  Future<Category> _findCategoryByName(String name) async {
    var category = Category()..name = name;
    category = await stub.getCategory(category);
    return category;
  }

  Future<Item> _findItemByName(String name) async {
    var item = Item()..name = name;
    item = await stub.getItem(item);
    return item;
  }

  int _randomId() => Random(1000).nextInt(9999);
}

main() {
  var client = Client();
  client.main();
}
