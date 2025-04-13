import 'package:ali_hassan/controllers/form_controller.dart';
import 'package:ali_hassan/screens/data_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<FormController>(FormController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => DataScreen());
        },
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      height: 80,
                      width: 80,
                      child: data[index]["image_url"] == null
                          ? Icon(Icons.question_mark)
                          : Image.network(
                              data[index]["image_url"],
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      data[index]["title"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index]["desc"],
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(height: 5),
                          Text(
                            data[index]["date"],
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            ctrl.pickImage();
                                          },
                                          child: GetBuilder<FormController>(
                                              builder: (formCtrl) {
                                            return CircleAvatar(
                                              radius: 70,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              child: formCtrl.image == null
                                                  ? Image.network(
                                                      data[index]["image_url"],
                                                    )
                                                  : ClipOval(
                                                      child: Image.asset(ctrl
                                                          .image
                                                          .toString())),
                                            );
                                          }),
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: ctrl.titlCtrl,
                                          decoration: InputDecoration(
                                              labelText: "Task Title",
                                              border: OutlineInputBorder()),
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: ctrl.descCtrl,
                                          decoration: InputDecoration(
                                              labelText: "Task Description",
                                              border: OutlineInputBorder()),
                                          maxLines: 3,
                                        ),
                                        SizedBox(height: 10),
                                        GetBuilder<FormController>(
                                            builder: (formCtrl) {
                                          return ListTile(
                                            title: Text(
                                              formCtrl.dateTime == null
                                                  ? "Select Date"
                                                  : DateFormat("yMMMMd")
                                                      .format(formCtrl.dateTime
                                                          as DateTime)
                                                      .toString(),
                                            ),
                                            trailing: Icon(Icons.calendar_today,
                                                color: Colors.deepPurple),
                                            onTap: () {
                                              formCtrl.pickDate(context);
                                            },
                                          );
                                        }),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            ctrl.updateData(data[index]["id"]);
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                            child: Text("Update",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(data[index]["id"])
                                .delete();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
                child: Text("No Data Available",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
          }
        },
      ),
    );
  }
}
