import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper {
  Database? db;

  Future<bool> createTables() async {
    try {
      var batch = db!.batch();

      batch.execute("""
  Create table if not exists Categories (
    id integer primary key,
    name text,
    description text
  )""");
      batch.execute("""
  Create table if not exists Products (
    id integer primary key,
    name text,
    description text,
    price double,
    stock integer,
    isAvailable boolean,
    image blob,
    categoryId integer
  )""");
      
      batch.execute("""
  Create table if not exists Clients (
    id integer primary key,
    name text,
    email text,
    phone text,
    address text
  )""");
  batch.execute("""
  Create table if not exists Sales (
    id integer primary key,
    clientId integer,
    productId integer
  )""");
      var result = await batch.commit();
      log('tables created successfully : $result');
      return true;
    } catch (e) {
      log('error : $e');
      return false;
    }
  }

  initDb() async {
    try {
      if (kIsWeb){
        var factory = createDatabaseFactoryFfiWeb();
        db = await factory.openDatabase('pos.db');
        log('db created');
      }else{
      db = await openDatabase(
        'pos.db',
        version: 1,
        onCreate: (db, version) => log('db created'),
      );}
    } catch (e) {
      log('error : $e');
    }
  }
}
