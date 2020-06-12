import 'package:chat_app/src/styles/colors.dart';
import 'package:flutter/material.dart';

final TextStyle loginButtonStyle = TextStyle(
  fontSize: 35,
  fontWeight: FontWeight.w900,
  letterSpacing: 2,
  shadows: <Shadow>[
    Shadow(
      color: Colors.white,
      blurRadius: 5,
    ),
  ],
);

final TextStyle userCircleStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.bold,
  color: lightBlueColor,
);

final TextStyle tileTitleStyle = TextStyle(
  color: Colors.white,
  fontFamily: "Arial",
  fontSize: 19,
);

final TextStyle tileSubtitleStyle = TextStyle(
  color: greyColor,
  fontSize: 14,
);

final TextStyle searchStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 35,
);

final TextStyle suggestionTitleStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

final TextStyle suggestionSubtitleStyle = TextStyle(color: greyColor);
