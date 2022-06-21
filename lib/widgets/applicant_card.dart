import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';

// ignore: must_be_immutable
class ApplicantCard extends StatelessWidget {
  String? firstName;
  String? lastName;
  String? profession;
  String? email;
  String? phoneNumber;
  NetworkImage? profileImage;
  VoidCallback onTap;
  VoidCallback onTapCoverLetter;

  ApplicantCard({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.profession,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.onTap,
    required this.onTapCoverLetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: profileImage!)),
                ),
                title: Text(
                  firstName! + ' ' + lastName!,
                  style: kNunitoSemiBold.copyWith(fontSize: 15),
                ),
                subtitle: Text(
                  profession!,
                  style: kNunitoSemiBold.copyWith(
                      fontSize: 12, color: Colors.black87),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: MaterialButton(
                    minWidth: 15,
                    onPressed: onTapCoverLetter,
                    height: 15,
                    color: const Color(0xFF64A267),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Cover',
                            style: kNunito500.copyWith(
                                fontSize: 12, color: Colors.white)),
                        Text(
                          'Letter',
                          style: kNunito500.copyWith(
                              fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('E-mail:  ',
                          style: kNunitoSemiBold.copyWith(
                            fontSize: 12,
                          )),
                      Text(email!,
                          style: kNunitoSemiBold.copyWith(
                              fontSize: 12, color: const Color(0xFF4C4C4C))),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Text('Phone Number:  ',
                            style: kNunitoSemiBold.copyWith(
                              fontSize: 12,
                            )),
                        Text(
                          phoneNumber!,
                          style: kNunitoSemiBold.copyWith(
                              fontSize: 12, color: const Color(0xFF4C4C4C)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
