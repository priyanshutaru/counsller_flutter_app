import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class CustomerCallSupport extends StatefulWidget {
  const CustomerCallSupport({super.key});

  @override
  State<CustomerCallSupport> createState() => _CustomerCallSupportState();
}

class _CustomerCallSupportState extends State<CustomerCallSupport> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String? msg;
  var getData;

  String? userName;
  String? userNumber;
  String? userEmail;
  String? userProfilepic;
  String? userdob;
  String? userGender;
  String? userCity;
  String? userState;

  final TextEditingController _message = TextEditingController();
  final TextEditingController _topics = TextEditingController();

  Future getProfile() async {
    setState(() {
      loading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/getuserprofile");
    var userID = await HelperFunctions.getuserID();
    print(userID.toString());
    Map map = {'user_id': userID};
    final response = await http.post(
      api,
      body: map,
    );
    String msg = '';
    var res = await json.decode(response.body);
    getData = res['response'];
    msg = res['status_message'].toString();
    try {
      if (msg == "Get Profile") {
        setState(() {
          loading = false;
          userName = getData['name'];
          userEmail = getData['email'];
          userNumber = getData['mobile'];
          userProfilepic = getData['profile_pic'];
          userdob = getData['dob'];
          userGender = getData['gender'];
          userCity = getData['city'];
          userState = getData['state'];
        });
      } else {
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            msg.toString(),
          ),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  void customerCallSupport() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
      'name': userName.toString(),
      'mobile': userNumber.toString(),
      'email': userEmail.toString(),
      'message': _message.text.toString(),
      'topics': _topics.text.toString(),
    };

    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/customer_support");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    msg = res['status_message'];

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg: msg.toString(),
        fontSize: 14,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg: msg.toString(),
        fontSize: 14,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
      throw Exception('unexpected error occurred');
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ABConstraints.themeColor,
          foregroundColor: Colors.white,
          title: const Text(
            "Customer Support Chat",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        body: SingleChildScrollView(
          child: loading
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "What is your message ?",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: _message,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                border: InputBorder.none,
                                hintText: "Enter Your Message",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff878383),
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "What are your topics ?",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              controller: _topics,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                border: InputBorder.none,
                                hintText: "Enter Your topics",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff878383),
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: MaterialButton(
                              color: ABConstraints.themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  customerCallSupport();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Something Went Wrong!');
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: ABConstraints.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
        ));
  }
}
