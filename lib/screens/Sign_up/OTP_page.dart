import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';
import '../Dashboard/dashboard_page.dart';
import 'package:http/http.dart' as http;

class OTPpage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const OTPpage({Key? key, this.mobile, this.name, this.email, this.user_id})
      : super(key: key);
  final String? mobile;
  final String? name;
  final String? email;
  // ignore: non_constant_identifier_names
  final String? user_id;
  @override
  State<OTPpage> createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {
  void _set_user_id(value) async {
    final prefs = await SharedPreferences.getInstance();
    var set1 = prefs.setString("user_id", value);
    print(set1.toString());
  }

  bool loading = false;

  Future verifyNumber() async {
    setState(() {
      loading = true;
    });
    var api =
        Uri.parse("https://counsellor.creditmywallet.in.net/api/verify_otp");
    Map mapeddate = {
      'mobile': widget.mobile.toString(),
      'otp': otp.text.toString(),
    };
    final response = await http.post(
      api,
      body: mapeddate,
    );
    String msg = '';
    var res = await json.decode(response.body);
    print("response" + response.body);
    msg = res["status_message"].toString();
    print(msg);
    try {
      if (msg == "OTP Verification Successful") {
        setState(() {
          loading = false;

          String user_id4 = res['user_id'];
          HelperFunctions.saveuserID(res['user_id']);
          _set_user_id(res['user_id']);
          print(user_id4.toString());
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => dashboard_page(
                name: '${widget.name}',
                email: '${widget.email}',
                mobile: '${widget.mobile}',
                userid: user_id4.toString(),
              ),
            ),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(msg.toString()),
          ));
        });
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

  TextEditingController otp = TextEditingController();
  TextEditingController userid = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ABConstraints.themeColor,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: ABConstraints.blackshade,
              ),
            ),
            centerTitle: true,
            title: Text(
              "OTP Verification",
              style: TextStyle(
                color: ABConstraints.blackshade,
              ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bg.jpg"), fit: BoxFit.fill)),
            //padding: EdgeInsets.symmetric(horizontal: 25),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        child: Container(
                            height: MediaQuery.of(context).size.height / 2.5,
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
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text(
                                      "OTP sent to ${widget.mobile}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Form(
                                      key: formKey,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: PinCodeTextField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please Enter Valid OTP";
                                              }
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  6)
                                            ],
                                            controller: otp,
                                            obscuringCharacter: '*',
                                            appContext: context,
                                            length: 6,
                                            obscureText: false,
                                            blinkWhenObscuring: true,
                                            pinTheme: PinTheme(
                                                borderWidth: 0.1,
                                                shape: PinCodeFieldShape.box,
                                                fieldHeight: 55,
                                                fieldWidth: 45,
                                                activeFillColor: Colors.white,
                                                disabledColor: Colors.white,
                                                inactiveColor: Colors.white,
                                                inactiveFillColor: Colors.white,
                                                selectedFillColor: Colors.white,
                                                errorBorderColor: Colors.red,
                                                activeColor: Colors.white,
                                                selectedColor: Colors.white),
                                            cursorColor: Colors.black54,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            enableActiveFill: true,
                                            keyboardType: TextInputType.number,
                                            boxShadows: const [
                                              BoxShadow(
                                                offset: Offset(0, 1),
                                                color: Colors.blueAccent,
                                                blurRadius: 1,
                                              )
                                            ],
                                            onCompleted: (v) {
                                              debugPrint("Completed");
                                            },
                                            onChanged: (value) {
                                              debugPrint(value);
                                              setState(() {});
                                            },
                                            beforeTextPaste: (text) {
                                              debugPrint(
                                                  "Allowing to paste $text");
                                              return true;
                                            },
                                          )),
                                    ),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side:
                                              BorderSide(color: Colors.black)),
                                      onPressed: () {
                                        verifyNumber();
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
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          'Resend Otp : ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                        ),
                                      ),
                                      Countdown(
                                        seconds: 20,
                                        build: (BuildContext context,
                                                double time) =>
                                            Text(
                                          time.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        interval: const Duration(seconds: 1),
                                        onFinished: () {
                                          // print('Timer is done!');
                                          Fluttertoast.showToast(
                                              msg: "Re-send OTP");
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
          )),
    );
  }
}
