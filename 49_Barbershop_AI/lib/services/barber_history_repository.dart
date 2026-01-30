import 'database_service.dart';
import 'barber_result_storage.dart';

class BarberHistoryRepository {
  final DatabaseService _db = DatabaseService.instance;
  final BarberResultStorage _storage = BarberResultStorage();

  Future<List<String>> getHistoryIds() async {
    return await _db.getHistoryIds();
  }

  Future<void> removeFromHistory(String id) async {
    await _storage.deleteResult(id);
  }

  Future<void> clearHistory() async {
    await _db.clearAll();
  }
}
