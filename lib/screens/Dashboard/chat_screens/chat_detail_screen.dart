import 'dart:async';
import 'dart:convert';
import 'package:counsller_flutter_app/screens/Dashboard/chat_page.dart';
import 'package:counsller_flutter_app/screens/Dashboard/chat_screens/model/get_message_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Constraints_color/constraints.dart';
import '../../../HelperFunctions/HelperFunctions.dart';

class ChatDetail extends StatefulWidget {
  String? userid, name, img, chat_id, maximum_chat_duration;

  ChatDetail({
    required this.userid,
    required this.name,
    required this.img,
    required this.chat_id,
    required this.maximum_chat_duration,
  });

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  TextEditingController comment = TextEditingController();
  String? user_id;
  Future<List<Response_Message>> get_message() async {
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'chat_his_id': widget.chat_id.toString(),
    };
    print(data.toString());
    Uri url =
        Uri.parse("https://counsellor.creditmywallet.in.net/api/get_message");
    var body = jsonEncode(data);
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print(response);
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['response'];
      print(data);
      return data.map((job) => Response_Message.fromJson(job)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  bool loading = false;
  String msg = '';

  String? chat;
  String? chat_dt_time;
  String formatTimeOfDay(chat) {
    chat_dt_time = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(chat!));
    return " ${chat_dt_time}";
  }

  void msg_user_id() async {
    var userID = await HelperFunctions.getuserID();

    user_id = userID;
  }

  Future user_inn_chat_room() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
      'chat_id': widget.chat_id.toString(),
    };
    var data1 = jsonEncode(data);
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/user_inn_chat_room");
    final response = await http.post(api,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    if (msg == "Successful") {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You joinded the chat ${msg.toString()}'),
      ));
    } else {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You joinded the chat status - ${msg.toString()}'),
      ));
    }
  }

  Future chatend() async {
    setState(() {
      loading = true;
    });
    Map data = {
      'chat_id': widget.chat_id.toString(),
      'chat_end_time': DateTime.now().toString(),
      // 'request_id': vendor_list[index]['listner_id'].toString(),
    };
    var data1 = jsonEncode(data);
    var api =
        Uri.parse("https://counsellor.creditmywallet.in.net/api/end_chat");
    final response = await http.post(api,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    msg = res['status_message'].toString();
    if (msg == "Chat End Successfully") {
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
      setState(() {
        loading = false;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const chat_page()));
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
    }
  }

  late Timer timer;

  @override
  void initState() {
    super.initState();
    user_inn_chat_room();
    msg_user_id();
    timer =
        Timer(Duration(seconds: int.parse(widget.maximum_chat_duration!.toString())), () {
      setState(() {
        chatend();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You chat is ended because of Insufficient balance!'),
      ));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          foregroundColor: ABConstraints.white,
          backgroundColor: ABConstraints.themeColor,
          toolbarHeight: 70,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.img.toString()),
                ),
              ),
              Text(
                "${widget.name}",
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.black),
              ),
            ],
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                  bottom: 10,
                ),
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                  child: MaterialButton(
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
                                        "Are you sure want to End the Chat?",
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
                                                  'chat_id':
                                                      widget.chat_id.toString(),
                                                  'chat_end_time':
                                                      DateTime.now().toString(),
                                                  // 'request_id': vendor_list[index]['listner_id'].toString(),
                                                };
                                                var data1 = jsonEncode(data);
                                                var api = Uri.parse(
                                                    "https://counsellor.creditmywallet.in.net/api/end_chat");
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
                                                    "Chat End Successfully") {
                                                  Fluttertoast.showToast(
                                                      msg: msg.toString(),
                                                      fontSize: 14,
                                                      gravity:
                                                          ToastGravity.BOTTOM);
                                                  setState(() {
                                                    loading = false;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const chat_page()));
                                                  });
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  setState(() {
                                                    loading = false;
                                                          Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const chat_page()));
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg: msg.toString(),
                                                      fontSize: 14,
                                                      gravity:
                                                          ToastGravity.BOTTOM);
                                                }
                                              },
                                              child: const Text("Yes",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                    child: Row(
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "End",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: loading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    FutureBuilder<List<Response_Message>>(
                        future: get_message(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Response_Message>? data = snapshot.data;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data!.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 22 / 4,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 3,
                                      crossAxisCount: 1),
                              itemBuilder: (BuildContext context, int index) {
                                chat = data[index].time.toString();
                                return Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: data[index].senderId != user_id
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 1),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .deepOrange.shade200,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16),
                                                            topRight:
                                                                Radius.circular(
                                                                    16),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    16)),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        child: Text(
                                                          data[index]
                                                              .sendMsg
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            formatTimeOfDay(
                                                                    chat)
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize: 9,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          const SizedBox(
                                                            width: 70,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 1),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .blueGrey.shade300,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16),
                                                            topRight:
                                                                Radius.circular(
                                                                    16),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    16),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0)),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        child: Text(
                                                          data[index]
                                                              .sendMsg
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            formatTimeOfDay(
                                                                    chat)
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize: 9,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                );
                              },
                            );
                          }
                          return Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: const Text("No Message"));
                        }),
                    const SizedBox(
                      height: 90,
                    )
                  ],
                ),
        )),
        bottomSheet: Container(
          padding: const EdgeInsets.only(left: 5, top: 30, bottom: 10),
          child: Row(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.brown[50]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      //textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.multiline,
                      maxLines: 20,
                      controller: comment,
                      decoration: const InputDecoration(
                        hintText: 'Share your emotion here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    var dio = Dio();
                    var userID = await HelperFunctions.getuserID();
                    print(userID.toString());
                    var formData = FormData.fromMap({
                      'sender_id': userID.toString(),
                      // ignore: unnecessary_string_interpolations
                      'chat_his_id': "${widget.chat_id.toString()}",
                      'message': comment.text
                    });
                    print(formData.fields.toString());
                    var response = await dio.post(
                        'https://counsellor.creditmywallet.in.net/api/send_message',
                        data: formData);
                    setState(() {
                      var res = response.data;
                      print(res.toString());
                      Fluttertoast.showToast(
                          msg: res['status_message'].toString(),
                          fontSize: 14,
                          gravity: ToastGravity.BOTTOM);
                    });

                    comment.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }
}
