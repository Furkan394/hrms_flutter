import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';

class BuildHeader extends StatelessWidget {
  String title;
  String route;

  BuildHeader(this.title, this.route);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: kNunito500.copyWith(fontSize: 19),
                      ),
                    ),
                    Positioned(
                        left: 26,
                        child: InkWell(
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, route);
                          },
                        ))
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: kStraightLine,
          ),
        ],
      ),
    );
  }
}
