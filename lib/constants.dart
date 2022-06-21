import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:uuid/uuid.dart';

var jobId = const Uuid().v4();

var kStraightLine = Container(
  width: double.infinity,
  height: 1,
  color: const Color(0x95ADADAD),
);

const kNunitoSemiBold =
    TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 17);

const kNunito500 =
    TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w500, fontSize: 15);

const kNunitoRegular =
    TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w400, fontSize: 12);

const kNunitoLight =
    TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w300, fontSize: 14);

const kLoginRegisterBackgroundColor = BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0x80A2D1EC),
    Color(0x990568DC),
  ],
));

const kMainBackgroundColor = BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0x80F2F8FB),
    Color(0x9969A9F3),
  ],
));

const kMenuTopNameColor = BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0x904682B9),
    Color(0xFF1A7EDA),
  ],
));

var kAppName = GradientText(
  'Career Wind',
  style: const TextStyle(fontFamily: 'ArchitectsDaughter', fontSize: 22),
  gradientType: GradientType.linear,
  gradientDirection: GradientDirection.ttb,
  colors: const [
    Color(0xFF3992CA),
    Color(0xFF2C3991),
  ],
);

const kTextFieldDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  prefixIcon: Icon(Icons.ac_unit),
  hintText: 'Enter a value',
  hintStyle: kNunitoLight,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF939393), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black54, width: 1.2),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
