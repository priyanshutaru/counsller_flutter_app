import 'dart:convert';

import 'package:counsller_flutter_app/screens/Dashboard/chat_screens/chat_detail_screen.dart';
import 'package:counsller_flutter_app/screens/Dashboard/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class chat_page extends StatefulWidget {
  const chat_page({Key? key}) : super(key: key);

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  bool loading = false;
  String msg = '';
  List vendor_list = [];

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
      print('vendor_list $vendor_list');
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
      print('request_list_sent_by_user_data $request_list_sent_by_user_data');
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  void initState() {
    request_list_sent_by_user();
    getVendorList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
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
            "Chat with Counselor",
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
              SizedBox(
                height: 30,
                child: TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: ABConstraints.btn,
                    indicatorColor: ABConstraints.btn,
                    tabs: const [
                      Tab(
                        child: Text(
                          "Counselor List",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Chat Requests",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ]),
              ),
              loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: [
                          chat_list(),
                          chat_requst(),
                        ],
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget chat_requst() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        // ignore: unnecessary_null_comparison
        child: request_list_sent_by_user_data == null
            ? const Center(
                child: Text('No Data'),
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: request_list_sent_by_user_data.length,
                    itemBuilder: (BuildContext context, index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {},
                            child: SizedBox(
                              // height: 100,
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
                                          Row(
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    14,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          request_list_sent_by_user_data[
                                                                          index]
                                                                      [
                                                                      'vendor_profile']
                                                                  [
                                                                  'profile_pic']
                                                              .toString(),
                                                        ),
                                                        fit: BoxFit.fill),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                            text: 'Name - ',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black54)),
                                                        TextSpan(
                                                            text: request_list_sent_by_user_data[
                                                                            index]
                                                                        [
                                                                        'vendor_profile']
                                                                    ['name']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    '${request_list_sent_by_user_data[index]['request_date'].toString()} ${request_list_sent_by_user_data[index]['request_time'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    request_list_sent_by_user_data[
                                                                        index][
                                                                    'vendor_request_status']
                                                                .toString() ==
                                                            '1'
                                                        ? "Request Status - Accepted"
                                                        : 'Request Status - Pending',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    request_list_sent_by_user_data[index]
                                                    ['vendor_request_status']
                                                .toString() ==
                                            '1'
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "+ ₹ ${request_list_sent_by_user_data[index]['vendor_profile']['chat_rate'].toString()} / min",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5, bottom: 0),
                                                  child: Container(
                                                    height: 28,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7))),
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        loading
                                                            ? const Center(
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              20.0),
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              )
                                                            : showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    content:
                                                                        SizedBox(
                                                                      height:
                                                                          90,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.9,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            const Text(
                                                                              "Are you sure want to Chat?",
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
                                                                                      setState(() {
                                                                                        loading = true;
                                                                                      });
                                                                                      var userID = await HelperFunctions.getuserID();
                                                                                      Map data = {
                                                                                        'request_id': request_list_sent_by_user_data[index]['request_id'].toString(),
                                                                                      };
                                                                                      print(data);
                                                                                      var data1 = jsonEncode(data);
                                                                                      var api = Uri.parse("https://counsellor.creditmywallet.in.net/api/start_chat");
                                                                                      final response = await http.post(api,
                                                                                          headers: {
                                                                                            "Content-Type": "Application/json"
                                                                                          },
                                                                                          body: data1);
                                                                                      var res = await json.decode(response.body);
                                                                                      msg = res['status_message'].toString();
                                                                                      if (msg == "Chat Started Successfully") {
                                                                                        setState(() {
                                                                                          loading = true;
                                                                                        });
                                                                                        setState(() {
                                                                                          loading = false;
                                                                                          Navigator.push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (context) => ChatDetail(
                                                                                                        // maximum_chat_duration: res['maximum_chat_duration'].toString(),
                                                                                                  maximum_chat_duration: '60',
                                                                                                        name: request_list_sent_by_user_data[index]['vendor_profile']['name'].toString(),
                                                                                                        img: request_list_sent_by_user_data[index]['vendor_profile']['profile_pic'].toString(),
                                                                                                        userid: request_list_sent_by_user_data[index]['vendor_profile']['vendor_ID'].toString(),
                                                                                                        chat_id: res['response'].toString(),
                                                                                                      )));
                                                                                        });
                                                                                        Fluttertoast.showToast(msg: 'Your Chat Duration ${res['maximum_chat_duration'].toString()} seconds!', fontSize: 14, gravity: ToastGravity.BOTTOM);
                                                                                        // } else {
                                                                                        //   // ignore: use_build_context_synchronously
                                                                                        //   Navigator.pop(context);
                                                                                        //   setState(() {
                                                                                        //     loading = false;
                                                                                        //   });
                                                                                        //   Fluttertoast.showToast(msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
                                                                                        // var userID = await HelperFunctions.getuserID();
                                                                                        // Map data = {
                                                                                        //   'request_id': vendor_list[index]['request_id'].toString(),
                                                                                        // };
                                                                                        // var data1 = jsonEncode(data);
                                                                                        // var api = Uri.parse("https://counsellor.creditmywallet.in.net/api/chat_id_by_request_id");
                                                                                        // final response = await http.post(api, headers: {"Content-Type": "Application/json"}, body: data1);
                                                                                        // var res = await json.decode(response.body);
                                                                                        // msg = res['status_message'].toString();
                                                                                        // if (msg == "Success") {
                                                                                        //   Fluttertoast.showToast(msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
                                                                                        //   setState(() {
                                                                                        //     loading = false;
                                                                                        //     Navigator.push(
                                                                                        //         context,
                                                                                        //         MaterialPageRoute(
                                                                                        //             builder: (context) => ChatDetail(
                                                                                        //                   name: request_list_sent_by_user_data[index]['vendor_profile']['name'].toString(),
                                                                                        //                   img: request_list_sent_by_user_data[index]['vendor_profile']['profile_pic'].toString(),
                                                                                        //                   userid: request_list_sent_by_user_data[index]['vendor_profile']['vendor_ID'].toString(),
                                                                                        //                   chat_id: res['chat_id'].toString(),
                                                                                        //                 )));
                                                                                        //   });
                                                                                        // } else {
                                                                                        //   // ignore: use_build_context_synchronously
                                                                                        //   Navigator.pop(context);
                                                                                        //   setState(() {
                                                                                        //     loading = false;
                                                                                        //   });
                                                                                        //   Fluttertoast.showToast(msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
                                                                                        // }
                                                                                      } else {
                                                                                        // ignore: use_build_context_synchronously
                                                                                        Navigator.pop(context);
                                                                                        setState(() {
                                                                                          loading = false;
                                                                                        });
                                                                                        Fluttertoast.showToast(msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
                                                                                      }
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
                                                      child: Row(
                                                        children: const [
                                                          Icon(
                                                            Icons
                                                                .chat_bubble_outline_outlined,
                                                            color: Colors.white,
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            "Chat",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "+ ₹ ${request_list_sent_by_user_data[index]['vendor_profile']['chat_rate'].toString()} / min",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5, bottom: 0),
                                                  child: Container(
                                                    height: 28,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7))),
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Waiting for counsellor response!',
                                                            fontSize: 14,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM);
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Icon(
                                                            Icons.timelapse,
                                                            color: Colors.white,
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            "Wait",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ));
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

  Widget chat_list() {
    return Container(
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
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue, width: 0.5)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 310,
                          child: TextFormField(
                            onEditingComplete: getSearched,
                            controller: _name,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(12),
                              border: InputBorder.none,
                              hintStyle: const TextStyle(color: Colors.grey),
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
                  isSearched
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                          height: MediaQuery.of(context).size.height * 0.88,
                          child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              // ignore: unnecessary_null_comparison
                              itemCount: searchedvendor_list == null
                                  ? 0
                                  : searchedvendor_list.length,
                              itemBuilder: (BuildContext context, index) {
                                return Card(
                                  elevation: 1,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                8.2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  searchedvendor_list[index]
                                                      ['profile_pic'],
                                                ),
                                                fit: BoxFit.fill),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: RatingBar.builder(
                                              initialRating: 3.5,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15.0,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                size: 50,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) async {},
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            searchedvendor_list[index]['name'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 17),
                                          ),
                                          const Text(
                                            "Tarot life Coach",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          const Text(
                                            "Language -",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "${searchedvendor_list[index]['language']}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "Exp ${searchedvendor_list[index]['experinece_y']}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "₹ ${searchedvendor_list[index]['call_rate']} / min",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, bottom: 8),
                                                child: Container(
                                                  height: 28,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      color: ABConstraints
                                                          .themeColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  7))),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  ABConstraints
                                                                      .themeColor,
                                                              content: SizedBox(
                                                                height: 90,
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.9,
                                                                  child: Column(
                                                                    children: [
                                                                      const Text(
                                                                        "Are you sure want to Chat Request?",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.white),
                                                                      ),
                                                                      const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
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
                                                                                final response = await http.post(api,
                                                                                    headers: {
                                                                                      "Content-Type": "Application/json"
                                                                                    },
                                                                                    body: data1);
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
                                                    child: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons
                                                              .chat_bubble_outline_outlined,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          "Chat",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.white),
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
                      : Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                          height: MediaQuery.of(context).size.height * 0.88,
                          child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              // ignore: unnecessary_null_comparison
                              itemCount:
                                  vendor_list == null ? 0 : vendor_list.length,
                              itemBuilder: (BuildContext context, index) {
                                return Card(
                                  elevation: 1,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                8.2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  vendor_list[index]
                                                      ['profile_pic'],
                                                ),
                                                fit: BoxFit.fill),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: RatingBar.builder(
                                              initialRating: 3.5,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15.0,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                size: 50,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) async {},
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            vendor_list[index]['name'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 17),
                                          ),
                                          const Text(
                                            "Tarot life Coach",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          const Text(
                                            "Language -",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "${vendor_list[index]['language']}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "Exp ${vendor_list[index]['experinece_y']}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "₹ ${vendor_list[index]['call_rate']} / min",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                              ),
                                              vendor_list[index][
                                                              'chat_request_sent']
                                                          .toString() ==
                                                      'No'
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10,
                                                              bottom: 8),
                                                      child: Container(
                                                        height: 28,
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                            color: ABConstraints
                                                                .themeColor,
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            7))),
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        ABConstraints
                                                                            .themeColor,
                                                                    content:
                                                                        SizedBox(
                                                                      height:
                                                                          90,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.9,
                                                                        child:
                                                                            Column(
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
                                                                                        'listener_id': vendor_list[index]['listner_id'].toString(),
                                                                                      };
                                                                                      var data1 = jsonEncode(data);
                                                                                      var api = Uri.parse("https://counsellor.creditmywallet.in.net/api/send_chat_request");
                                                                                      final response = await http.post(api,
                                                                                          headers: {
                                                                                            "Content-Type": "Application/json"
                                                                                          },
                                                                                          body: data1);
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
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .chat_bubble_outline_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                "Chat",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10,
                                                              bottom: 8),
                                                      child: Container(
                                                        height: 28,
                                                        width: 90,
                                                        decoration: const BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7))),
                                                        child: MaterialButton(
                                                          onPressed: () {},
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .chat_bubble_outline_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 12,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                "Requested",
                                                                style: TextStyle(
                                                                    fontSize: 8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white),
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
              ));
  }
}
