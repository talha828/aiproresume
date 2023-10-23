library com.example.resume_builder.global;

import 'package:flutter/material.dart';



enum ImageShape { circle, square }

bool showImage = true;
bool showSoftSkill = true;
bool showLanguages = true;
bool showCertificates = true;
bool showAwards = true;
bool showHobbies = false;
bool showReference = true;
bool showSignature = false;
bool showExtarDetail = false;
bool showSkill = true;
bool showEducation = true;
bool showExperience = true;
bool showobjective = false;
bool showsummary = true;

Color? bg1color;
Color? bg2color;
Color? font1color;
Color? font2color;
Color? heading1color;
Color? heading2color;
Widget? profile;
Color backgroundColor = const Color(0xff2E3940);
// Color fontcolor = Colors.black;
// Color iconColor = Colors.black;
// Color? fontcolor;
Color? iconColor;

ImageShape imageShape = ImageShape.circle;
double fontSize = 14;
final List<double> fontSizes = [14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0];
double headingSize = 18;
final List<double> headingFontSizes = [18.0, 20.0, 24.0, 26.0, 28.0];
String fontStyle = 'Poppins';


