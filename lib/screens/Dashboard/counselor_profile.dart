import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class CounselorProfile extends StatefulWidget {
  String? getPopularCounsllerName;
  String? getPopularCounsllerRate;
  String? getPopularCounsllerProfilepic;
  String? getPopularCounsllerRNumber;
  String? getPopularCounsllerEmailAdress;
  String? getPopularCounsllerGender;
  String? getPopularCounsllerCity;
  String? getPopularCounsllerState;
  String? getPopularCounsllerDob;
  String? getPopularCounsllerrId;
  CounselorProfile({
    Key? key,
    this.getPopularCounsllerName,
    this.getPopularCounsllerRate,
    this.getPopularCounsllerProfilepic,
    this.getPopularCounsllerRNumber,
    this.getPopularCounsllerEmailAdress,
    this.getPopularCounsllerGender,
    this.getPopularCounsllerCity,
    this.getPopularCounsllerState,
    this.getPopularCounsllerDob,
    this.getPopularCounsllerrId,
  }) : super(key: key);
  @override
  State<CounselorProfile> createState() => _CounselorProfileState();
}

class _CounselorProfileState extends State<CounselorProfile> {
  bool loading = false;
  String msg = '';
  final TextEditingController inviteeUsersIDTextCtrl = TextEditingController();
  List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
    List<ZegoUIKitUser> invitees = [];

    var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
    inviteeIDs.split(",").forEach((inviteeUserID) {
      if (inviteeUserID.isEmpty) {
        return;
      }

      invitees.add(ZegoUIKitUser(
        id: inviteeUserID,
        name: 'user_$inviteeUserID',
      ));
    });

    return invitees;
  }

  void onSendCallInvitationFinished(
      String code, String message, List<String> errorInvitees) {
    if (errorInvitees.isNotEmpty) {
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        var userID = errorInvitees.elementAt(index);
        userIDs += userID + ' ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = 'User doesn\'t exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }

  Future<String> getUniqueUserId() async {
    var userID = await HelperFunctions.getuserID();

    return userID!;
  }

  String? call_his_id;

  Future callend() async {
    var api =
        Uri.parse("https://counsellor.creditmywallet.in.net/api/end_call");
    var userID = await HelperFunctions.getuserID();
    var currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hms().format(now);
    Map map = {
      'room_id': userID.toString(),
      'call_id': call_his_id.toString(),
      'call_end_by': userID.toString(),
      'end_date': currentDate.toString(),
      'end_time': formattedTime.toString(),
    };
    print('ankit $map');
    final response = await http.post(
      api,
      body: map,
    );
    String msg = '';
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    print('ankit $msg');
    try {
      if (msg == "Call has been Ended") {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg.toString()),
      ));
    }
  }

  Widget callButton(bool isVideoCall) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        var invitees = getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text);
        return ZegoSendCallInvitationButton(
          isVideoCall: isVideoCall,
          invitees: invitees,
          resourceID: "zegouikit_call",
          iconSize: const Size(40, 40),
          buttonSize: const Size(50, 50),
          onPressed: onSendCallInvitationFinished,
        );
      },
    );
  }

  Future startCall(
    String receiver_id,
  ) async {
    setState(() {
      loading = true;
    });
    var api =
        Uri.parse("https://counsellor.creditmywallet.in.net/api/start_a_call");
    var userID = await HelperFunctions.getuserID();

    Map map = {
      'caller_id': userID.toString(),
      'receiver_id': receiver_id.toString(),
      'room_id': userID.toString(),
    };
    print('ankit $map');
    final response = await http.post(
      api,
      body: map,
    );
    String msg = '';
    var res = await json.decode(response.body);
    print('ankit${res['response']['call_his_id']}');
    print("response" + response.body);
    msg = res['status_message'].toString();
    print(msg);
    try {
      if (msg == "Call Connected Successfully") {
        setState(() {
          call_his_id = res['response']['call_his_id'];
          // caller_name = res['response']['caller_name'];
          loading = false;
          inviteeUsersIDTextCtrl.text = receiver_id;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SizedBox(
                    height: 100,
                    child: Column(children: [
                      const SizedBox(height: 10),
                      const Text('Click to enter in call!'),
                      const SizedBox(height: 5),
                      Visibility(visible: false, child: inviteeUserIDInput()),
                      const SizedBox(width: 5),
                      callButton(false),
                    ]),
                  ),
                );
              });
        });
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      } else {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg.toString()),
      ));
    }
  }

  var userIDNotifier = ValueNotifier<String>("");
  Widget inviteeUserIDInput() {
    return Expanded(
      child: TextFormField(
        readOnly: true,
        controller: inviteeUsersIDTextCtrl,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
        ],
        decoration: const InputDecoration(
          isDense: true,
          // hintText: "Please Enter Invitees ID",
          // labelText: "Invitees ID, Separate ids by ','",
        ),
      ),
    );
  }

  @override
  void initState() {
    getUniqueUserId().then((userID) {
      userIDNotifier.value = userID;
    });
    super.initState();
  }

  final showDeclineNotifier = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: userIDNotifier,
      builder: (context, userID, _) {
        if (userID.isEmpty) {
          return Container();
        }
        return ValueListenableBuilder<bool>(
          valueListenable: showDeclineNotifier,
          builder: (context, showDeclineButton, _) {
            return ZegoUIKitPrebuiltCallWithInvitation(
              appID: 827594550,
              appSign:
                  'ddfe701ba5fd09d4215b2570652420a112a422f29ed3066b5c91c6503b34b75b',
              userID: userID,
              userName: "user_$userID",
              showDeclineButton: showDeclineButton,
              notifyWhenAppRunningInBackgroundOrQuit: true,
              isIOSSandboxEnvironment: false,
              androidNotificationConfig: ZegoAndroidNotificationConfig(
                channelID: "ZegoUIKit",
                channelName: "Call Notifications",
                sound: "zego_incoming",
              ),
              plugins: [ZegoUIKitSignalingPlugin()],
              requireConfig: (ZegoCallInvitationData data) {
                var config = (data.invitees.length > 1)
                    ? ZegoInvitationType.videoCall == data.type
                        ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                        : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                    : ZegoInvitationType.videoCall == data.type
                        ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                        : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

                // Modify your custom configurations here.
                config.onHangUpConfirmation = (BuildContext context) async {
                  return await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                        title: const Text("Alert!",
                            style: TextStyle(color: Colors.white70)),
                        content: const Text("You want to end the call?",
                            style: TextStyle(color: Colors.white70)),
                        actions: [
                          ElevatedButton(
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.white70)),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          ElevatedButton(
                            child: const Text("End"),
                            onPressed: () async {
                              callend();
                            },
                          ),
                        ],
                      );
                    },
                  );
                };
                return config;
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: ABConstraints.themeColor,
                  // backgroundColor:Colors.white,
                  title: Text(
                    widget.getPopularCounsllerName.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  elevation: 1.0,
                  foregroundColor: ABConstraints.white,
                ),
                backgroundColor: ABConstraints.themeColor,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              widget.getPopularCounsllerProfilepic.toString() ==
                                      ''
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 0),
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: NetworkImage(
                                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/800px-Default_pfp.svg.png"),
                                              fit: BoxFit.fill),
                                          color: Colors.white38,
                                          borderRadius: BorderRadius.circular(
                                              15), // border: Border.all(width: 1.5),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 0),
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: Colors.white38,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(width: 1.5)),
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                              .getPopularCounsllerProfilepic
                                              .toString()
                                              .toString(),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                width: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.getPopularCounsllerName.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.getPopularCounsllerRNumber
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "About Counselor :",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Email id :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Text(
                                              widget
                                                  .getPopularCounsllerEmailAdress
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.black38,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Date of Birth",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        ),
                                        Text(
                                          widget.getPopularCounsllerDob
                                              .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.black38,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Gender   ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        ),
                                        Text(
                                          widget.getPopularCounsllerGender
                                                      .toString() ==
                                                  '0'
                                              ? 'Male'
                                              : 'Female',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.black38,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "City  ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        ),
                                        Text(
                                          widget.getPopularCounsllerCity
                                              .toString(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.black38,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "State  ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        ),
                                        Text(
                                          widget.getPopularCounsllerState
                                                      .toString() ==
                                                  'null'
                                              ? 'Not Available'
                                              : widget.getPopularCounsllerState
                                                  .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: const [
                            Center(
                              child: Text(
                                "Reviews",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.white,
                        endIndent: 280,
                        indent: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.96,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          color: Colors.white,
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
                                            SizedBox(
                                              height: 30,
                                              child: RatingBar.builder(
                                                initialRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 40.0,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  size: 35,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate:
                                                    (rating) async {},
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 22,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                        "Rating us")),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.98,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Text(
                                    "Rating Us",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: 30,
                                    // padding: EdgeInsets.symmetric(vertical: 7),
                                    child: RatingBar.builder(
                                      initialRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        size: 25,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) async {},
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 130,
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: FloatingActionButton.extended(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: ABConstraints.themeColor,
                                    content: SizedBox(
                                      height: 90,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Are you sure want to Call?",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              color: Colors.white,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white))),
                                                TextButton(
                                                    onPressed: () async {
                                                      // setState(() {
                                                      //   inviteeUsersIDTextCtrl.text = vendor_list[index]['listner_id'].toString();
                                                      // });
                                                      startCall(widget
                                                          .getPopularCounsllerrId
                                                          .toString());
                                                      //  await callButton(false);
                                                      // startCall(vendor_list[index]['listner_id'].toString());
                                                    },
                                                    child: const Text("Yes",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white)))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          label: const Text('Call Now'),
                          icon: const Icon(Icons.call),
                          backgroundColor: ABConstraints.btn),
                    ),
                    const Spacer(),
                    FloatingActionButton.extended(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: ABConstraints.themeColor,
                                content: SizedBox(
                                  height: 90,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Are you sure want to Chat Request?",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: Colors.white,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("No",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white))),
                                            TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  var userID =
                                                      await HelperFunctions
                                                          .getuserID();
                                                  Map data = {
                                                    'user_id':
                                                        userID.toString(),
                                                    'listener_id': widget
                                                        .getPopularCounsllerrId
                                                        .toString(),
                                                  };
                                                  var data1 = jsonEncode(data);
                                                  var api = Uri.parse(
                                                      "https://counsellor.creditmywallet.in.net/api/send_chat_request");
                                                  final response =
                                                      await http.post(api,
                                                          headers: {
                                                            "Content-Type":
                                                                "Application/json"
                                                          },
                                                          body: data1);
                                                  var res = await json
                                                      .decode(response.body);
                                                  msg = res['status_message']
                                                      .toString();
                                                  if (msg ==
                                                      "Request Sent to Listener Successfully") {
                                                    Fluttertoast.showToast(
                                                        msg: msg.toString(),
                                                        fontSize: 14,
                                                        gravity: ToastGravity
                                                            .BOTTOM);
                                                    setState(() {
                                                      loading = false;

                                                      Navigator.pop(context);
                                                    });
                                                  } else {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg: msg.toString(),
                                                        fontSize: 14,
                                                        gravity: ToastGravity
                                                            .BOTTOM);
                                                  }
                                                },
                                                child: const Text("Yes",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white)))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      label: const Text('Chat Now'),
                      icon: const Icon(Icons.chat),
                      backgroundColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
