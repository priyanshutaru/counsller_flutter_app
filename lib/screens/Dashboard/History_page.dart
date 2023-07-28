import 'dart:convert';

import 'package:counsller_flutter_app/screens/Dashboard/addMoney.dart';
import 'package:counsller_flutter_app/screens/Dashboard/call_details_screen.dart';
import 'package:counsller_flutter_app/screens/Dashboard/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';
import 'package:http/http.dart' as http;

class History_page extends StatefulWidget {
  const History_page({Key? key}) : super(key: key);
  @override
  State<History_page> createState() => _History_pageState();
}

class _History_pageState extends State<History_page>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? msg;

  List? dataList;
  List? calldataList;

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

  void callHistoryData() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/user_call_history");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      calldataList = res['response'];
      // imageListwe = res['response'][0]['crop_diseases'];
      print('Call History List' + calldataList.toString());
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

  String? usedId;

  List? walletdataList;
  void walletHistoryData() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
    };
    setState(() {
      usedId = userID.toString();
    });
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/user_payment_log");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      walletdataList = res['response'];
      print('Wallet History List' + walletdataList.toString());
      setState(() {
        msg = res['status_message'];
      });
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
      throw Exception('unexpected error occurred');
    }
  }

  List? call_transection_history_data;
  void call_transection_history() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
    };
    setState(() {
      usedId = userID.toString();
    });
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/call_transection_history");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      call_transection_history_data = res['response'];
      print('Call Transection History  List' +
          call_transection_history_data.toString());
      setState(() {
        msg = res['status_message'];
      });
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
      throw Exception('unexpected error occurred');
    }
  }

  List? chat_transection_history_data;
  void chat_transection_history() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    Map data = {
      'user_id': userID.toString(),
    };
    setState(() {
      usedId = userID.toString();
    });
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/chat_transection_history");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = await json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      chat_transection_history_data = res['response'];
      print('Chat Transection History  List' +
          chat_transection_history_data.toString());
      setState(() {
        msg = res['status_message'];
      });
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
      throw Exception('unexpected error occurred');
    }
  }

  String walletbalance = "";

  Future getBalance() async {
    setState(() {
      loading = true;
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
          loading = false;
          walletbalance = res['response']['balance'].toString();
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
    getBalance();
    walletHistoryData();
    chatHistoryData();
    callHistoryData();
    call_transection_history();
    chat_transection_history();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
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
              "History",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            elevation: 0.0,
            foregroundColor: ABConstraints.white,
          ),
          body: SingleChildScrollView(
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: TabBar(
                              unselectedLabelColor: Colors.black,
                              labelColor: ABConstraints.btn,
                              indicatorColor: ABConstraints.btn,
                              tabs: const [
                                Tab(
                                  child: Text(
                                    "Wallet",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Chat",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Call",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TabBarView(
                            children: [
                              Wallet(),
                              Chat(),
                              Call(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          )),
    );
  }

  Widget Wallet() {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.5)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Wallet History",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "₹ $walletbalance",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              height: 34,
                              width: 110,
                              decoration: BoxDecoration(
                                  color: ABConstraints.btn,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(11))),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddMoney()));
                                },
                                child: const Text(
                                  "Recharge",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  color: ABConstraints.themeColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Wallet Transaction',
                  ),
                  Tab(
                    text: 'Chat Log',
                  ),
                  Tab(
                    text: 'Call Log',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ChatDet(),
                  chat_logs(),
                  callpayment_logs(),
                ],
              ),
            ),
          ],
        ));
  }

  // ignore: non_constant_identifier_names
  Widget Chat() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.98,
          child: dataList == null
              ? const Center(
                  child: Text('No Data'),
                )
              : ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataList?.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        elevation: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "# ${dataList![index]['chat_transectionID'].toString()}",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  const Spacer(),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 15),
                                  //   child: Text(
                                  //     "HELP",
                                  //     style: TextStyle(
                                  //         fontSize: 15,
                                  //         color: ABConstraints.themeColor,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        dataList![index]['vendor_profile']
                                                ['name']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        dataList![index]['chat_date']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      // const SizedBox(
                                      //   height: 2,
                                      // ),
                                      // const Text(
                                      //   "Completed",
                                      //   style: TextStyle(
                                      //       fontSize: 14, color: Colors.green),
                                      // ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Chat Type: ${dataList![index]['chat_chat_type'].toString()}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            " Paid Session",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: ABConstraints.btn),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Rate: ₹ ${dataList![index]['chat_rate'].toString()}/min",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Duration: ${dataList![index]['chat_duration'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Deduction: ₹ ${dataList![index]['chat_deduction_amt'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://images.all-free-download.com/images/graphiclarge/man_and_woman_chat_bubble_6817196.jpg"),
                                                fit: BoxFit.fill),
                                            shape: BoxShape.circle),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "₹ ${dataList![index]['vendor_profile']['chat_rate'].toString()}/min",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // const SizedBox(
                                      //   height: 3,
                                      // ),
                                      // Text(
                                      //   "Wait - time ~ 5m",
                                      //   style: TextStyle(
                                      //       fontSize: 13,
                                      //       color: ABConstraints.btn),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              // Row(
                              //   children: [
                              //     // Container(
                              //     //   height: 35,
                              //     //   width: MediaQuery.of(context).size.width *
                              //     //       0.55,
                              //     //   decoration: BoxDecoration(
                              //     //       //color: ABConstraints.themeColor,
                              //     //       borderRadius: const BorderRadius.all(
                              //     //           Radius.circular(7)),
                              //     //       border: Border.all(
                              //     //           color: Colors.black, width: 1)),
                              //     //   child: MaterialButton(
                              //     //     onPressed: () {},
                              //     //     child: Row(
                              //     //       children: [
                              //     //         Icon(
                              //     //           Icons.whatsapp,
                              //     //           color: Colors.black,
                              //     //           size: 14,
                              //     //         ),
                              //     //         SizedBox(
                              //     //           width: 2,
                              //     //         ),
                              //     //         Text(
                              //     //           "Share with your friends",
                              //     //           style: TextStyle(
                              //     //               fontSize: 12,
                              //     //               color: Colors.black),
                              //     //         )
                              //     //       ],
                              //     //     ),
                              //     //   ),
                              //     // ),
                              //     const Spacer(),
                              //     Container(
                              //       height: 35,
                              //       width: 75,
                              //       decoration: BoxDecoration(
                              //           //color: ABConstraints.themeColor,
                              //           borderRadius: const BorderRadius.all(
                              //               Radius.circular(7)),
                              //           border: Border.all(width: 1)),
                              //       child: MaterialButton(
                              //         onPressed: () {
                              //           // Navigator.push(context, MaterialPageRoute(
                              //           //     builder: (context)=>comment_chat_page()));
                              //         },
                              //         child: const Text("Chat",
                              //             style: TextStyle(
                              //               fontSize: 12,
                              //             )),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ));
                  }),
        )
      ],
    );
  }

  Widget Call() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.98,
          child: calldataList == null
              ? const Center(
                  child: Text('No Data'),
                )
              : ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: calldataList?.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        elevation: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "# ${calldataList![index]['call_transectionID'].toString()}",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        calldataList![index]['vendor_profile']
                                                ['name']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        calldataList![index]['call_date']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                     
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Call Type: ${calldataList![index]['call_type'].toString()}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            " Paid Session",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: ABConstraints.btn),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Rate: ₹ ${calldataList![index]['call_rate'].toString()}/min",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Duration: ${calldataList![index]['call_duration'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Deduction: ₹ ${calldataList![index]['call_deduction_amt'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://cdn-icons-png.flaticon.com/512/273/273501.png"),
                                                fit: BoxFit.fill),
                                            shape: BoxShape.circle),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "₹ ${calldataList![index]['vendor_profile']['call_rate'].toString()}/min",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                                  const SizedBox(
                                        height: 10,
                                      ),
                            ],
                          ),
                        ));
                  }),
        )
      ],
    );
  }

  Widget chat_logs() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: chat_transection_history_data == null
            ? const Center(
                child: Text('No Data'),
              )
            : ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: chat_transection_history_data?.length,
                itemBuilder: (BuildContext context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CallDetailsCounselor()));
                        },
                        child: SizedBox(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Chat Id - ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54)),
                                            TextSpan(
                                                text: usedId,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        chat_transection_history_data![index]
                                                ['date_time']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "#${call_transection_history_data![index]['trasnsection_id'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "+ ₹ ${chat_transection_history_data![index]['amount'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      // Text(
                                      //   "GST 9.0",
                                      //   style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w500,
                                      //       color: Colors.black54),
                                      // ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        chat_transection_history_data![index]
                                                ['status']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }));
  }

// call_transection_history_data
  Widget callpayment_logs() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: call_transection_history_data == null
            ? const Center(
                child: Text('No Data'),
              )
            : ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: call_transection_history_data?.length,
                itemBuilder: (BuildContext context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CallDetailsCounselor()));
                        },
                        child: SizedBox(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Caller Id - ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54)),
                                            TextSpan(
                                                text: usedId,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        call_transection_history_data![index]
                                                ['date_time']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "#${call_transection_history_data![index]['trasnsection_id'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "+ ₹ ${call_transection_history_data![index]['amount'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      // Text(
                                      //   "GST 9.0",
                                      //   style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w500,
                                      //       color: Colors.black54),
                                      // ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        call_transection_history_data![index]
                                                ['status']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }));
  }

  Widget ChatDet() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.98,
      height: MediaQuery.of(context).size.height * 0.98,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: walletdataList == null
            ? const Center(
                child: Text('No Data'),
              )
            : ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: walletdataList?.length,
                itemBuilder: (BuildContext context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Recharge",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "To User Id - $usedId",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        walletdataList![index]['date_time']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      const Text(
                                        "Transaction_Id - ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        walletdataList![index]
                                                ['trasnsection_id']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        " ₹ ${walletdataList![index]['amount'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      const Text(
                                        "Successfull",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
      ),
    );
  }
}
