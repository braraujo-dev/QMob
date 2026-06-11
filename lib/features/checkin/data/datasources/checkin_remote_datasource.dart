import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/capital_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class CheckinRemoteDataSource {
  Future<CapitalEntity> getCapitalData(String cityName);
  Future<List<String>> getAllCapitalsNames();
}

class CheckinRemoteDataSourceImpl implements CheckinRemoteDataSource {
  final SupabaseClient supabaseClient;

  CheckinRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<String>> getAllCapitalsNames() async {
    final response = await supabaseClient.from('capitals').select('city_name').order('city_name');

    return (response as List).map((e) => e['city_name'] as String).toList();
  }

  @override
  Future<CapitalEntity> getCapitalData(String cityName) async {
    final response = await supabaseClient
        .from('capitals')
        .select()
        .eq('city_name', cityName)
        .single();

    return CapitalEntity(
      cityName: response['city_name'],
      coords: LatLng(response['latitude'], response['longitude']),
      radius: (response['radius_meters'] as num).toDouble(),
    );
  }
}
