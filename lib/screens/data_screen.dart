 import 'package:ali_hassan/controllers/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<FormController>(FormController());
    return Scaffold(
      appBar: AppBar(
        title: Text("New Todo Task",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: ctrl.formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               InkWell(
                  onTap: () {
                    ctrl.pickImage();
                  },
                  child: GetBuilder<FormController>(
                    builder: (formCtrl) {
                      return CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            formCtrl.image != null
                                ? FileImage(formCtrl.image!)
                                : null,
                        child:
                            formCtrl.image == null
                                ? Icon(Icons.person, size: 30)
                                : null,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: ctrl.titlCtrl,
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  validator: ctrl.simpleValidator,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: ctrl.descCtrl,
                  validator: ctrl.simpleValidator,
                  decoration: InputDecoration(
                    labelText: "Task Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                GetBuilder<FormController>(builder: (formCtrl) {
                  return ListTile(
                    tileColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: Text(
                      formCtrl.dateTime == null
                          ? "Select Date"
                          : DateFormat("yMMMMd")
                              .format(formCtrl.dateTime as DateTime)
                              .toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing:
                        Icon(Icons.calendar_today, color: Colors.deepPurple),
                    onTap: () {
                      formCtrl.pickDate(context);
                    },
                  );
                }),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    ctrl.checkValidation().then((value) {
                      ctrl.uploadData();
                    });
                  },
                  child: Container(
                    height: 50,
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
