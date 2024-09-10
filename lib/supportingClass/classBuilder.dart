import 'package:fauna/home/baseTabbarClass.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/home/petLists.dart';
import 'package:flutter/material.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<TabBarController>(() => TabBarController());
    register<HomeClass>(() => HomeClass());
    register<BreederslistClass>(() => BreederslistClass());
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}
