import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';

const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;
Size screenSize(context) => MediaQuery.of(context).size;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
AuthController authController = AuthController.instance;