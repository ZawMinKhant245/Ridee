import 'package:firstapp1/screen/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.startPosition, this.endPosition,super.key});
  final DetailsResult? startPosition;
  final DetailsResult? endPosition;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}




class _HomeScreenState extends State<HomeScreen> {

  GoogleMapController? controller;
  LatLng? currentLocation;
  bool isVisible=true;



  Set<Marker> markers = {};
  Set<Polyline> polylines = {};


  void setMarkersAndRoute() {
    if (widget.startPosition != null && widget.endPosition != null) {
      final LatLng start = LatLng(
        widget.startPosition!.geometry!.location!.lat!,
        widget.startPosition!.geometry!.location!.lng!,
      );
      final LatLng end = LatLng(
        widget.endPosition!.geometry!.location!.lat!,
        widget.endPosition!.geometry!.location!.lng!,
      );

      setState(() {
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId("start"),
          position: start,
          infoWindow: InfoWindow(title: "Start"),
        ));
        markers.add(Marker(
          markerId: MarkerId("end"),
          position: end,
          infoWindow: InfoWindow(title: "End"),
        ));
      });

      // Create LatLngBounds that include both points
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          start.latitude < end.latitude ? start.latitude : end.latitude,
          start.longitude < end.longitude ? start.longitude : end.longitude,
        ),
        northeast: LatLng(
          start.latitude > end.latitude ? start.latitude : end.latitude,
          start.longitude > end.longitude ? start.longitude : end.longitude,
        ),
      );

      controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
    }
  }

  Future<void>getCurrentLocation()async{
    LocationPermission locationPermission= await Geolocator.requestPermission();

    if(locationPermission == LocationPermission.denied){
      return;
    }

    Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation =LatLng(position.latitude, position.longitude);
    });
    controller?.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: currentLocation!,zoom: 15))
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();

    if (widget.startPosition != null && widget.endPosition != null) {
      isVisible = !isVisible;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setMarkersAndRoute();
      });
    }
  }

  Widget buildMap(){
    if(currentLocation== null){
      return Center(child: CircularProgressIndicator(),);
    }else {
      return  GoogleMap(
        onMapCreated: (controllerMap){
          controller=controllerMap;
          Future.delayed(Duration(milliseconds: 500), () {
            setMarkersAndRoute();
          });
        },
        initialCameraPosition:CameraPosition(
            target:currentLocation!,
            zoom: 15
        ),
        myLocationEnabled: isVisible?true:false,
        myLocationButtonEnabled: true,
        markers: markers,
        polylines: polylines,
      );
    }

  }

  Widget buildSelectionCard({
  required Image image,
  required String type,
  required String cost,
    required String min,
    required String people,
    required String text,
  required VoidCallback onTop,
   }){
    return Card(
      surfaceTintColor: Color.fromARGB(255, 232, 227, 227),
      elevation: 5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){},
          splashColor: Color.fromARGB(255, 232, 227, 227),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(flex:1,child: image),
                    const SizedBox(width: 30,),
                    Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(type,style: TextStyle(fontWeight: FontWeight.bold),),
                                Row(children: [Text('$min min'),Icon(Icons.person_2_outlined,size: 18,),Text(people)],),
                                Text(text)
                              ],
                            ),
                          ),
                    Expanded(flex:1,child: Text('$cost B',style: TextStyle(fontWeight: FontWeight.bold),)),
                  ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          children:[
            buildMap(),
            DraggableScrollableSheet(
                builder: (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 240, 240),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const Icon(Icons.horizontal_rule,weight: 200,),
                          Text('Choose your desination',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          const SizedBox(height: 20,),
                          TextField(
                            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreen(currentLocation:currentLocation))),
                            autofocus: false,
                            showCursor: false,
                            decoration:InputDecoration(
                                filled: true,
                                hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                                hintText: 'Where To?',
                                prefixIcon: const Icon(Icons.search),
                                fillColor:const Color.fromARGB(255, 213, 209, 209),
                                border:InputBorder.none,
                                suffixIcon: IconButton(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreen(currentLocation: currentLocation,))), icon: const Icon(Icons.map_sharp)),
                                suffixIconColor: Color.fromARGB(255, 207, 61, 30)
                            ),
                          ),
                          const SizedBox(height: 20,),
                          if(isVisible)...[
                           Text('dsdsdsds')
                          ], //need to add
                          if(!isVisible)...[
                            buildSelectionCard(
                                image: Image.asset('assets/taxi.png',width: 60,),
                                type: 'Taxi',
                                cost: '100',
                                min: '5',
                                people: '4',
                                text: 'Local Taxi',
                                onTop: (){print('Click');}
                            ),
                            buildSelectionCard(
                                image: Image.asset('assets/bike.png',width: 60,),
                                type: 'MotoBike',
                                cost: '65',
                                min: '2',
                                people: '1',
                                text: '2 - Wheels',
                                onTop: (){print('Click');}
                            ),
                            buildSelectionCard(
                                image: Image.asset('assets/tuktuk.png',width: 60,),
                                type: 'Tuk Tuk',
                                cost: '78',
                                min: '5',
                                people: '3',
                                text: 'comfort ride',
                                onTop: (){print('Click');}
                            ),
                            buildSelectionCard(
                                image: Image.asset('assets/comfortcar.png',width: 60,),
                                type: 'Comfort',
                                cost: '80',
                                min: '4',
                                people: '4',
                                text: 'Affordable rides',
                                onTop: (){print('Click');}
                            ),
                            buildSelectionCard(
                                image: Image.asset('assets/suv.png',width: 60,),
                                type: 'Suv',
                                cost: '120',
                                min: '5',
                                people: '6',
                                text: 'Local Taxi',
                                onTop: (){print('Click');}
                            ),
                            buildSelectionCard(
                                image: Image.asset('assets/truck.png',width: 60,),
                                type: 'Truck',
                                cost: '98',
                                min: '5',
                                people: '0',
                                text: 'Max items - 50kg',
                                onTop: (){print('Click');}
                            ),
                            buildSelectionCard(
                                image: Image.asset('assets/delivery.png',width: 60,),
                                type: 'Delivery',
                                cost: '100',
                                min: '5',
                                people: '0',
                                text: 'Send small items',
                                onTop: (){print('Click');}
                            ),
                          ],
                          
                        ],
                      ),
                    ),
                  ),
                )
            )
          ]
      ),
    );

  }
}