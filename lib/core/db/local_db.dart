import 'package:sqflite/sqflite.dart';

abstract class LocalDb {
  Future<void> initDb();
  Database getDb(); 
  Future<void> cleanDb();
}