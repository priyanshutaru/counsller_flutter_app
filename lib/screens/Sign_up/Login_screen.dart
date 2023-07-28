import 'dart:convert';
import 'dart:io';

import 'package:counsller_flutter_app/screens/Sign_up/Name_page.dart';
import 'package:counsller_flutter_app/screens/Sign_up/OTP_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? phoneNumber;
  final TextEditingController _mobileNumber = TextEditingController();
  final _formKey = GlobalKey();
  bool loading = false;

  Future Login() async {
    setState(() {
      loading = true;
    });
    var api = Uri.parse("https://counsellor.creditmywallet.in.net/api/login");
    Map mapeddate = {
      "mobile": _mobileNumber.text.toString(),
    };
    await HelperFunctions.saveUserLoggedInSharedPreference(true);

    final response = await http.post(
      api,
      body: mapeddate,
    );
    String msg = '';
    var res = await json.decode(response.body);
    print("response" + response.body);
    msg = res['status_message'].toString();
    print(msg);
    try {
      if (msg == 'OTP Sent Successfully') {
        setState(() {
          loading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPpage(
                        mobile: _mobileNumber.text.toString(),
                      )));
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

  void _onCountryChange(CountryCode countryCode) {
    phoneNumber = countryCode.toString();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('New Country selected: "${countryCode.toString()}'),
    ));
  }

    Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, elevation: 0),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, elevation: 0),
                //return true when click on "Yes"
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: WillPopScope(
          onWillPop: showExitPopup,
          child: Scaffold(
              body: loading
                  ? const Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 70,
                          ),
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "images/councellor.jpeg",
                                      ),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.53,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.blue.shade400,
                                        const Color(0xff0096bb),
                                        const Color(0xff0096bb),
                                      ]),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Center(
                                      child: Text(
                                        "Login/SignUP",
                                        style: TextStyle(
                                            color: ABConstraints.blackshade,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Form(
                                      key: _formKey,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        child: TextFormField(
                                          controller: _mobileNumber,
                                          maxLength: 10,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            counterText: '',
                                            contentPadding:
                                                const EdgeInsets.all(15.0),
                                            border: InputBorder.none,
                                            hintText: "Mobile Number",
                                            hintStyle: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff878383),
                                                fontSize: 14),
                                            prefixIcon: CountryCodePicker(
                                              onChanged: _onCountryChange,
                                              initialSelection: 'IN',
                                              favorite: const ['+91', 'INDIA'],
                                              showCountryOnly: false,
                                              showOnlyCountryWhenClosed: false,
                                              alignLeft: false,
                                              padding: const EdgeInsets.all(10),
                                            ), // pass the hint text parameter here
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: MaterialButton(
                                          color: ABConstraints.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onPressed: () {
                                            Login();
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                              ),
                                              Center(
                                                child: Text(
                                                  "Send OTP",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: ABConstraints.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "By Signing up, you agree to our ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: ABConstraints.blackshade),
                                        ),
                                        Text(
                                          "Terms of use ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: ABConstraints.red,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "and ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: ABConstraints.blackshade),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Privacy Policy",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: ABConstraints.red,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Or",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: MaterialButton(
                                          color: Colors.black12,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Namepage()));
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                              ),
                                              Center(
                                                child: Text(
                                                  "Registration",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: ABConstraints.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )),
        ));
  }
}
