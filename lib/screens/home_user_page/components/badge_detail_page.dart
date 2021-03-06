import 'package:donate_blood/constants.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class DetailPage extends StatelessWidget {
  final BadgesInfo badgesInfo;

  const DetailPage({Key key, this.badgesInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  //alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, right: 10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      badgesInfo.iconImage,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 330),
                  Text(
                    badgesInfo.name,
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 30,
                      color: const Color(0xff47455f),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    badgesInfo.description ?? '',
                    //maxLines: 14,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 20,
                      color: const Color(0xff868686),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
