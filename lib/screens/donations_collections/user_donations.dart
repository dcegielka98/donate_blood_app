import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate_blood/Screens/home_user_page/components/user_detail.dart';
import 'package:donate_blood/components/no_donation_message.dart';
import 'package:donate_blood/constants.dart';
import 'package:donate_blood/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:donate_blood/generated/l10n.dart';
import 'package:provider/provider.dart';

class UserDonations extends StatefulWidget {
  final bool setLimit;
  final ScrollController controller;

  UserDonations(this.setLimit, this.controller);

  @override
  _UserDonationsState createState() => _UserDonationsState();
}

class _UserDonationsState extends State<UserDonations> {
  Query _userDonations;

  @override
  void initState() {
    super.initState();
    _userDonations = context.read<Repository>().getUserDonations();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: widget.setLimit
            ? _userDonations
                .orderBy('donationDate', descending: false)
                .limitToLast(2)
                .snapshots()
            : _userDonations.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(S.current.somethingWentWrong);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return new ListView(
            controller: widget.controller,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            children: snapshot.data.size == 0
                ? [
                    NoDonationMessage(),
                  ]
                : snapshot.data.docs.map(
                    (DocumentSnapshot document) {
                      return Container(
                        padding: EdgeInsets.all(4.0),
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 0,
                        ),
                        child: Column(
                          children: [
                            new ListTile(
                              leading: CircleAvatar(
                                child: SvgPicture.asset(
                                    'assets/icons/blood-donation.svg'),
                                backgroundColor: Colors.white,
                              ),
                              title: new Text(
                                document.data()['donationType'],
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                              subtitle: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text(
                                    S.current.amount +
                                        ': ' +
                                        document.data()['amount'].toString() +
                                        ' ml',
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  new Text(S.current.date +
                                      ": " +
                                      convertTimeStamp(
                                          document.data()['donationDate'])),
                                  Divider(
                                    thickness: 3,
                                  ),
                                  // new Text(formatTime(document.data()['created'])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
          );
        },
      ),
    );
  }
}
