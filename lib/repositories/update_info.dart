import 'package:babycareai/models/update_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateInfoRepository {
  final SupabaseClient _client;
  final String _appId;

  UpdateInfoRepository(this._client, this._appId);

  Future<UpdateInfo?> getLatestUpdateInfo() async {
    final response = await _client
        .from('update_info')
        .select()
        .eq('app_id', _appId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    if (response == null) return null;
    return UpdateInfo.fromJson(response);
  }
}
