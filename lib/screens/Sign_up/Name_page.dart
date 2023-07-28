import 'dart:convert';
import 'dart:io';

import 'package:counsller_flutter_app/screens/Sign_up/Login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';
import 'package:http/http.dart' as http;

class Namepage extends StatefulWidget {
  const Namepage({Key? key}) : super(key: key);
  @override
  State<Namepage> createState() => _NamepageState();
}

class _NamepageState extends State<Namepage> {
  String? dob;
  late DateTime _myDateTime;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  Future signUpFunction() async {
    setState(() {
      loading = true;
    });
    await HelperFunctions.saveUserLoggedInSharedPreference(true);
    var api =
        Uri.parse('https://counsellor.creditmywallet.in.net/api/register');
    Map map = {
      'name': _name.text.toString(),
      'email': _email.text.toString(),
      'mobile': _mobile.text.toString(),
      'dob': _myDateTime.toString()
    };
    final response = await http.post(
      api,
      body: map,
    );
    String msg = '';
    var res = await json.decode(response.body);
    print("response" + response.body);
    msg = res['status_message'].toString();
    print(msg);
    try {
      if (res == 'Successful') {
        setState(() {
          loading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        });
      } else {
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print(e);
    }
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: ABConstraints.themeColor,
            centerTitle: true,
            title: Text(
              "Create Your Profile",
              style: TextStyle(
                color: ABConstraints.blackshade,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/bg.jpg"),
                            fit: BoxFit.fill)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Center(
                              child: Row(
                            children: const [
                              Text(
                                "Registration Now",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: Colors.white70),
                              ),
                            ],
                          )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        // SizedBox(height: MediaQuery.of(context).size.height*0.35,),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30)),
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade400,
                                  const Color(0xff0096bb),
                                  const Color(0xff0096bb),
                                ]),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                    "What is your name ?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
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
                                    controller: _name,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15.0),
                                      border: InputBorder.none,
                                      hintText: "Enter Your Name",
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
                                    "What is your email ?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
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
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _email,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15.0),
                                      border: InputBorder.none,
                                      hintText: "Enter Your Email",
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
                                    "What is your mobile Number ?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
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
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    controller: _mobile,
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      contentPadding: EdgeInsets.all(15.0),
                                      border: InputBorder.none,
                                      hintText: "Enter Your Mobile Number",
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
                                    "What is your dob ?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    _myDateTime = (await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2050),
                                    ))!;
                                    setState(() {
                                      dob = DateFormat('yyyy-MM-dd')
                                          .format(_myDateTime);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3, bottom: 3),
                                    child: Container(
                                        height: 45,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 14,
                                            ),
                                            dob != null
                                                ? Text(dob.toString())
                                                : const Text("Select DOB"),
                                          ],
                                        )),
                                  ),
                                ),
                              
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: MaterialButton(
                                    color: ABConstraints.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color: Colors.black54)),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        signUpFunction();
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('Something went wrong!'),
                                        ));
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: ABConstraints.white,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          )),
    );
  }


}
