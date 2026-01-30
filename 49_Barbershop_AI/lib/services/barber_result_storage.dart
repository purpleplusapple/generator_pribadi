import '../model/barber_config.dart';
import 'database_service.dart';

class BarberResultStorage {
  final DatabaseService _db = DatabaseService.instance;

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String> saveResult(BarberConfig config) async {
    final id = _generateId();
    await _db.insertResult(id, config.toJson());
    return id;
  }

  Future<BarberConfig?> loadResult(String id) async {
    final map = await _db.getResult(id);
    if (map == null) return null;
    try {
      return BarberConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  Future<List<BarberConfig?>> loadResults(List<String> ids) async {
    final List<BarberConfig?> results = [];
    for (final id in ids) {
      results.add(await loadResult(id));
    }
    return results;
  }

  Future<void> deleteResult(String id) async {
    await _db.deleteResult(id);
  }
}
