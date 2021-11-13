import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TargetData extends Equatable{
  final int id;
  final String name;
  final double size;
  final V2 pos, vel;
  final Color color;

  const TargetData({required this.id, required this.name,required this.size,required this.pos,
    required this.vel,required this.color});

  TargetData.fromJson(Map<String,dynamic> json) :
    id = json['id'],
    name = json['name'],
    size = json['size'],
    pos = V2(json['pos'][0],json['pos'][1]),
    vel = V2(json['vel'][0],json['vel'][1]),
    color = Color.fromARGB(255, json['color'][0], json['color'][1], json['color'][2]);

  @override
  List<Object?> get props => [id,name,size,pos,vel,color];
}

class V2 extends Equatable{
  final double x,y;
  const V2(this.x, this.y);

  @override
  List<Object?> get props => [x,y];
}