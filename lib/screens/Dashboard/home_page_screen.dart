import 'package:counsller_flutter_app/HelperFunctions/HelperFunctions.dart';
import 'package:counsller_flutter_app/screens/Dashboard/Call_page.dart';
import 'package:counsller_flutter_app/screens/Dashboard/addMoney.dart';
import 'package:counsller_flutter_app/screens/Dashboard/chat_page.dart';
import 'package:counsller_flutter_app/screens/Dashboard/counselor_profile.dart';
import 'package:counsller_flutter_app/screens/Dashboard/drawer_page.dart';
import 'package:flutter/material.dart';
import '../../Constraints_color/constraints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String walletbalance = "";
  bool isloading = false;
  String? Savuserid;
  void saveuserId() async {
    var userID = await HelperFunctions.getuserID();
    setState(() {
      Savuserid = userID;
    });
  }

  Future getBalance() async {
    setState(() {
      isloading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/getUserBalance");
    var userID = await HelperFunctions.getuserID();
    Map mapeddate = {'user_id': userID.toString()};

    final response = await http.post(
      api,
      body: mapeddate,
    );
    String msg = '';
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    try {
      if (msg == 'Successful') {
        setState(() {
          isloading = false;
          walletbalance = res['response']['balance'].toString();
        });
      } else {
        setState(() {
          isloading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print(e);
    }
  }

  String? popular_counseller_0;
  String? popular_counseller_1;

  Future get_popular_counsellor() async {
    setState(() {
      isloading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/popular_counsellor");
    // var userID = await HelperFunctions.getuserID();
    // Map mapeddate = {'user_id': userID.toString()};

    final response = await http.get(
      api,
      // body: mapeddate,
    );
    int msg;
    var res = await json.decode(response.body);
    msg = res['status_code'];
    try {
      if (msg == 200) {
        setState(() {
          isloading = false;
          popular_counseller_0 = res['popular_counseller']['0'].toString();
          popular_counseller_1 = res['popular_counseller']['1'].toString();
          getPopularCounslerDeatils0(popular_counseller_0.toString());
          getPopularCounslerDeatils1(popular_counseller_1.toString());
          // print(res['popular_counseller']['0']);
          // print(res['popular_counseller']['1']);
        });
      } else {
        setState(() {
          isloading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print(e);
    }
  }

  String? getPopularCounsllerName0;
  String? getPopularCounsllerRate0;
  String? getPopularCounsllerProfilepic0;
  String? getPopularCounsllerRNumber0;
  String? getPopularCounsllerEmailAdress0;
  String? getPopularCounsllerGender0;
  String? getPopularCounsllerCity0;
  String? getPopularCounsllerState0;
  String? getPopularCounsllerDob0;

  // String? getPopularCounsllerProfilepic0;
  // String? getPopularCounsllerProfilepic0;

  String? getPopularCounsllerName1;
  String? getPopularCounsllerRate1;
  String? getPopularCounsllerProfilepic1;
  String? getPopularCounsllerRNumber1;
  String? getPopularCounsllerEmailAdress1;
  String? getPopularCounsllerGender1;
  String? getPopularCounsllerCity1;
  String? getPopularCounsllerState1;
  String? getPopularCounsllerDob1;

  Future getPopularCounslerDeatils0(String listner_id) async {
    setState(() {
      isloading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/getlistenerprofile");
    Map mapeddate = {'listner_id': listner_id.toString()};

    final response = await http.post(
      api,
      body: mapeddate,
    );
    String msg = '';
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    try {
      if (msg == 'Get Profile') {
        setState(() {
          getPopularCounsllerName0 = res['response']['name'];
          getPopularCounsllerRate0 = res['response']['call_rate'];
          getPopularCounsllerProfilepic0 = res['response']['profile_pic'];
          getPopularCounsllerRNumber0 = res['response']['mobile'];
          getPopularCounsllerEmailAdress0 = res['response']['email'];
          getPopularCounsllerGender0 = res['response']['gender'];
          getPopularCounsllerCity0 = res['response']['city'];
          getPopularCounsllerState0 = res['response']['state'];
          getPopularCounsllerDob0 = res['response']['dob'];
          isloading = false;

          // print(res.toString());
        });
      } else {
        setState(() {
          isloading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print(e);
    }
  }

  Future getPopularCounslerDeatils1(String listner_id) async {
    setState(() {
      isloading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/getlistenerprofile");
    Map mapeddate = {'listner_id': listner_id.toString()};

    final response = await http.post(
      api,
      body: mapeddate,
    );
    String msg = '';
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    try {
      if (msg == 'Get Profile') {
        setState(() {
          getPopularCounsllerName1 = res['response']['name'];
          getPopularCounsllerRate1 = res['response']['call_rate'];
          getPopularCounsllerProfilepic1 = res['response']['profile_pic'];
          getPopularCounsllerRNumber1 = res['response']['mobile'];
          getPopularCounsllerEmailAdress1 = res['response']['email'];
          getPopularCounsllerGender1 = res['response']['gender'];
          getPopularCounsllerCity1 = res['response']['city'];
          getPopularCounsllerState1 = res['response']['state'];
          getPopularCounsllerDob1 = res['response']['dob'];
          isloading = false;
          print('ret' + res.toString());
        });
      } else {
        setState(() {
          isloading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      setState(() {
        isloading = false;
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
    getBalance();
    get_popular_counsellor();
    saveuserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: Drawerpage(),
          appBar: AppBar(
            backgroundColor: ABConstraints.themeColor,
            // backgroundColor:Colors.white,
            title: const Text(
              "Home",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            elevation: 0.0,
            foregroundColor: ABConstraints.white,
            actions: [
              // InkWell(
              //   onTap: () {
              //     // Navigator.push(context,
              //     //     MaterialPageRoute(builder: (context) => CallScreen()));
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(
              //       vertical: 11,
              //     ),
              //     decoration: BoxDecoration(
              //         //color: ABConstraints.themeColor,
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(
              //           width: 1,
              //           color: Colors.white,
              //         )),
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 6, right: 6),
              //       child: Row(
              //         children: const [
              //           Icon(
              //             Icons.call,
              //             color: Colors.green,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMoney()));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                      //color: ABConstraints.themeColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '₹ ${walletbalance.toString()}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              )
            ],
          ),
          body: isloading
              ? const Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                                // border: Border.all(width: 5,color: ABConstraints.btn),
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image: AssetImage("images/banner1.png"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Popular Counselor",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3.45,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3.48,
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white70,
                                    elevation: 1,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: ABConstraints.themeColor,
                                                width: 1),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  getPopularCounsllerProfilepic0
                                                      .toString()),
                                              fit: BoxFit.fill,
                                            ),
                                            // shape: BoxShape.circle
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          getPopularCounsllerName0.toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "₹ $getPopularCounsllerRate0/min",
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 30,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6)),
                                              border: Border.all(
                                                  color:
                                                      ABConstraints.themeColor,
                                                  width: 1)),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CounselorProfile(
                                                            getPopularCounsllerrId:
                                                                popular_counseller_0,
                                                            getPopularCounsllerName:
                                                                getPopularCounsllerName0,
                                                            getPopularCounsllerRate:
                                                                getPopularCounsllerRate0,
                                                            getPopularCounsllerProfilepic:
                                                                getPopularCounsllerProfilepic0,
                                                            getPopularCounsllerRNumber:
                                                                getPopularCounsllerRNumber0,
                                                            getPopularCounsllerEmailAdress:
                                                                getPopularCounsllerEmailAdress0,
                                                            getPopularCounsllerGender:
                                                                getPopularCounsllerGender0,
                                                            getPopularCounsllerCity:
                                                                getPopularCounsllerCity0,
                                                            getPopularCounsllerState:
                                                                getPopularCounsllerState0,
                                                            getPopularCounsllerDob:
                                                                getPopularCounsllerDob0,
                                                          )));
                                            },
                                            child: Text(
                                              "Connect",
                                              style: TextStyle(
                                                color: ABConstraints.themeColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3.48,
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Card(
                                    color: Colors.white70,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 1,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      ABConstraints.themeColor,
                                                  width: 1),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    getPopularCounsllerProfilepic1
                                                        .toString()),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: BoxShape.circle),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          getPopularCounsllerName1.toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "₹ $getPopularCounsllerRate1/min",
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 30,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6)),
                                              border: Border.all(
                                                  color:
                                                      ABConstraints.themeColor,
                                                  width: 1)),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CounselorProfile(
                                                            getPopularCounsllerrId:
                                                                popular_counseller_1,
                                                            getPopularCounsllerName:
                                                                getPopularCounsllerName1,
                                                            getPopularCounsllerRate:
                                                                getPopularCounsllerRate1,
                                                            getPopularCounsllerProfilepic:
                                                                getPopularCounsllerProfilepic1,
                                                            getPopularCounsllerRNumber:
                                                                getPopularCounsllerRNumber1,
                                                            getPopularCounsllerEmailAdress:
                                                                getPopularCounsllerEmailAdress1,
                                                            getPopularCounsllerGender:
                                                                getPopularCounsllerGender1,
                                                            getPopularCounsllerCity:
                                                                getPopularCounsllerCity1,
                                                            getPopularCounsllerState:
                                                                getPopularCounsllerState1,
                                                            getPopularCounsllerDob:
                                                                getPopularCounsllerDob1,
                                                          )));
                                            },
                                            child: Text(
                                              "Connect",
                                              style: TextStyle(
                                                color: ABConstraints.themeColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2.1,
                              decoration: BoxDecoration(
                                  color: ABConstraints.themeColor,
                                  // color: Colors.blue[300],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: MaterialButton(
                                onPressed: () async {
                                  // var prefs = await SharedPreferences.getInstance();
                                  // var user_id4 = prefs.getString('user_id');
                                  // setState(() {
                                  //   print(user_id4.toString());
                                  // });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => chat_page()));
                                },
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.chat_bubble_outline_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Chat with Counselor",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Colors.red.shade400,
                                        Color(0xffaa2516)
                                      ]),
                                  // color: Colors.red[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Call_page()));
                                },
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.call_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Call with Counselor",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: const [
                            Center(
                              child: Text(
                                "Our Facilities",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5.2,
                                          decoration: BoxDecoration(
                                              // color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(70)),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                                Icons.folder_copy_outlined,
                                                size: 45,
                                                color: Colors.green[300]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Experience",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5.2,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                                Icons.privacy_tip_outlined,
                                                size: 40,
                                                color: Colors.blue[300]),
                                          ),
                                        ),
                                        const Text(
                                          "Availabale",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.black
                                              // color: ABConstraints.btn
                                              ),
                                        ),
                                        const Text(
                                          "24X7",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.black
                                              // color: ABConstraints.btn
                                              ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5.2,
                                          decoration: BoxDecoration(
                                              // color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(70)),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.call,
                                                size: 40,
                                                color: ABConstraints.btn),
                                          ),
                                        ),
                                        const Text(
                                          "Calling with",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        const Text(
                                          "Counsellor",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
