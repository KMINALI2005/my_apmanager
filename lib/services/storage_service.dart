import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/debt_model.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/debts.json');
  }

  Future<List<Debt>> readDebts() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return []; // إذا لم يكن الملف موجودًا، أرجع قائمة فارغة
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((json) => Debt.fromJson(json)).toList();
    } catch (e) {
      print("Error reading debts: $e");
      return [];
    }
  }

  Future<File> writeDebts(List<Debt> debts) async {
    final file = await _localFile;
    final jsonList = debts.map((debt) => debt.toJson()).toList();
    return file.writeAsString(json.encode(jsonList));
  }
}
