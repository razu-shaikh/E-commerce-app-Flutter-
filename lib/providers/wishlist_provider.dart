import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class WishListProvider with ChangeNotifier {

  addWishListData({
    String? wishListId,
    String? wishListName,
    var wishListPrice,
    String? wishListImage,
    int? wishListQuantity,
  }) {
    FirebaseFirestore.instance
        .collection("wishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("yourWishList")
        .doc(wishListId)
        .set({
      "wishListId": wishListId,
      "wishListName": wishListName,
      "wishListImage": wishListImage,
      "wishListPrice": wishListPrice,
      "wishListQuantity": wishListQuantity,
      "wishList": true,
    });
  }

///// Get WishList Data ///////
  List<ProductModel> wishList = [];

  getWishtListData() async {
    List<ProductModel> newList = [];
    QuerySnapshot value = await FirebaseFirestore.instance
        .collection("wishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("yourWishList")
        .get();
    for (var element in value.docs) {
        ProductModel productModel = ProductModel(
          productId: element.get("wishListId"),
          productImage: element.get("wishListImage"),
          productName: element.get("wishListName"),
          productPrice: element.get("wishListPrice"),
          productQuantity: element.get("wishListQuantity"),
          productUnit: [],
        );
        newList.add(productModel);
      }
    wishList = newList;
    notifyListeners();
  }

  List<ProductModel> get getWishList {
    return wishList;
  }


////////// Delete WishList /////
  deleteWishtList(wishListId){
    FirebaseFirestore.instance
        .collection("wishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("yourWishList").doc(wishListId).delete();
  }
}