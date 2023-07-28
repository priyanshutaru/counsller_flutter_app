import 'dart:convert';

import 'package:counsller_flutter_app/screens/Dashboard/History_page.dart';
import 'package:counsller_flutter_app/screens/Dashboard/call_details_screen.dart';
import 'package:counsller_flutter_app/screens/Dashboard/chat_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  String? msg;
  List? dataList;
  List? imageListwe;
  bool loading = false;

  void chatHistoryData() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
    };
    print(data.toString());
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/user_chat_history");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      dataList = res['response']['response'];
      // imageListwe = res['response'][0]['crop_diseases'];
      print('Chat History List' + dataList.toString());
      setState(() {});
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
      throw Exception('unexpected error occurred');
    }
  }

  @override
  void initState() {
    chatHistoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: ABConstraints.themeColor,
          onPressed: () {
            initState();
          },
          child: const Icon(Icons.refresh)),
      appBar: AppBar(
        backgroundColor: ABConstraints.themeColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Chats History",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.88,
                      width: MediaQuery.of(context).size.width * 0.98,
                      child: ListView.builder(
                        itemCount: dataList?.length,
                        itemBuilder: (BuildContext context, index) {
                          if (dataList?.length == null) {
                            return const Center(
                              child: Text('No Data'),
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatDetails(
                                              transaction_id: dataList![index]
                                                      ['chat_transectionID']
                                                  .toString(),
                                              chat_duration_end:
                                                  dataList![index]
                                                          ['chat_end_time']
                                                      .toString(),
                                              chat_date: dataList![index]
                                                      ['chat_date']
                                                  .toString(),
                                              chat_time: dataList![index]
                                                      ['chat_start_time']
                                                  .toString(),
                                              chat_price: dataList![index]
                                                      ['chat_deduction_amt']
                                                  .toString(),
                                              created_at: dataList![index]
                                                      ['created_at']
                                                  .toString(),
                                            )));
                              },
                              child: Card(
                                elevation: 1,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                dataList![index]
                                                            ['vendor_profile']
                                                        ['name']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(
                                                width: 120,
                                              ),
                                              // Text(
                                              //   "Doctor",
                                              //   style: TextStyle(
                                              //       color: Colors.black54,
                                              //       fontSize: 13),
                                              // ),
                                              Text(
                                                "Date: ${dataList![index]['chat_date'].toString()}",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                "Duration : ${dataList![index]['chat_duration'].toString()}",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                "₹ ${dataList![index]['chat_rate'].toString()} / min",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        ['profile_pic'].toString() == ''
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              dataList![index][
                                                                          'vendor_profile']
                                                                      [
                                                                      'profile_pic']
                                                                  .toString()),
                                                          fit: BoxFit.fill)),
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: const DecorationImage(
                                                          image: NetworkImage(
                                                              'https://w7.pngwing.com/pngs/754/2/png-transparent-samsung-galaxy-a8-a8-user-login-telephone-avatar-pawn-blue-angle-sphere-thumbnail.png'),
                                                          fit: BoxFit.fill)),
                                                ),
                                              )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 20, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Total Chat Charge :",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            "₹ ${dataList![index]['chat_deduction_amt'].toString()}",
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
