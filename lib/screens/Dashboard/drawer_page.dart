import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:counsller_flutter_app/screens/Dashboard/call_history.dart';
import 'package:counsller_flutter_app/screens/Dashboard/chat_history.dart';
import 'package:counsller_flutter_app/screens/Dashboard/customer_call_support_screen.dart';
import 'package:counsller_flutter_app/screens/Dashboard/user_profile.dart';
import 'package:counsller_flutter_app/screens/Dashboard/wallet_transaction_screen.dart';
import 'package:counsller_flutter_app/screens/Sign_up/Login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

// ignore: must_be_immutable
class Drawerpage extends StatefulWidget {
  Drawerpage({Key? key, this.user}) : super(key: key);
  String? user;
  @override
  State<Drawerpage> createState() => _DrawerpageState();
}

class _DrawerpageState extends State<Drawerpage> {
  // ignore: prefer_typing_uninitialized_variables
  var getData;
  String? userName;
  String? userNumber;
  String? userEmail;
  String? userProfilepic;

  bool loading = false;

  Future getProfile() async {
    setState(() {
      loading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/getuserprofile");
    var userID = await HelperFunctions.getuserID();

    Map map = {'user_id': userID};
    final response = await http.post(
      api,
      body: map,
    );
    String msg = '';
    var res = await json.decode(response.body);
    getData = res['response'];
    print("response" + response.body);
    msg = res['status_message'].toString();
    print(msg);
    try {
      if (msg == "Get Profile") {
        setState(() {
          loading = false;
          userName = getData['name'];
          userEmail = getData['email'];
          userNumber = getData['mobile'];
          userProfilepic = getData['profile_pic'];
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
        content: Text(msg.toString()),
      ));
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width / 1.4,
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(50.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: ABConstraints.themeColor,
                    child: Row(
                      children: [
                        userProfilepic == ''
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 22),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        image: NetworkImage(
                                            "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/800px-Default_pfp.svg.png"),
                                        fit: BoxFit.fill),
                                    color: Colors.white38,
                                    borderRadius: BorderRadius.circular(15),
                                    // border: Border.all(width: 1.5),
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 22),
                                child: Container(
                                  height: 100,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 1.5)),
                                  child: CachedNetworkImage(
                                    imageUrl: userProfilepic.toString(),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 70,
                                ),
                                Text(
                                  userName.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    userNumber.toString(),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                userEmail == null
                                    ? const Text(
                                        'No Email Updated',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      )
                                    : Text(
                                        userEmail.toString(),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // const Text(
                                //   "B.Tech in Computer Science & Engineering",
                                //   style: TextStyle(color: Colors.white),
                                // ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 30,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserProfile()));
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/profile.png"))),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            "My Profile",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    endIndent: 15,
                    indent: 15,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  SizedBox(
                    height: 40,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerCallSupport()));
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.headset_mic_outlined,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Customer Support Chat",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    endIndent: 15,
                    indent: 15,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  SizedBox(
                    height: 40,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletTracsaction()));
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Wallet Transaction",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700)),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    endIndent: 15,
                    indent: 15,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  SizedBox(
                    height: 40,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CallingHistory()));
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/call.png"))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Calling History",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700)),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    endIndent: 15,
                    indent: 15,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  SizedBox(
                    height: 40,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatHistory()));
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/chat.png"))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Chats With CounSellors",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700)),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 50,
                  //   child: MaterialButton(onPressed: (){
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>KYCPage()));
                  //   },child: Row(
                  //     children: [
                  //       Icon(Icons.security),
                  //       SizedBox(width: 10,),
                  //       Text("KYC",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
                  //       SizedBox(width: 40,),
                  //       Text("Verified",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w700),),
                  //       SizedBox(width: 5,),
                  //       Icon(Icons.check_circle_outline,color: Colors.green,)
                  //     ],
                  //   ),),
                  // ),
                  // Container(
                  //   height: 50,
                  //   child: MaterialButton(onPressed: (){
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>MyFav()));
                  //   },child: Row(
                  //     children: [
                  //       Icon(Icons.favorite_border),
                  //       SizedBox(width: 10,),
                  //       Text("Your Favorite",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
                  //     ],
                  //   ),),
                  // ),
                  const Divider(
                    endIndent: 15,
                    indent: 15,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  SizedBox(
                    height: 50,
                    child: MaterialButton(
                      onPressed: () {},
                      child: Row(
                        children: const [
                          Icon(
                            Icons.card_giftcard,
                            color: Colors.purple,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Refer & Earn",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700)),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    endIndent: 15,
                    indent: 15,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                  SizedBox(
                    height: 50,
                    child: MaterialButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      const Text("Are you sure want to Log Out?"),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                final pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var user_id =
                                                    pref.remove('user_id');
                                                // await HelperFunctions.saveUserLoggedInSharedPreference(false);
                                                // ignore: use_build_context_synchronously
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen()));
                                                // await HelperFunctions
                                                //     .saveUserLoggedInSharedPreference(
                                                //         false);
                                                // // ignore: use_build_context_synchronously
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //            const LoginScreen()));
                                              },
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color: ABConstraints.btn),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No")),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/logout.png"))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Log Out",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700)),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    endIndent: 15,
                    indent: 15,
                    thickness: 0.5,
                    color: Colors.black38,
                  ),
                ],
              ));
  }
}
