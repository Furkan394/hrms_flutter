import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/constants.dart';
import 'package:iconly/iconly.dart';

Container buildPostingDetailNavigationBar(BuildContext context,
    VoidCallback? onTapForSave, VoidCallback? onTapForApply) {
  return Container(
    height: 77,
    decoration: const BoxDecoration(
      color: Color(0x904CA9F1),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: onTapForSave,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(width: 1, color: const Color(0xFF005FFC)),
              ),
              width: 132,
              height: 52,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Save',
                    style: kNunitoSemiBold.copyWith(
                        fontSize: 20, color: const Color(0xFF005FFC)),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onTapForApply,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF005FFC),
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(4, 10), // changes position of shadow
                  ),
                ],
              ),
              width: 211,
              height: 52,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Apply',
                    style: kNunitoSemiBold.copyWith(
                        fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
