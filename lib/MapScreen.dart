import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:googlemap/place_service.dart';
import 'package:googlemap/address_search.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _searchcontroller = TextEditingController();
  final _title = TextEditingController();
  final _label = TextEditingController();
  final _markerColor = TextEditingController();
  String _city = '';
  String _zipCode = '';

  GoogleMapController _controller;
  Location currentLocation = Location();
  Set<Marker> _markers={};

  void getLocation() async{
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc){

      _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        ));
      });
    });
  }


  @override
  void initState(){
    super.initState();
    setState(() {
      getLocation();
    });
  }

  final formkey=GlobalKey<FormState>();
  Future<void> _searchDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Details'),
          content:
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Form(
                      key: formkey,
                   child: Container(
                        width: double.minPositive,
                        child:
                  ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                  return
                        Column(
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: TextFormField(
                                controller: _title,
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Title';
                          }
                          return null;
                        },
                                decoration: new InputDecoration(
                                    hintText: "Title",
                                    labelText: "Enter Title",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff09a8d9),// Colors.blue
                                      ),
                                    ),
                                    border: UnderlineInputBorder()
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Container(
                              width: 200,
                              child: TextFormField(
                                controller: _label,
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Label';
                                  }
                                  return null;
                                },
                                decoration: new InputDecoration(
                                    hintText: "Label",
                                    labelText: "Enter Label",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff09a8d9),// Colors.blue
                                      ),
                                    ),
                                    border: UnderlineInputBorder()
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Container(
                              width: 200,
                              child: TextFormField(
                                controller: _markerColor,
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Color';
                                  }
                                  return null;
                                },
                                decoration: new InputDecoration(
                                    hintText: "MarkerColor",
                                    labelText: "Enter MarkerColor",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff09a8d9),// Colors.blue
                                      ),
                                    ),
                                    border: UnderlineInputBorder()
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        );
                })));
                }
            ),

          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async{
                  if(formkey.currentState.validate()) {
//                      final sessionToken = Uuid().v4();
//                      final Suggestion result = await showSearch(
//                        context: context,
//                        delegate: AddressSearch(sessionToken),
//                      );
//                      if (result != null) {
//                        final placeDetails = await PlaceApiProvider(sessionToken)
//                            .getPlaceDetailFromId(result.placeId);
//                        setState(() {
//                          _label.text = result.description;
//                          _city = placeDetails.city;
//                          _zipCode = placeDetails.zipCode;
//                        });
//                      }
                       Navigator.of(context).pop();
                  }
                },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body:
          Column(
            children: [
              TextField(
                controller: _searchcontroller,
                readOnly: true,
                onTap: () async {
                  final sessionToken = Uuid().v4();
                  final Suggestion result = await showSearch(
                    context: context,
                    delegate: AddressSearch(sessionToken),
                  );
                  if (result != null) {
                    final placeDetails = await PlaceApiProvider(sessionToken)
                        .getPlaceDetailFromId(result.placeId);
                    setState(() {
                      _searchcontroller.text = result.description;
                      _city = placeDetails.city;
                      _zipCode = placeDetails.zipCode;
                    });
                  }
                },
                decoration: InputDecoration(
                  icon: Container(
                    padding: EdgeInsets.only(left: 10,top: 5),
                    width: 20,
                    height: 20,
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Enter your address",hoverColor: Colors.black,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                ),
              ),
          Expanded(child:   Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child:GoogleMap(
                  zoomGesturesEnabled:true,
                  initialCameraPosition:CameraPosition(
                    target: LatLng(48.8561, 2.2930),
                    zoom: 12.0,
                  ),
                  onMapCreated: (GoogleMapController controller){
                    _controller = controller;
                  },
                  markers: _markers,
                ) ,
              ),

              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      children: <Widget> [
                        Align(
                          alignment: Alignment.topRight,
                          child:
                          FloatingActionButton(
                            heroTag: "btn1",
                            onPressed: _searchDialog,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.pink,
                            child: const Icon(Icons.add_location, size: 36.0),
                          ),
                        ),

                        SizedBox(height: 20,),

                        Align(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            heroTag: "btn2",
                            child: Icon(Icons.location_searching,color: Colors.white,),
                            onPressed: (){
                              getLocation();
                            },
                          ),
                        ),
                      ]))
            ],),),
          ],)
    );
  }
}