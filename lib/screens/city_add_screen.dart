import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';


class CityAddScreen extends StatefulWidget {
  @override
  _CityAddScreenState createState() => _CityAddScreenState();
}

class _CityAddScreenState extends State<CityAddScreen> {
  String cityName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
          children: <Widget>[
           Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: kTextFieldInputDecoration,
                  onChanged: (val){
                    cityName = val;
                  },
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(cityName);
                },
                child: Text(
                  'Add city',
                  style: kButtonTextStyle,
                ),
              ),
          
            ],
          ),
           
         ])
        ),
        
      ),
    );
  }
}
