import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pulseai/services/local_hospital_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pulseai/l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/modern_widgets.dart';
import '../core/utils/responsive.dart';

class HospitalMapScreen extends StatefulWidget {
  const HospitalMapScreen({super.key});

  @override
  State<HospitalMapScreen> createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  final LocalHospitalService _localHospitalService = LocalHospitalService();
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<dynamic> _hospitals = [];
  bool _isLoading = true;
  LatLng? _currentPosition;
  bool _isUsingGPS = false;
  String? _gpsErrorMessage;
  
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredHospitals = [];
  bool _isMapReady = false;

  String _selectedService = "Tout";
  // Services will be localized in build method

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _getCurrentLocation();
    _loadHospitals();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        throw Exception("Permission GPS refusée");
      }
      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isUsingGPS = true;
          _gpsErrorMessage = null;
        });
        _mapController.move(_currentPosition!, 13.0);
      }
    } catch (e) {
      // Position par défaut en cas d'erreur
      if (mounted) {
        setState(() {
          _currentPosition = const LatLng(6.1319, 1.2228); // Lomé
          _isUsingGPS = false;
          _gpsErrorMessage = "Utilisation de la position par défaut (Lomé).";
        });
        _mapController.move(_currentPosition!, 13.0);
      }
    }
  }

  Future<void> _loadHospitals() async {
    if (_currentPosition == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Don't clear hospitals if we already have them
          if (_hospitals.isEmpty) {
             _hospitals = [];
             _markers = [];
          }
        });
      }
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final hospitals = await _localHospitalService.loadHospitals(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (mounted) {
        setState(() {
          _hospitals = hospitals;
          _filteredHospitals = hospitals;
          _markers = hospitals.where((h) {
            final hasCoords = h['latitude'] != null && h['longitude'] != null;
            return hasCoords;
          }).map<Marker>((h) {
            final lat = (h['latitude'] as num).toDouble();
            final lng = (h['longitude'] as num).toDouble();
            return Marker(
              point: LatLng(lat, lng),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showHospitalDetails(h),
                child: const Icon(
                  Icons.local_hospital,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          }).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        // On web, CORS might block the request. Show a friendly message.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Impossible de charger les hôpitaux: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showHospitalDetails(dynamic hospital) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(Responsive.valueWhen(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hospital['nom'] ?? 'Hôpital',
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  iconSize: Responsive.valueWhen(context, mobile: 20, tablet: 22, desktop: 24),
                ),
              ],
            ),
            SizedBox(height: Responsive.valueWhen(context, mobile: 8, tablet: 9, desktop: 10)),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: Responsive.valueWhen(context, mobile: 18, tablet: 19, desktop: 20)),
                const SizedBox(width: 4),
                Text(
                  "${hospital['note_moyenne'] ?? 0.0} (${hospital['nombre_avis'] ?? 0} avis)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.valueWhen(context, mobile: 13, tablet: 14, desktop: 14),
                  ),
                ),
                const SizedBox(width: 16),
                if (hospital['distance_km'] != null) ...[
                  Icon(Icons.location_on, color: Colors.blue, size: Responsive.valueWhen(context, mobile: 18, tablet: 19, desktop: 20)),
                  const SizedBox(width: 4),
                  Text(
                    "${(hospital['distance_km'] as num).toStringAsFixed(1)} km",
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(context, mobile: 13, tablet: 14, desktop: 14),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: Responsive.valueWhen(context, mobile: 16, tablet: 18, desktop: 20)),
            _buildInfoRow(Icons.map, hospital['adresse'] ?? 'Adresse non disponible'),
            _buildInfoRow(Icons.phone, hospital['telephone'] ?? 'Non renseigné'),
            _buildInfoRow(Icons.access_time, hospital['horaires_ouverture'] ?? '24h/24'),
            
            SizedBox(height: Responsive.valueWhen(context, mobile: 16, tablet: 18, desktop: 20)),
            Text(
              "Services disponibles",
              style: TextStyle(
                fontSize: Responsive.valueWhen(context, mobile: 16, tablet: 17, desktop: 18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Responsive.valueWhen(context, mobile: 8, tablet: 9, desktop: 10)),
            Expanded(
              child: hospital['services'] != null && (hospital['services'] as List).isNotEmpty
                  ? ListView.builder(
                      itemCount: (hospital['services'] as List).length,
                      itemBuilder: (context, index) {
                        final service = hospital['services'][index];
                        final serviceName = service is String ? service : (service['nom_service'] ?? '');
                        return ListTile(
                          leading: const Icon(Icons.medical_services_outlined),
                          title: Text(serviceName),
                          subtitle: const Text('Disponible'),
                        );
                      },
                    )
                  : const Center(child: Text("Aucun service listé")),
            ),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                       final lat = (hospital['latitude'] as num).toDouble();
                       final lng = (hospital['longitude'] as num).toDouble();
                       _launchMaps(lat, lng);
                    },
                    icon: Icon(
                      Icons.directions,
                      size: Responsive.valueWhen(context, mobile: 18, tablet: 20, desktop: 20),
                    ),
                    label: Text(
                      'Y aller',
                      style: TextStyle(
                        fontSize: Responsive.valueWhen(context, mobile: 14, tablet: 15, desktop: 15),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.valueWhen(context, mobile: 10, tablet: 11, desktop: 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.valueWhen(context, mobile: 8, tablet: 9, desktop: 10)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showRatingDialog(hospital['id'].toString(), hospital['nom']);
                    },
                    icon: Icon(
                      Icons.star_border,
                      size: Responsive.valueWhen(context, mobile: 18, tablet: 20, desktop: 20),
                    ),
                    label: Text(
                      'Noter',
                      style: TextStyle(
                        fontSize: Responsive.valueWhen(context, mobile: 14, tablet: 15, desktop: 15),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.valueWhen(context, mobile: 10, tablet: 11, desktop: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.valueWhen(context, mobile: 12, tablet: 14, desktop: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Responsive.valueWhen(context, mobile: 6, tablet: 7, desktop: 8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: Responsive.valueWhen(context, mobile: 18, tablet: 19, desktop: 20),
            color: Colors.grey[600],
          ),
          SizedBox(width: Responsive.valueWhen(context, mobile: 10, tablet: 11, desktop: 12)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: Responsive.valueWhen(context, mobile: 14, tablet: 15, desktop: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _filterHospitals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHospitals = List.from(_hospitals);
      } else {
        _filteredHospitals = _hospitals.where((hospital) {
          final name = (hospital['nom'] as String).toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildServiceChip(String label, String serviceName) {
    final isSelected = _selectedService == serviceName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedService = serviceName;
          _loadHospitals();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.valueWhen(context, mobile: 12, tablet: 14, desktop: 16),
          vertical: Responsive.valueWhen(context, mobile: 6, tablet: 7, desktop: 8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.lightGrey,
          ),
          boxShadow: isSelected ? AppTheme.softShadow : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: Responsive.valueWhen(context, mobile: 13, tablet: 14, desktop: 14),
          ),
        ),
      ),
    );
  }

  Future<void> _launchMaps(double lat, double lng) async {
    if (_currentPosition == null) return;
    final Uri url = Uri.parse('https://www.openstreetmap.org/directions?engine=osrm_car&route=${_currentPosition!.latitude},${_currentPosition!.longitude};$lat,$lng');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir la carte')),
        );
      }
    }
  }

  void _showRatingDialog(String hospitalId, String hospitalName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Noter $hospitalName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Quelle est votre note ?"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: const Icon(Icons.star_border, size: 30),
                  color: Colors.amber,
                  onPressed: () async {
                    Navigator.pop(context);
                    // Simulation de notation pour le mode hors ligne/local
                    await Future.delayed(const Duration(seconds: 1));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Merci pour votre avis ! (Mode démo)")),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Define services with localized names
    final List<Map<String, dynamic>> services = [
      {"name": "Tout", "label": l10n.all, "icon": Icons.local_hospital},
      {"name": "Urgences", "label": l10n.emergency, "icon": Icons.flash_on},
      {"name": "Cardiologie", "label": l10n.cardiology, "icon": Icons.favorite},
      {"name": "Pédiatrie", "label": l10n.pediatrics, "icon": Icons.child_care},
      {"name": "Neurologie", "label": l10n.neurology, "icon": Icons.psychology},
      {"name": "Général", "label": l10n.general, "icon": Icons.medical_services},
      {"name": "Maternité", "label": l10n.maternity, "icon": Icons.pregnant_woman},
      {"name": "Dentiste", "label": l10n.dentist, "icon": Icons.masks},
    ];

    final isInTogo = _currentPosition != null && 
                     _currentPosition!.latitude > 5 && 
                     _currentPosition!.latitude < 12 && 
                     _currentPosition!.longitude > 0 && 
                     _currentPosition!.longitude < 2;
    
    final locationText = _isUsingGPS
        ? (isInTogo ? "🎯 GPS: Togo" : "🎯 GPS Actif")
        : _gpsErrorMessage ?? "⚠️  GPS non disponible";
    
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(6.1375, 1.2125), // Lomé
              initialZoom: 13.0,
              onMapReady: () {
                setState(() {
                  _isMapReady = true;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pulseai',
              ),
              MarkerLayer(
                markers: _hospitals.map((hospital) {
                  return Marker(
                    point: LatLng(
                      (hospital['latitude'] as num).toDouble(),
                      (hospital['longitude'] as num).toDouble(),
                    ),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showHospitalDetails(hospital),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          color: AppTheme.primaryBlue,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Search Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: ModernCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppTheme.darkGrey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchHospitalHint,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppTheme.darkGrey),
                      ),
                      onChanged: _filterHospitals,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: AppTheme.darkGrey),
                      onPressed: () {
                        _searchController.clear();
                        _filterHospitals('');
                      },
                    ),
                  Container(
                    width: 1,
                    height: 24,
                    color: AppTheme.lightGrey,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: AppTheme.primaryBlue),
                    onPressed: () {
                      // Show filter dialog
                    },
                  ),
                ],
              ),
            ),
          ),

          // Service Filters
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildServiceChip(l10n.all, 'Tout'),
                  const SizedBox(width: 8),
                  _buildServiceChip(l10n.serviceEmergency, 'Urgences'),
                  const SizedBox(width: 8),
                  _buildServiceChip(l10n.serviceCardiology, 'Cardiologie'),
                  const SizedBox(width: 8),
                  _buildServiceChip(l10n.servicePediatrics, 'Pédiatrie'),
                  const SizedBox(width: 8),
                  _buildServiceChip(l10n.serviceNeurology, 'Neurologie'),
                  const SizedBox(width: 8),
                  _buildServiceChip(l10n.serviceGeneral, 'Général'),
                  const SizedBox(width: 8),
                  _buildServiceChip(l10n.serviceMaternity, 'Maternité'),
                ],
              ),
            ),
          ),

          // Draggable Scrollable Sheet for Hospital List
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.recommendedSection,
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _filteredHospitals.isEmpty
                              ? Center(
                                  child: Text(
                                    l10n.noHospitalFound,
                                    style: TextStyle(color: AppTheme.darkGrey),
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: _filteredHospitals.length,
                                  itemBuilder: (context, index) {
                                    final hospital = _filteredHospitals[index];
                                    return _buildHospitalCard(context, hospital);
                                  },
                                ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(BuildContext context, dynamic hospital) {
    final name = hospital['nom'] ?? 'Hôpital';
    final dist = hospital['distance_km'] != null ? (hospital['distance_km'] as num).toStringAsFixed(1) : '0';
    final hours = hospital['horaires_ouverture'] ?? 'Fermé';
    final rating = hospital['note_moyenne'] != null ? (hospital['note_moyenne'] as num).toDouble() : 0.0;
    
    return InkWell(
      onTap: () => _showHospitalDetails(hospital),
      child: Container(
        margin: EdgeInsets.only(
          bottom: Responsive.valueWhen(context, mobile: 12, tablet: 14, desktop: 16),
        ),
        padding: EdgeInsets.all(
          Responsive.valueWhen(context, mobile: 10, tablet: 11, desktop: 12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.valueWhen(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          )),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.valueWhen(context, mobile: 50, tablet: 55, desktop: 60),
              height: Responsive.valueWhen(context, mobile: 50, tablet: 55, desktop: 60),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_hospital,
                color: AppTheme.primaryBlue,
                size: Responsive.valueWhen(context, mobile: 24, tablet: 26, desktop: 28),
              ),
            ),
            SizedBox(width: Responsive.valueWhen(context, mobile: 12, tablet: 14, desktop: 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(context, mobile: 14, tablet: 15, desktop: 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Responsive.valueWhen(context, mobile: 3, tablet: 3.5, desktop: 4)),
                  Text(
                    '$dist km • $hours',
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(context, mobile: 12, tablet: 13, desktop: 14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: Responsive.valueWhen(context, mobile: 3, tablet: 3.5, desktop: 4)),
                  Row(
                    children: [
                      Icon(Icons.star, size: Responsive.valueWhen(context, mobile: 14, tablet: 15, desktop: 16), color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(context, mobile: 12, tablet: 13, desktop: 14),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.directions, color: AppTheme.primaryBlue),
              iconSize: Responsive.valueWhen(context, mobile: 20, tablet: 22, desktop: 24),
              onPressed: () {
                 final lat = (hospital['latitude'] as num).toDouble();
                 final lng = (hospital['longitude'] as num).toDouble();
                 _launchMaps(lat, lng);
              },
            ),
          ],
        ),
      ),
    );
  }
}
