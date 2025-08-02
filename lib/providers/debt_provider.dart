import 'package:flutter/foundation.dart';
import '../models/debt_model.dart';
import '../services/storage_service.dart';

class DebtProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Debt> _debts = [];

  DebtProvider() {
    loadDebts();
  }

  List<Debt> get debts => _debts;

  // إجمالي الديون غير المسددة
  double get totalUnpaidDebt {
    return _debts
        .where((debt) => !debt.isPaid)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // إجمالي الديون المسددة
  double get totalPaidDebt {
     return _debts
        .where((debt) => debt.isPaid)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<void> loadDebts() async {
    _debts = await _storageService.readDebts();
    _debts.sort((a, b) => b.date.compareTo(a.date)); // ترتيب حسب التاريخ الأحدث أولاً
    notifyListeners();
  }

  Future<void> _saveDebts() async {
    await _storageService.writeDebts(_debts);
  }

  Future<void> addDebt(Debt debt) async {
    _debts.add(debt);
    _debts.sort((a, b) => b.date.compareTo(a.date));
    await _saveDebts();
    notifyListeners();
  }

  Future<void> updateDebt(Debt updatedDebt) async {
    final index = _debts.indexWhere((debt) => debt.id == updatedDebt.id);
    if (index != -1) {
      _debts[index] = updatedDebt;
      await _saveDebts();
      notifyListeners();
    }
  }

  Future<void> deleteDebt(String id) async {
    _debts.removeWhere((debt) => debt.id == id);
    await _saveDebts();
    notifyListeners();
  }

  Future<void> togglePaidStatus(String id) async {
    final index = _debts.indexWhere((debt) => debt.id == id);
    if (index != -1) {
      _debts[index].isPaid = !_debts[index].isPaid;
      await _saveDebts();
      notifyListeners();
    }
  }
}
