import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormController extends GetxController {
  final titlCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final formkey = GlobalKey<FormState>();
  DateTime? dateTime;
  File? image;

  String? simpleValidator(String? value) {
    if (value!.isEmpty) {
      return "* Please fill this feild";
    }
    return null;
  }

  Future<void> checkValidation() async {
    if (formkey.currentState!.validate()) {
      return;
    }
  }

  pickDate(context) async {
    var tempDate = await showDatePicker(
        firstDate: DateTime(2000),
        lastDate: DateTime(4000),
        initialDate: DateTime.now(),
        context: context);

    if (tempDate != null) {
      dateTime = tempDate;
      update();
    }
  }

  Future<void> pickImage() async {
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempImage != null) {
      image = File(tempImage.path);
      update();
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String id = UniqueKey().toString();

  Future<void> uploadData() async {
    Map<String, dynamic> data = {
      "title": titlCtrl.text,
      "desc": descCtrl.text,
      "date": dateTime.toString(),
      "image_url": image?.path,
      "id": id,
    };
    await firestore.collection("users").doc(id).set(data);
    titlCtrl.clear();
    descCtrl.clear();
    Get.snackbar("Crude notes", "Saved sucessfully");
  }

  Future<void> updateData(userId) async {
    Map<String, dynamic> newData = {
      "title": titlCtrl.text,
      "desc": descCtrl.text,
      "date": dateTime.toString(),
      "image_url":image?.path,
    };
    await firestore.collection("users").doc(userId).update(newData);
    Get.snackbar("Crude notes", "Updated sucessfully");
  }
}
