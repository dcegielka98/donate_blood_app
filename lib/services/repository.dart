import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate_blood/generated/l10n.dart';
import 'package:donate_blood/services/authentication.dart';

class Repository {
  Repository(this._firestore) : assert(_firestore != null);
  final FirebaseFirestore _firestore;

  Stream<DocumentSnapshot> getUserData() {
    return _firestore
        .collection('users')
        .doc(Auth().getCurrentUser().uid)
        .snapshots();
  }

  Query getUsers() {
    return _firestore.collection('users');
  }

  Query getUserDonations() {
    return _firestore.collection('donations').where('userId',
        isEqualTo: _firestore.doc('/users/' + Auth().getCurrentUser().uid));
  }

  Query getNurseCollections() {
    return _firestore.collection('donations').where('nurseId',
        isEqualTo: _firestore.doc('/users/' + Auth().getCurrentUser().uid));
  }

  Future<void> addEvent(
      String donationType, String location, String eventType, DateTime date) {
    return _firestore
        .collection('events')
        .add({
          'donationType': donationType,
          'location': location,
          'eventType': eventType,
          'date': date
        })
        .then((value) => print("events added"))
        .catchError((error) => print("Failed to add event: $error"));
  }

  Future<void> addDonation(String user, String nurse, String donationType,
      int amount, DateTime donationDate) {
    return _firestore
        .collection('donations')
        .add({
          'amount': amount,
          'userId': _firestore.doc('/users/' + user),
          'nurseId': _firestore.doc('/users/' + nurse),
          'donationType': donationType,
          'donationDate': donationDate
        })
        .then((value) => print("donation added"))
        .catchError((error) => print("Failed to add donation: $error"));
  }

  Future<String> updateUser(String fullName, String gender,
      DateTime dateOfBirth, String phoneNumber, String bloodGroup) async {
    return await _firestore
        .collection('users')
        .doc(Auth().getCurrentUser().uid)
        .update({
          'fullName': fullName,
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'phoneNumber': phoneNumber,
          'bloodGroup': bloodGroup
        })
        .then((value) => S.current.userDataHasBeenSuccessfullyUpdated)
        .catchError((error) => S.current.userDataHasNotBeenUpdated + '$error');
  }

  Future<void> addFcmTokenToUser(String token) async {
    await _firestore
        .collection('users')
        .doc(Auth().getCurrentUser().uid)
        .update({
      'tokens': FieldValue.arrayUnion([token])
    });
  }

  Future<void> removeFcmTokenFromUser(String token) async {
    await _firestore
        .collection('users')
        .doc(Auth().getCurrentUser().uid)
        .update({
      'tokens': FieldValue.arrayRemove([token])
    });
  }

  List getBloodGroups() {
    return [
      {
        "value": "AB+",
      },
      {
        "value": "AB-",
      },
      {
        "value": "A+",
      },
      {
        "value": "A-",
      },
      {
        "value": "B+",
      },
      {
        "value": "B-",
      },
      {
        "value": "0+",
      },
      {
        "value": "0-",
      }
    ];
  }

  List getDonationType() {
    return [
      {
        "display": S.current.wholeBlood,
        "value": "Whole blood",
      },
      {"display": S.current.plasma, "value": "Plasma"},
      {"display": S.current.platelets, "value": "Platelets"},
    ];
  }

  List getGenders() {
    return [
      {
        "display": S.current.male,
        "value": "male",
      },
      {
        "display": S.current.female,
        "value": "female",
      },
    ];
  }

  List getEventType() {
    return [
      {
        "display": S.current.urgentBloodDonation,
        "value": "urgent",
      },
      {
        "display": S.current.normalBloodDonation,
        "value": "normal",
      },
    ];
  }
}
