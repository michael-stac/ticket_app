import 'package:flutter/material.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}

class StateModel {
  PageController controller;

  StateModel(this.controller);
}