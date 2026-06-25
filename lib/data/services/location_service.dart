import 'package:geolocator/geolocator.dart';

class LocationService{
 Future<Position> getCurrentLocation()async{
 bool serviceEnabled ;
 LocationPermission permission;
 
 serviceEnabled=await Geolocator.isLocationServiceEnabled();
   if(!serviceEnabled){
    return Future.error('Gps is turned off ,please turn on manually');
   }
   permission=await Geolocator.checkPermission();
   if(permission == LocationPermission.denied){
    await Geolocator.requestPermission();
   
    if(permission == LocationPermission.denied){
       return Future.error('Gps is turned off ,please turn on manually');
    }
    }
   return await Geolocator.getCurrentPosition(
    // ignore: deprecated_member_use
    desiredAccuracy: LocationAccuracy.high
   );
  } 
}