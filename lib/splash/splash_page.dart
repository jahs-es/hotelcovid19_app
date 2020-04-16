import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildLogo(),
            SizedBox(height: 20.0),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return new Image.asset(
      'assets/logo.png',
      width: 200.0,
      height: 200.0,
    );
  }

  Widget _buildTitle() {
    return Text('Monitorizate día a día',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
    );
  }
}
