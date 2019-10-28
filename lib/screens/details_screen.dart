
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final String city;
  WeatherModel weather = new WeatherModel(); 
  dynamic getWeatherData(city) async{
 dynamic weatherData = await weather.getCityWeather(this.city);
 return weatherData;
 }
  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Stack( children: <Widget> [
      Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/imgg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('weather details'),
        
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        
        child: FutureBuilder(future: getWeatherData(city),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                    return new ListView(children: <Widget>[
                       Text('city : '+city,
                      style: kTempTextStyle2,),
                      Text('longitude : '+snapshot.data['coord']['lon'].toString(),
                      style: kTempTextStyle2,),
                      Text('latitude : '+snapshot.data['coord']['lat'].toString(),
                      style: kTempTextStyle2,),
                      Text('temperature : '+snapshot.data['main']['temp'].toString()+'°',
                      style: kTempTextStyle2,),
                      Text('pressure : '+snapshot.data['main']['pressure'].toString(),
                      style: kTempTextStyle2,),
                      Text('humidity : '+snapshot.data['main']['humidity'].toString(),
                      style: kTempTextStyle2,),
                      Text('Minimum temperature : '+snapshot.data['main']['temp_min'].toString()+'°',
                      style: kTempTextStyle2,),
                      Text('Maximum temperature : '+snapshot.data['main']['temp_max'].toString()+'°',
                      style: kTempTextStyle2,)
                      ]
                      );
                  }
              }
            },),
         
      ),
      
    )]);
  }
}