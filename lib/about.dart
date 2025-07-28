import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Application'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'This app is a Final Year Project for Deaf Glove communication.\n\nDeveloped by Awais Mirza and Malaz Tariq.\nInstitute: Iqra University, Islamabad.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
