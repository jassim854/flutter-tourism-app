import 'package:flutter/material.dart';


class ContainerBarWidget extends StatelessWidget {
  final Color color;
  const ContainerBarWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return  Container(
    
      height: 6,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: color,

    ),
      
    );
  }
}