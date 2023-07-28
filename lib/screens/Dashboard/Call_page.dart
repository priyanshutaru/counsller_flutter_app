// ignore_for_file: use_build_context_synchronously
import 'package:counsller_flutter_app/screens/Dashboard/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class Call_page extends StatefulWidget {
  const Call_page({Key? key}) : super(key: key);

  @override
  State<Call_page> createState() => _Call_pageState();
}

class _Call_pageState extends State<Call_page> {
  // ignore: non_constant_identifier_names
  String? caller_id;
  // ignore: non_constant_identifier_names
  String? call_his_id;
  // ignore: non_constant_identifier_names
  String? caller_name;
  // ignore: non_constant_identifier_names
  String? room_id;
  bool loading = false;
  Future getcallid() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'receiver_id': userID.toString(),
    };
    print('anki$data');
    var data1 = jsonEncode(data);
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/getCallDetails");
    final response = await http.post(api,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    if (msg == "Data Found!") {
      setState(() {
        call_his_id = res['response']['call_his_id'];
        loading = false;
      });
      callend();
      print(request_list_sent_by_user_data);
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
    }
  }

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

  String msg = '';
  List vendor_list = [];
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
String duration = '';

  Future max_call_duration(
    String receiver_id,
  ) async {
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/max_call_duration");
    var userID = await HelperFunctions.getuserID();

    Map map = {
      'user_id': userID.toString(),
      'listener_id': receiver_id.toString(),
    };
    print('max_call_duration $map');
    final response = await http.post(
      api,
      body: map,
    );
    var res = await json.decode(response.body);
    duration = res['response'].toString();
    print('duration $duration');
    msg = res['status_message'].toString();
    print(msg);
    try {
      if (msg == "Data Found") {
        setState(() {
          loading = false;
          duration = res['response'].toString();
          print('duration $duration');
          startCall(receiver_id);
        });
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
    // print('ankit${res['response']['call_his_id']}');
    print("start_a_call" + response.body);
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
                      Text('Your Call Duration $duration seconds!'),
                      const SizedBox(height: 2),
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

  Future getVendorList() async {
    setState(() {
      loading = true;
    });

    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/get_vendor_list");
    var userID = await HelperFunctions.getuserID();

    Map mapeddate = {
      'user_id': userID.toString(),
    };

    final response = await http.post(
      api,
      body: mapeddate,
    );
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    if (msg == "Get Data") {
      setState(() {
        vendor_list = res['response'];
        loading = false;
      });
      print(vendor_list);
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  List request_list_sent_by_user_data = [];

  Future request_list_sent_by_user() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
    };
    var data1 = jsonEncode(data);
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/request_list_sent_by_user");
    final response = await http.post(api,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    if (msg == "Successful") {
      setState(() {
        request_list_sent_by_user_data = res['response']['response'];
        loading = false;
      });
      print(request_list_sent_by_user_data);
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
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

  List searchedvendor_list = [];

  bool isSearched = false;
  final TextEditingController _name = TextEditingController();
  Future getSearched() async {
    setState(() {
      loading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/search_vendor_by_name");
    Map mapeddate = {
      'listener_name': _name.text.toString(),
    };

    final response = await http.post(
      api,
      body: mapeddate,
    );
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    if (msg == "Listenere List") {
      setState(() {
        searchedvendor_list = res['response'];
        loading = false;
        isSearched = true;
        _name.clear();
      });
      print('search_vendor_by_name $vendor_list');
    } else {
      setState(() {
        _name.clear();
        loading = false;
        isSearched = false;
      });
    }
  }

  @override
  void initState() {
    getUniqueUserId().then((userID) {
      userIDNotifier.value = userID;
    });
    getVendorList();
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
              plugins: [
                ZegoUIKitSignalingPlugin(),
              ],
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
                  
                  return await 
                  showDialog(
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
                floatingActionButton: FloatingActionButton(
                    elevation: 0.0,
                    backgroundColor: ABConstraints.themeColor,
                    onPressed: () {
                      initState();
                    },
                    child: const Icon(Icons.refresh)),
                drawer: Drawerpage(),
                appBar: AppBar(
                  backgroundColor: ABConstraints.themeColor,
                  title: const Text(
                    "Call with Counselor",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  elevation: 0.0,
                  foregroundColor: ABConstraints.white,
                ),
                body: SingleChildScrollView(
                    child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      loading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.98,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        height: 40,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.blue,
                                                width: 0.5)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 310,
                                              child: TextFormField(
                                                onEditingComplete: getSearched,
                                                controller: _name,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(12),
                                                  border: InputBorder.none,
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  hintText: 'Search Counsellor',
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isSearched = false;
                                                        _name.clear();
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.clear,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  getSearched();
                                                },
                                                icon: const Icon(Icons.search))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 30),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        child: isSearched
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 30),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.88,
                                                child: ListView.builder(
                                                    physics:
                                                        const ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    // ignore: unnecessary_null_comparison
                                                    itemCount:
                                                        searchedvendor_list ==
                                                                null
                                                            ? 0
                                                            : searchedvendor_list
                                                                .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            index) {
                                                      return Card(
                                                        elevation: 1,
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  8.2,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  4.0,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                        searchedvendor_list[index]
                                                                            [
                                                                            'profile_pic'],
                                                                      ),
                                                                      fit: BoxFit.fill),
                                                                  borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                            ),
                                                            const SizedBox(
                                                              width: 18,
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: 30,
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          15),
                                                                  child: RatingBar
                                                                      .builder(
                                                                    initialRating:
                                                                        3.5,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    allowHalfRating:
                                                                        true,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        15.0,
                                                                    itemPadding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            1),
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            const Icon(
                                                                      Icons
                                                                          .star,
                                                                      size: 50,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    onRatingUpdate:
                                                                        (rating) async {},
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  searchedvendor_list[
                                                                          index]
                                                                      ['name'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                                const Text(
                                                                  "Tarot life Coach",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                const Text(
                                                                  "Language -",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  "${searchedvendor_list[index]['language']}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  "Exp ${searchedvendor_list[index]['experinece_y']}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "₹ ${searchedvendor_list[index]['call_rate']} / min",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.15,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10,
                                                                          bottom:
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            28,
                                                                        width:
                                                                            80,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                ABConstraints.themeColor,
                                                                            borderRadius: const BorderRadius.all(Radius.circular(7))),
                                                                        child:
                                                                            MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog(
                                                                                    backgroundColor: ABConstraints.themeColor,
                                                                                    content: SizedBox(
                                                                                      height: 90,
                                                                                      child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.9,
                                                                                        child: Column(
                                                                                          children: [
                                                                                            const Text(
                                                                                              "Are you sure want to Chat Request?",
                                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                                                                                            ),
                                                                                            const Divider(
                                                                                              thickness: 1,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                              children: [
                                                                                                TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: const Text("No", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                                                                                                TextButton(
                                                                                                    onPressed: () async {
                                                                                                      setState(() {
                                                                                                        loading = true;
                                                                                                      });
                                                                                                      var userID = await HelperFunctions.getuserID();
                                                                                                      Map data = {
                                                                                                        'user_id': userID.toString(),
                                                                                                        'listener_id': searchedvendor_list[index]['listner_id'].toString(),
                                                                                                      };
                                                                                                      var data1 = jsonEncode(data);
                                                                                                      var api = Uri.parse("https://counsellor.creditmywallet.in.net/api/send_chat_request");
                                                                                                      final response = await http.post(api, headers: {"Content-Type": "Application/json"}, body: data1);
                                                                                                      var res = await json.decode(response.body);
                                                                                                      msg = res['status_message'].toString();
                                                                                                      if (msg == "Request Sent to Listener Successfully") {
                                                                                                        Fluttertoast.showToast(msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
                                                                                                        setState(() {
                                                                                                          loading = false;
                                                                                                          request_list_sent_by_user();
                                                                                                          getVendorList();
                                                                                                          Navigator.pop(context);
                                                                                                        });
                                                                                                      } else {
                                                                                                        // ignore: use_build_context_synchronously
                                                                                                        Navigator.pop(context);
                                                                                                        setState(() {
                                                                                                          loading = false;
                                                                                                        });
                                                                                                        Fluttertoast.showToast(msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
                                                                                                      }
                                                                                                    },
                                                                                                    child: const Text("Yes", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)))
                                                                                              ],
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: const [
                                                                              Icon(
                                                                                Icons.chat_bubble_outline_outlined,
                                                                                color: Colors.white,
                                                                                size: 16,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 2,
                                                                              ),
                                                                              Text(
                                                                                "Chat",
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : ListView.builder(
                                                physics: const ScrollPhysics(),
                                                shrinkWrap: true,
                                                // ignore: unnecessary_null_comparison
                                                itemCount: vendor_list == null
                                                    ? 0
                                                    : vendor_list.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        index) {
                                                  return Card(
                                                    elevation: 1,
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              6.8,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.5,
                                                          decoration:
                                                              BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                          image:
                                                                              NetworkImage(
                                                                            vendor_list[index]['profile_pic'].toString(),
                                                                          ),
                                                                          fit: BoxFit
                                                                              .fill),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10))),
                                                        ),
                                                        const SizedBox(
                                                          width: 18,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 30,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          15),
                                                              child: RatingBar
                                                                  .builder(
                                                                initialRating:
                                                                    3.5,
                                                                direction: Axis
                                                                    .horizontal,
                                                                allowHalfRating:
                                                                    true,
                                                                itemCount: 5,
                                                                itemSize: 15.0,
                                                                itemPadding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            1),
                                                                itemBuilder:
                                                                    (context,
                                                                            _) =>
                                                                        const Icon(
                                                                  Icons.star,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                onRatingUpdate:
                                                                    (rating) async {},
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              vendor_list[index]
                                                                  ['name'],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 17),
                                                            ),
                                                            const Text(
                                                              "Tarot life Coach",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              width: 190,
                                                              child: Text(
                                                                "Language - ${vendor_list[index]['language']}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                            Text(
                                                              "Exp ${vendor_list[index]['experinece_y']}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "₹ ${vendor_list[index]['call_rate']} / min",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.15,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right: 10,
                                                                      bottom:
                                                                          8),
                                                                  child:
                                                                      Container(
                                                                    height: 28,
                                                                    width: 75,
                                                                    decoration: BoxDecoration(
                                                                        color: ABConstraints
                                                                            .themeColor,
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(7))),
                                                                    child:
                                                                        MaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog(
                                                                                backgroundColor: ABConstraints.themeColor,
                                                                                content: SizedBox(
                                                                                  height: 90,
                                                                                  child: SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.9,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        const Text(
                                                                                          "Are you sure want to Call?",
                                                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                                                                                        ),
                                                                                        const Divider(
                                                                                          thickness: 1,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                          children: [
                                                                                            TextButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: const Text("No", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
                                                                                            TextButton(
                                                                                                onPressed: () async {
                                                                                                  // setState(() {
                                                                                                  //   inviteeUsersIDTextCtrl.text = vendor_list[index]['listner_id'].toString();
                                                                                                  // });
                                                                                                  max_call_duration(vendor_list[index]['listner_id'].toString());
                                                                                                  //  await callButton(false);
                                                                                                  // startCall(vendor_list[index]['listner_id'].toString());
                                                                                                },
                                                                                                child: const Text("Yes", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)))
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: const [
                                                                          Icon(
                                                                            Icons.call_outlined,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                            "Call",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.white),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                      ),
                                    ],
                                  ))

                              // TabBarView(
                              //   children: [
                              //     call_list(),
                              //     call_requst(),
                              //   ],
                              // ),
                              ),
                    ],
                  ),
                )),
              ),
            );
          },
        );
      },
    );
  }
}
