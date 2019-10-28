import 'package:clima/screens/city_screen.dart';
import 'package:clima/screens/city_add_screen.dart';
import 'package:clima/screens/details_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  const LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}



class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  ScrollController _controller = ScrollController();
  int temperature;
  String city;
  String weatherIcon;
  String weatherMessage;
  String addCity;
  List<String> cities = [];
  List<String> cities2P0 = [];
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }
Future getImage (String city) async{
    print(city);
    http.Response response = await http.get('https://api.teleport.org/api/urban_areas/slug:'+city+'/images/');
    if(response.statusCode == 200){
    print(jsonDecode(response.body)['photos'][0]['image']['mobile']); 
    return jsonDecode(response.body)['photos'][0]['image']['mobile'];}
    else
    print(response.statusCode);
    return 'https://img.pngio.com/city-buildings-png-mid-autumn-festival-illustration-clipart-transparent-city-png-5746_1513.png';
}


 Future<String> setSubtitle (String city) async {
  var subtitle; 
  var weatherData = await weather.getCityWeather(city);
  
 
    subtitle = weatherData['main']['temp'];
    
  print(subtitle);
   return subtitle.toString();
  
    
 }

updateCities(dynamic city){
print(city);
cities2P0.add(city);
print(city.toLowerCase().replaceAll(RegExp(' +'), '-'));   
cities.add(city.toLowerCase().replaceAll(RegExp(' +'), '-'));
 
  
}
  void updateUI(dynamic weatherData) {
    if(weatherData != null)
    setState(() {
      try {
        double temp = weatherData['main']['temp'];
        temperature = temp.round();
      } catch (e) {
        temperature = weatherData['main']['temp'];
      }
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      city = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child:Flex(children: <Widget>[
         Expanded(child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,

            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                   FlatButton(
                    onPressed: () async {
                       var typedName = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CityAddScreen()
                        )
                      );
                      if(typedName != null){
                        updateCities(typedName);
                      }
                    },
                    child: Icon(
                      Icons.add,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async{
                      var typedName = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CityScreen()
                        )
                      );
                      if(typedName != null){
                        var weatherData = await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
           Row(
             children: <Widget>[
               Expanded(child: Text(
                      '$temperature° à $city',
                      style: kTempTextStyle,
                    )),
                   Expanded(child: Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    )),]),
   
  
       
         
             
                      

          ],
        ),
        
        ),
     
        Expanded(
            child:   new ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            itemCount: cities==null?0 : cities.length,
            itemBuilder:  (BuildContext context, int index) {
            return new ListTile(
                      onTap: () async {
                        await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(city: cities2P0[index])
                        )
                      );
                     
                    },
                     leading: SizedBox(
                       width: 80.0,
                       height: 80.0
                       ,
                       child: FutureBuilder(
                     future: getImage(cities[index]),
                     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          return new CircleAvatar(
                            backgroundImage: NetworkImage('https://img.pngio.com/city-buildings-png-mid-autumn-festival-illustration-clipart-transparent-city-png-5746_1513.png'),
                          );
                          case ConnectionState.waiting:
                          return new Center(child: new CircularProgressIndicator());
                          case ConnectionState.active:
                          return new CircleAvatar(
                            backgroundImage: Icons.add_location as ImageProvider,
                            );
                          case ConnectionState.done:
                          if (snapshot.hasError) {
                          return new CircleAvatar(
                          backgroundImage: NetworkImage('https://img.pngio.com/city-buildings-png-mid-autumn-festival-illustration-clipart-transparent-city-png-5746_1513.png'),
                 
                          );
                          } else {
                          return new CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data),
              );
                  }
              }
            },)),
            title: Text(cities2P0[index]),
            subtitle: FutureBuilder(  future: setSubtitle(cities2P0[index]),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('err');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return new Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return new ListView(
                      shrinkWrap: true,
                        children: <Widget>[new Text(snapshot.data+'°')]);
                  }
              }
            }
            )
  
            );
            
            
           
          
            }
          
          ),
        
        
    )
        ],
        direction: Axis.vertical,),
        
        ),
    );
  
  }
}
