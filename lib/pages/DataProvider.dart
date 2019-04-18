import 'package:flutter/material.dart';
import 'package:zigma2/pages/advert.dart';
import './user.dart';

class DataProvider extends InheritedWidget {
  final AdvertList advertList;
  final UserMethodBody user;
  DataProvider({Key key, this.advertList, this.user, Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static DataProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DataProvider) as DataProvider;
  }

  @override
  bool updateShouldNotify(DataProvider old) {
    return true;
  }

}