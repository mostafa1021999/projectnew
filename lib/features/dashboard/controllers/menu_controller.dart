import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/dashboard/domain/tab_type_enum.dart';
import 'package:six_pos/features/home/screens/home_screens.dart';
import 'package:six_pos/features/pos/screens/pos_screen.dart';
import 'package:six_pos/features/product/screens/limited_stock_product_screen.dart';
import 'package:six_pos/features/category/screens/category_product_list_screen.dart';

class BottomManuController extends GetxController implements GetxService{
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;
  final List<Widget> _screen = [
    const HomeScreen(),
    const PosScreen(),
    const CategoryProductListScreen(),
    const LimitedStockProductScreen()
  ];

  List<Widget> get screen => _screen;

  void onChangeMenu({required NavbarType type}) {
    _currentTabIndex = _getPageIndex(type);
    update();
  }

  int _getPageIndex(NavbarType type) {
    switch(type) {
      case NavbarType.dashboard:
        return 0;
      case NavbarType.pos:
        return 1;
      case NavbarType.items:
        return 2;
      case NavbarType.limitedStock:
        return 3;
    }
  }
}
