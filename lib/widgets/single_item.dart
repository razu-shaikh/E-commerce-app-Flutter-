import 'package:ecommerce_app/config/colors.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/providers/review_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'count.dart';
import 'product_unit.dart';

class SingleItem extends StatefulWidget {
  bool? isBool = false;
  String? productId;
  String? productImage;
  String? productName;
  bool? wishList = false;
  int? productPrice;
  int? productQuantity;
  final void Function()? onDelete;
  var productUnit;
  final ProductModel? unitProduct;

  SingleItem(
      {this.productQuantity,
        this.productId,
        this.productUnit,
        this.onDelete,
        this.isBool,
        this.productImage,
        this.productName,
        this.productPrice,
        this.wishList,
        this.unitProduct});

  @override
  _SingleItemState createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  late ReviewCartProvider reviewCartProvider;

  var unitData;
  var firstValue;

  int count=0;
  getCount() {
    setState(() {
      count = widget.productQuantity?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    widget.isBool == false ?
    widget.productUnit.productUnit.firstWhere((element) {
      setState(() {
        firstValue = element;
      });
      return true;
    }):

    getCount();
    reviewCartProvider = Provider.of<ReviewCartProvider>(context);
    reviewCartProvider.getReviewCartData();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 90,
                  child: Center(
                    child: Image.network(
                      widget.productImage??"",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: widget.isBool == false ?
                        MainAxisAlignment.spaceAround
                        : MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productName??"",
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            "${widget.productPrice}\$",
                            style: TextStyle(
                                color: textColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      widget.isBool == false ?
                      ProductUnit(
                          onTap: () {
                             showModalBottomSheet(
                               context: context,
                                 builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: widget.productUnit.productUnit.map<Widget>((data) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric( vertical: 10, horizontal: 10),
                                              child: InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    unitData = data;
                                                  });
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                                child: Text(
                                                  data,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  });
                            },
                            title: unitData ?? firstValue,
                          )
                          : Text(widget.productUnit??""),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 90,
                  padding: widget.isBool == false
                      ? EdgeInsets.symmetric(horizontal: 15, vertical: 32)
                      : EdgeInsets.only(left: 15, right: 15),
                  child: widget.isBool == false ?
                  Count(
                    productId: widget.productId,
                    productImage: widget.productImage,
                    productName: widget.productName,
                    productPrice: widget.productPrice,
                    productUnit: unitData ?? firstValue,

                  )
                      : Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: widget.onDelete,
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        widget.wishList == false ?
                        Container(
                          height: 25,
                          width: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (count == 1) {
                                      Fluttertoast.showToast(
                                        msg:
                                        "You reach minimum limit",);
                                    } else {
                                      setState(() {
                                        count--;
                                      });
                                      reviewCartProvider.updateReviewCartData(
                                        cartId: widget.productId,
                                        cartImage: widget.productImage,
                                        cartName: widget.productName,
                                        cartPrice: widget.productPrice,
                                        cartQuantity: count,
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  "$count",
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (count < 10) {
                                      setState(() {
                                        count++;
                                      });
                                      reviewCartProvider.updateReviewCartData(
                                        cartId: widget.productId,
                                        cartImage: widget.productImage,
                                        cartName: widget.productName,
                                        cartPrice: widget.productPrice,
                                        cartQuantity: count,
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        widget.isBool == false ?
        Container(
            child:Divider(
              height: 1,
              color: Colors.black45,
            )
        )
            : Divider(
          height: 1,
          color: Colors.black45,
        )
      ],
    );
  }
}