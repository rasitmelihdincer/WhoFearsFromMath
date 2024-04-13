import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    // _checkDisplayStatus();
  }
/*
  _checkDisplayStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeen = prefs.getBool('hasSeen') ?? false;
    if (hasSeen) {
      setState(() {
        _isVisible = false;
      });
    }
  }
  */

  _dismissOverlay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeen', true);
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible)
      return SizedBox.shrink(); // Eğer görünmezse hiçbir şey gösterme
    return GestureDetector(
      onTap:
          _dismissOverlay, // Ekranın herhangi bir yerine tıklanıldığında kapat
      child: Container(
        color: Colors.black.withOpacity(0.5), // Bulanık arkaplan rengi
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity, // Tüm ekranı kaplasın
            height: double.infinity, // Tüm ekranı kaplasın
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Here is some important information!",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
