import 'package:flutter/material.dart';
import 'package:invoice_intern/services/auth_methods.dart';

import '../models/user_model.dart' as us;

class UserProvider with ChangeNotifier {
  us.User? _user;

  us.User get user => _user!;

  Future<void> refreshUser() async {
    us.User userModel = await AuthMethods().getUserDetails();
    _user = userModel;
    notifyListeners();
  }
}
