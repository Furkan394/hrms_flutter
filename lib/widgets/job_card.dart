import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/constants.dart';

class JobCard extends StatelessWidget {
  String title;
  String subTitle;
  String location;
  String jobType;
  VoidCallback onTap;
  NetworkImage image;

  JobCard({
    required this.title,
    required this.subTitle,
    required this.location,
    required this.jobType,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 38),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: image,
              ),
              // trailing: Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 5, 18),
              //   child: InkWell(
              //     onTap: () {
              //
              //     },
              //     child: const Icon(
              //       FeatherIcons.heart,
              //       color: Color(0xFF636363),
              //     ),
              //   ),
              // ),
              title: Text(
                title,
                style: kNunitoSemiBold.copyWith(fontSize: 15),
              ),
              subtitle: Text(
                subTitle,
                style: kNunitoSemiBold.copyWith(
                    fontSize: 12, color: Colors.black87),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: Text('Job Type: $jobType',
                      style: kNunitoSemiBold.copyWith(
                          fontSize: 12, color: const Color(0xFF636363))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 10),
                  child: Text(
                    'Location: $location',
                    style: kNunitoSemiBold.copyWith(
                        fontSize: 12, color: const Color(0xFF636363)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
