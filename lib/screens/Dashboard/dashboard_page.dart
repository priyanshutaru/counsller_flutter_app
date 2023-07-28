import 'dart:convert';
import 'dart:io';
import 'package:counsller_flutter_app/screens/Dashboard/Call_page.dart';
import 'package:counsller_flutter_app/screens/Dashboard/History_page.dart';
import 'package:counsller_flutter_app/screens/Dashboard/chat_page.dart';
import 'package:counsller_flutter_app/screens/Dashboard/home_page_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// Dart imports:
// Flutter imports:
import 'package:flutter/services.dart';
// Package imports:
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class dashboard_page extends StatefulWidget {
  dashboard_page({Key? key, this.mobile, this.name, this.email, this.userid})
      : super(key: key);
  String? name;
  String? mobile;
  String? email;
  String? userid;
  @override
  State<dashboard_page> createState() => _dashboard_pageState();
}

class _dashboard_pageState extends State<dashboard_page> {
  // ignore: non_constant_identifier_names
  String? caller_id;
  // ignore: non_constant_identifier_names
  String? call_his_id;
  // ignore: non_constant_identifier_names
  String? caller_name;
  // ignore: non_constant_identifier_names
  String? room_id;
  bool loading = false;

  Stream<http.Response> getCallDetails() async* {
    yield* Stream.periodic(const Duration(seconds: 2), (_) async {
      // var api = Uri.parse("http://numbersapi.com/random/");
      var api = Uri.parse(
          "https://counsellor.creditmywallet.in.net/api/getCallDetails");
      var userID = await HelperFunctions.getuserID();
      Map mapeddate = {
        'receiver_id': userID.toString(),
      };

      final response = await http.post(
        api,
        body: mapeddate,
      );
      var res = await json.decode(response.body);
      String msg = res['status_message'];
      if (msg == "Data Found!") {
        setState(() {
          caller_id = res['response']['caller_id'];
          call_his_id = res['response']['call_his_id'];
          caller_name = res['response']['caller_name'];
          room_id = res['response']['room_id'];
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text(msg.toString()),
          // ));
        });
      } else {
        setState(() {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text(msg.toString()),
          // ));
        });
      }

      return http.get(api);
    }).asyncMap((event) async => await event);
  }

  String duration = '';

  Future recieveCall() async {
    var api = Uri.parse(
      "https://counsellor.creditmywallet.in.net/api/call_receive",
    );
    var userID = await HelperFunctions.getuserID();
    var currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hms().format(now);

    Map mapeddate = {
      'room_id': room_id.toString(),
      'call_id': call_his_id.toString(),
      'caller_id': caller_id.toString(),
      'receiver_id': userID.toString(),
      'start_date': currentDate.toString(), //Y-m-d
      'start_time': formattedTime.toString(), //H:i:s 24 Hours
    };
    final response = await http.post(
      api,
      body: mapeddate,
    );
    String msg = '';
    var res = await json.decode(response.body);
    msg = res["status_message"];
    try {
      if (msg == "Call has been Received") {
        // await requestPermission([ZegoMediaOption.publishLocalAudio]);
        // // ignore: use_build_context_synchronously
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => AudioCallPage(
        //               userID: userID.toString(),
        //               roomID: room_id.toString(),
        //               appID: appID,
        //               appSign: appSign,
        //               call_his_id: call_his_id.toString(),
        //               receiver_id: room_id.toString(),
        //             )));
        setState(() {
          duration = res["response"]['duration'].toString();
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your Call Duration $duration seconds!'),
        ));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print(e);
    }
  }

  Future rejectCall() async {
    setState(() {
      loading = true;
    });
    var api = Uri.parse(
      "https://counsellor.creditmywallet.in.net/api/reject_call",
    );
    var userID = await HelperFunctions.getuserID();
    var currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hms().format(now);
    Map mapeddate = {
      'room_id': room_id.toString(),
      'call_id': call_his_id.toString(),
      'rejected_by': userID.toString(),
      'end_date': currentDate.toString(), // Y-m-d
      'end_time': formattedTime.toString(), //H:i:s 24 Hours
    };
    print(mapeddate);
    final response = await http.post(
      api,
      body: mapeddate,
    );
    var res = await json.decode(response.body);
    String msg = res['status_message'];
    if (res['status_message'].toString() == "Call has been rejected") {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg.toString()),
      ));
    } else {
      setState(() {
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
        ));
      });
    }
  }

  @override
  int currentindex = 0;
  List allScreen = const [
    HomePage(),
    chat_page(),
    Call_page(),
    History_page(),
  ];
  var userIDNotifier = ValueNotifier<String>("");
  bool isChatEnabled = true;
  bool isUpdatingRoomProperty = false;
  final TextEditingController inviteeUsersIDTextCtrl = TextEditingController();
  final showDeclineNotifier = ValueNotifier<bool>(true);

  Widget callButton(bool isVideoCall) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        var invitees = getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text);

        return ZegoSendCallInvitationButton(
          // timeoutSeconds: int.parse(duration),
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

  Widget inviteeUserIDInput() {
    return Expanded(
      child: TextFormField(
        controller: inviteeUsersIDTextCtrl,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
        ],
        decoration: const InputDecoration(
          isDense: true,
          hintText: "Please Enter Invitees ID",
          labelText: "Invitees ID, Separate ids by ','",
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUniqueUserId().then((userID) {
      userIDNotifier.value = userID;
    });
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
    return StreamBuilder<http.Response>(
        stream: getCallDetails(),
        builder: (context, snapshot) {
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
                    events: ZegoUIKitPrebuiltCallInvitationEvents(
                      onIncomingCallDeclineButtonPressed: () {
                        rejectCall();

                        ///  Add your custom logic here.
                      },
                      onIncomingCallAcceptButtonPressed: () {
                        recieveCall();

                        ///  Add your custom logic here.
                      },
                      onIncomingCallTimeout:
                          (String callID, ZegoCallUser caller) {
                        rejectCall();

                        ///  Add your custom logic here.
                      },
                    ),
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
                      config.onHangUpConfirmation =
                          (BuildContext context) async {
                        return await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor:
                                  Colors.blue[900]!.withOpacity(0.9),
                              title: const Text("Alert!",
                                  style: TextStyle(color: Colors.white70)),
                              content: const Text("You want to end the call?",
                                  style: TextStyle(color: Colors.white70)),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Cancel",
                                      style: TextStyle(color: Colors.white70)),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                ElevatedButton(
                                  child: const Text("End"),
                                  onPressed: () async {
                                    var api = Uri.parse(
                                        "https://counsellor.creditmywallet.in.net/api/end_call");
                                    var userID =
                                        await HelperFunctions.getuserID();
                                    var currentDate = DateFormat('dd-MM-yyyy')
                                        .format(DateTime.now());
                                    DateTime now = DateTime.now();
                                    String formattedTime =
                                        DateFormat.Hms().format(now);
                                    Map map = {
                                      'room_id': room_id.toString(),
                                      'call_id': call_his_id.toString(),
                                      'call_end_by': userID.toString(),
                                      'end_date': currentDate.toString(),
                                      'end_time': formattedTime.toString(),
                                    };
                                    final response = await http.post(
                                      api,
                                      body: map,
                                    );
                                    String msg = '';
                                    var res = await json.decode(response.body);
                                    msg = res['status_message'].toString();
                                    print(msg);
                                    try {
                                      if (msg == "Call has been Ended") {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop(true);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(msg.toString()),
                                        ));
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop(true);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(msg.toString()),
                                        ));
                                      }
                                    } catch (e) {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(msg.toString()),
                                      ));
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      };
                      return config;
                    },
                    child: WillPopScope(
                      onWillPop: showExitPopup,
                      child: Scaffold(
                        // appBar: AppBar(
                        //     automaticallyImplyLeading: false,
                        //     actions: [
                        //       IconButton(
                        //         icon: const Icon(Icons.call),
                        //         onPressed: () {
                        //           showDialog(
                        //               context: context,
                        //               builder: (BuildContext context) {
                        //                 return AlertDialog(
                        //                   content: SizedBox(
                        //                     height: 100,
                        //                     child: Column(children: [
                        //                       inviteeUserIDInput(),
                        //                       const SizedBox(width: 5),
                        //                       callButton(false),
                        //                     ]),
                        //                   ),
                        //                 );
                        //               });
                        //         },
                        //       ),
                        //     ],
                        //     title: Text(
                        //       'Your userID: ${userIDNotifier.value}',
                        //     )),

                        body: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Scaffold(
                              bottomNavigationBar: BottomNavigationBar(
                                currentIndex: currentindex,
                                unselectedIconTheme: const IconThemeData(
                                  color: Colors.grey,
                                ),
                                selectedIconTheme: IconThemeData(
                                  color: ABConstraints.themeColor,
                                ),
                                selectedItemColor: ABConstraints.themeColor,
                                type: BottomNavigationBarType.fixed,
                                onTap: (int index) {
                                  setState(() {
                                    currentindex = index;
                                  });
                                },
                                items: const [
                                  BottomNavigationBarItem(
                                    icon: Icon(Icons.home_outlined),
                                    label: 'Home',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Icon(
                                        Icons.chat_bubble_outline_outlined),
                                    label: 'Chat',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Icon(Icons.call_outlined),
                                    label: 'Call',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Icon(Icons.video_file_outlined),
                                    label: 'History',
                                  ),
                                ],
                              ),
                              body: allScreen[currentindex],
                            )),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }

  Future<String> getUniqueUserId() async {
    // String? deviceID;
    // var deviceInfo = DeviceInfoPlugin();
    // if (Platform.isIOS) {
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    //   deviceID = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    // } else if (Platform.isAndroid) {
    //   var androidDeviceInfo = await deviceInfo.androidInfo;
    //   deviceID = androidDeviceInfo.androidId; // unique ID on Android
    // }

    // if (deviceID != null && deviceID.length < 4) {
    //   if (Platform.isAndroid) {
    //     deviceID += "_android";
    //   } else if (Platform.isIOS) {
    //     deviceID += "_ios___";
    //   }
    // }
    // if (Platform.isAndroid) {
    //   deviceID ??= "flutter_user_id_android";
    // } else if (Platform.isIOS) {
    //   deviceID ??= "flutter_user_id_ios";
    // }

    // var userID = md5
    //     .convert(utf8.encode(deviceID!))
    //     .toString()
    //     .replaceAll(RegExp(r'[^0-9]'), '');
    var userID = await HelperFunctions.getuserID();

    return userID!;
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
}
