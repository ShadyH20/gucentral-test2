import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/MenuWidget.dart';

LatLng gucLocation = const LatLng(29.986058827537406, 31.440052084659296);

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  GoogleMapController? mapController;
  Position? currentPosition;

  late Set<Marker> _markers;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _markers = _createMarkers();
    _getCurrentLocation();
  }

  bool loading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      loading = true;
    });
    try {
      // Check permissions
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location services enabled: $isServiceEnabled');
      if (!isServiceEnabled) {
        return Future.error('Location services are disabled.');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      print('Location permissions: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('Location permissions: $permission');
        if (permission == LocationPermission.denied) {
          return Future.error('Location services are denied.');
        }
      }

      //if denied forever
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ScaffoldMessenger(
            child: Builder(
      builder: (context) => Scaffold(
        backgroundColor: MyColors.background,
        appBar: mapAppBar(),
        extendBodyBehindAppBar: true,
        body: Center(
            child: loading
                ? const CircularProgressIndicator()
                : GoogleMap(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 56.0),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: gucLocation,
                      zoom: 17,
                    ),
                    mapType: MapType.hybrid,
                    buildingsEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    minMaxZoomPreference: const MinMaxZoomPreference(12, 25),
                    cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                      southwest: const LatLng(29.980406, 31.428271),
                      northeast:
                          const LatLng(29.991810872824992, 31.44739060688671),
                    )),
                    markers: _markers,
                  )),
      ),
    )));
  }

  mapAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leadingWidth: 80.0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MyColors.background,
          ),
          child: const MenuWidget(noPadding: true),
        ),
      ),
      // title: const Text('Map'),
    );
  }

  Set<Marker> _createMarkers() {
    // Set<Marker> allMarkers = {};
    Set<Marker> bMarkers = _createBMarkers();

    return bMarkers;
  }

  Set<Marker> _createBMarkers() {
    return {
      const Marker(
        markerId: MarkerId('Gym'),
        position: LatLng(29.9858378, 31.4389524),
        infoWindow: InfoWindow(
          title: 'Gym',
          snippet: 'Gym',
        ),
      ),
      const Marker(
        markerId: MarkerId('Clinic'),
        position: LatLng(29.9857521, 31.4388495),
        infoWindow: InfoWindow(
          title: 'Clinic',
          snippet: 'Clinic',
        ),
      ),
      const Marker(
        markerId: MarkerId('B5'),
        position: LatLng(29.9857115, 31.4389702),
        infoWindow: InfoWindow(
          title: 'B5',
          snippet: 'B5',
        ),
      ),
      const Marker(
        markerId: MarkerId('CIB - Commercial International Bank'),
        position: LatLng(29.9853377, 31.4394198),
        infoWindow: InfoWindow(
          title: 'CIB - Commercial International Bank',
          snippet: 'CIB - Commercial International Bank',
        ),
      ),
      const Marker(
        markerId: MarkerId('B2'),
        position: LatLng(29.9852983, 31.4393048),
        infoWindow: InfoWindow(
          title: 'B2',
          snippet: 'B2',
        ),
      ),
      const Marker(
        markerId: MarkerId('B1'),
        position: LatLng(29.9852565, 31.4390822),
        infoWindow: InfoWindow(
          title: 'B1',
          snippet: 'B1',
        ),
      ),
      const Marker(
        markerId: MarkerId('H4'),
        position: LatLng(29.9850219, 31.4386208),
        infoWindow: InfoWindow(
          title: 'H4',
          snippet: 'H4',
        ),
      ),
      const Marker(
        markerId: MarkerId('H5'),
        position: LatLng(29.9850753, 31.4383874),
        infoWindow: InfoWindow(
          title: 'H5',
          snippet: 'H5',
        ),
      ),
      const Marker(
        markerId: MarkerId('H3'),

        position: LatLng(29.98485, 31.4386155),
        // icon: BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, ),
        infoWindow: InfoWindow(
          title: 'H3',
          snippet: 'H3',
        ),
      ),
      const Marker(
        markerId: MarkerId('H1'),
        position: LatLng(29.9849057, 31.4390071),
        infoWindow: InfoWindow(
          title: 'H1',
          snippet: 'H1',
        ),
      ),
      const Marker(
        markerId: MarkerId('H2'),
        position: LatLng(29.9849638, 31.4389373),
        infoWindow: InfoWindow(
          title: 'H2',
          snippet: 'H2',
        ),
      ),
      const Marker(
        markerId: MarkerId('B4'),
        position: LatLng(29.9849482, 31.4392905),
        infoWindow: InfoWindow(
          title: 'B4',
          snippet: 'B4',
        ),
      ),
      const Marker(
        markerId: MarkerId('B3'),
        position: LatLng(29.9851062, 31.4389875),
        infoWindow: InfoWindow(
          title: 'B3',
          snippet: 'B3',
        ),
      ),
      const Marker(
        markerId: MarkerId('B6'),
        position: LatLng(29.9853803, 31.4384966),
        infoWindow: InfoWindow(
          title: 'B6',
          snippet: 'B6',
        ),
      ),
      const Marker(
        markerId: MarkerId('B1'),
        position: LatLng(29.985306, 31.4388775),
        infoWindow: InfoWindow(
          title: 'B1',
          snippet: 'B1',
        ),
      ),
      const Marker(
        markerId: MarkerId('H6'),
        position: LatLng(29.9849104, 31.4394718),
        infoWindow: InfoWindow(
          title: 'H6',
          snippet: 'H6',
        ),
      ),
      const Marker(
        markerId: MarkerId('H7'),
        position: LatLng(29.9849894, 31.4394691),
        infoWindow: InfoWindow(
          title: 'H7',
          snippet: 'H7',
        ),
      ),
    };
  }
}
