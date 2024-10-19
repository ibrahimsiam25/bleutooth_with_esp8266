import 'package:flutter/material.dart';


import 'widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
              title:const Text( 'Network Info'),
              centerTitle: true,
            ),
      body:const HomeViewBody()
    );
  }
}