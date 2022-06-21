import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/screens/candidate_screens/posting_detail_screen.dart';
import 'package:hrms/widgets/job_card.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _jobsStream =
      FirebaseFirestore.instance.collection('jobs').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: kMainBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppLogo(),
              //buildSearchButton(),
              buildSuggestedText(),
              buildStreamBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _jobsStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot
              .data!.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
          return Flexible(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return JobCard(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PostingDetailScreen(data: data[index])))
                      },
                      image:
                          NetworkImage(data[index].data()['company_logo_link']),
                      title: data[index].data()['position'],
                      subTitle: data[index].data()['company_name'],
                      location: data[index].data()['location'],
                      jobType: data[index].data()['job-type'],
                    );
                  }));
        });
  }

  Padding buildSuggestedText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
      child: Text(
        'Suggested Job Postings',
        style: kNunitoSemiBold,
      ),
    );
  }

  // Padding buildSearchButton() {
  //   return const Padding(
  //     padding: EdgeInsets.fromLTRB(35, 15, 35, 5),
  //     child: CupertinoSearchTextField(
  //
  //       placeholder: 'Search Jobs, Companies and more...',
  //       prefixIcon: Icon(FeatherIcons.search),
  //       backgroundColor: Color(0xFFFCFCFC),
  //     ),
  //   );
  // }

  Padding buildAppLogo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(38, 23, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 23.0),
            child: Image.asset(
              'assets/images/career_wind.png',
              width: 75,
              height: 50,
            ),
          ),
          kAppName
        ],
      ),
    );
  }
}
