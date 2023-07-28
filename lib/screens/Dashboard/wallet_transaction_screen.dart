import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class WalletTracsaction extends StatefulWidget {
  const WalletTracsaction({Key? key}) : super(key: key);
  @override
  State<WalletTracsaction> createState() => _WalletTracsactionState();
}

class _WalletTracsactionState extends State<WalletTracsaction> {
  String? msg;
  String? usedId;

  List? dataList;
  List? imageListwe;
  bool loading = false;

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
      dataList = res['response'];
      // imageListwe = res['response'][0]['crop_diseases'];
      print('Wallet History List' + dataList.toString());
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

  @override
  void initState() {
    walletHistoryData();
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
        title: const Text(
          "Wallet History",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.88,
                child: dataList == null
                    ? const Center(
                        child: Text('No Data'),
                      )
                    : ListView.builder(
                        itemCount: dataList?.length,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                                dataList![index]['date_time']
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
                                                dataList![index]
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                " ₹ ${dataList![index]['amount'].toString()}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
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
      ),
    );
  }
}
