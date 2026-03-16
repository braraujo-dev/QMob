import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/capital_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class CheckinRemoteDataSource {
  Future<CapitalEntity> getCapitalData(String cityName);
}

class CheckinRemoteDataSourceImpl implements CheckinRemoteDataSource {
  final SupabaseClient supabaseClient;

  CheckinRemoteDataSourceImpl(this.supabaseClient);

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
