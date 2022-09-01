import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ipoll_application/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> get getCategoryData {
    return _categoryData;
  }

  // List<QuestionModel> get getOnSaleProducts {
  //   return _questionBank.where((element) => element.categ).toList();
  // }

  CategoryModel findCategoryById(String specificId) {
    return _categoryData
        .firstWhere((element) => element.categoryId == specificId);
  }

  List<CategoryModel> _categoryData = [
    // CategoryModel(
    //     categoryId: '1',
    //     coverimage:
    //         'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1307&q=80',
    //     name: 'Sports',
    //     image:
    //         'https://firebasestorage.googleapis.com/v0/b/ipoll-da231.appspot.com/o/sports(1).png?alt=media&token=98dd2beb-e275-4b7b-b9a9-c8dfdac10575'),
    // CategoryModel(
    //   categoryId: '2',
    //   name: 'Bollywood',
    //   coverimage:
    //       'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8ZmlsbXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
    //   image:
    //       'https://firebasestorage.googleapis.com/v0/b/groceryapp-50684.appspot.com/o/3da97051d081aad894cfc434d6e30ad9.jpg?alt=media&token=13c6803e-f437-4c21-b3cc-fb6457033fa8',
    // ),
    // CategoryModel(
    //   categoryId: '3',
    //   name: 'Crypto',
    //   coverimage:
    //       'https://images.unsplash.com/photo-1624996379697-f01d168b1a52?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y3J5cHRvfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
    //   image:
    //       'https://firebasestorage.googleapis.com/v0/b/groceryapp-50684.appspot.com/o/crypto.png?alt=media&token=c5cfb152-44a1-40b4-95e4-1ad4d93a773e',
    // ),
    // CategoryModel(
    //   categoryId: '4',
    //   name: 'Cricket',
    //   coverimage:
    //       'ttps://images.unsplash.com/photo-1594470117722-de4b9a02ebed?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1429&q=80',
    //   image:
    //       'https://firebasestorage.googleapis.com/v0/b/groceryapp-50684.appspot.com/o/fifa.png?alt=media&token=9933e469-9e23-44b3-8f68-353e6b34f239',
    // ),
    // CategoryModel(
    //   categoryId: '5',
    //   name: 'Politics',
    //   coverimage:
    //       'https://images.unsplash.com/photo-1555848962-6e79363ec58f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1433&q=80',
    //   image:
    //       'https://firebasestorage.googleapis.com/v0/b/groceryapp-50684.appspot.com/o/1fa649dbd70ffcd682e3657539004cbb.jpg?alt=media&token=85cb3fa5-2239-41c5-b8f3-b931f694ce84',
    // ),
    // CategoryModel(
    //   categoryId: '6',
    //   name: 'General',
    //   coverimage:
    //       'https://images.unsplash.com/photo-1461088945293-0c17689e48ac?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
    //   image:
    //       'https://firebasestorage.googleapis.com/v0/b/groceryapp-50684.appspot.com/o/9582615a3da6dc4f975058e2ead4876a.jpg?alt=media&token=e661a069-e397-4fd1-8053-8dc348c3172f',
    // ),
  ];

  Future<void> fetchCategories() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((QuerySnapshot allCategorySnapshot) {
      _categoryData = [];
      for (var element in allCategorySnapshot.docs) {
        _categoryData.insert(
            0,
            CategoryModel(
              categoryId: element.get('categoryId').toString(),
              name: element.get('name'),
              coverimage: element.get('coverimage'),
              image: element.get('image'),
            ));
      }
    });
  }
}
