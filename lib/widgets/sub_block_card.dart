import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SubBlockCard extends StatelessWidget {
  const SubBlockCard({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(24.785, 120.996), // 例如：新竹光復校區
            initialZoom: 15,
          ),
          children: [
            // 免費 OSM 圖磚
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            // Marker 範例
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(24.785, 120.996),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
