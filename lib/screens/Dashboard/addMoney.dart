import 'package:counsller_flutter_app/Constraints_color/constraints.dart';
import 'package:counsller_flutter_app/screens/Dashboard/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../HelperFunctions/HelperFunctions.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({Key? key}) : super(key: key);

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  bool walletbalanceloading = true;
  String walletbalance = "";
  final TextEditingController _amount = TextEditingController();
  // ignore: non_constant_identifier_names
  String transection_id = "";

  List waletHistoryList = [];
  bool isloading = false;

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

  var getData;
  String? userNumber;

  Future getProfile() async {
    setState(() {
      isloading = true;
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
          isloading = false;

          userNumber = getData['mobile'];
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
        content: Text(msg.toString()),
      ));
    }
  }

  Future addMoney() async {
    setState(() {
      isloading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/recharge_user_wallet");
    var userID = await HelperFunctions.getuserID();
    Map mapeddate = {
      'user_id': userID.toString(),
      'mobile': userNumber,
      'recharge_amt': _amount.text,
      'transection_id': transection_id.toString(),
      'amount': _amount.text,
      'entity': 'required',
      'payment_status': 'captured',
      'contact': 'required',
      'fee': 'required',
    };
    final response = await http.post(
      api,
      body: mapeddate,
    );
    print(mapeddate);
    var res = await json.decode(response.body);
    String msg = '';
    msg = res['status_message'].toString();
    try {
      if (msg == 'Money Added to Wallet') {
        setState(() {
          isloading = false;
          walletHistoryData();
          getBalance();
          getProfile();
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pament success of $transection_id"),
        ));
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

  String? msg;
  String? usedId;

  List? dataList;
  List? imageListwe;

  void walletHistoryData() async {
    setState(() {
      isloading = true;
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
        isloading = false;
      });
      dataList = res['response'];
      // imageListwe = res['response'][0]['crop_diseases'];
      print('Wallet History List' + dataList.toString());
      setState(() {
        msg = res['status_message'];
      });
    } else {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(
          msg: msg.toString(), fontSize: 14, gravity: ToastGravity.BOTTOM);
      throw Exception('unexpected error occurred');
    }
  }

  late Razorpay razorpay;

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
    // _amount.clear();
  }

  void openCheckout() async {
    setState(() {
      isloading = true;
    });
    var userID = await HelperFunctions.getuserID();
    var options = {
      "key": "rzp_test_mXi7bqjhaWun9u",
      "amount": num.parse(_amount.text) * 100,
      "name": "Counsler App",
      "description": "Payment for the Counsler App",
      "prefil": {
        // "userId": "$userID",
        "contact": "$userNumber",
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      setState(() {
        isloading = false;
      });
      razorpay.open(options);
    } catch (e) {
      setState(() {
        isloading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse razresponse) async {
    setState(() {
      transection_id = razresponse.paymentId.toString();
      addMoney();
    });
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print("Pament error");
    Fluttertoast.showToast(msg: "Pament error $response");
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet");
    Fluttertoast.showToast(msg: "External Wallet $response");
  }

  @override
  void initState() {
    _amount.text = '50';
    getBalance();
    getProfile();
    walletHistoryData();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawerpage(),
      appBar: AppBar(
        backgroundColor: ABConstraints.themeColor,
        foregroundColor: Colors.white,
        title: const Text('Add Money'),
        elevation: 0,
      ),
      body: isloading
          ? const Padding(
              padding: EdgeInsets.all(50.0),
              child: Center(child: CircularProgressIndicator()),
            )
          : Stack(
              children: [
                SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  // color: AppConstants.themeColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 110.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: ListView(
                          children: [
                            Row(
                              children: const [
                                FaIcon(FontAwesomeIcons.wallet),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add Money in Your Wallet',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Top Up your wallet',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextFormField(
                              controller: _amount,
                              decoration: const InputDecoration(
                                  hintText: '₹ 50',
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _amount.text = '10';
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        // color: AppConstants.themeColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.blue)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('+ ₹ 10'),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _amount.text = '100';
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        // color: AppConstants.themeColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.blue)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('+ ₹ 100'),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _amount.text = '200';
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        // color: AppConstants.themeColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.blue)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('+ ₹ 200'),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _amount.text = '300';
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        // color: AppConstants.themeColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.blue)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('+ ₹ 300'),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _amount.text = '500';
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        // color: AppConstants.themeColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.blue)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('+ ₹ 500'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Image.asset(
                            //         'images/coupon.png',
                            //         scale: 2,
                            //       ),
                            //     ),
                            //     ElevatedButton(
                            //       style: ElevatedButton.styleFrom(
                            //           primary: Colors.black),
                            //       onPressed: () {
                            //         // Navigator.push(
                            //         //     context,
                            //         //     MaterialPageRoute(
                            //         //         builder: (context) =>
                            //         //             ApplyCoupanScreen()));
                            //       },
                            //       child: const Text('Apply Coupon'),
                            //     )
                            //   ],
                            // ),
                            ElevatedButton(
                                // style: ElevatedButton.styleFrom(
                                //   primary: AppConstants.buttonColor,
                                // ),
                                onPressed: () async {
                                  openCheckout();
                                },
                                child: const Text(
                                  'Add Money',
                                  style: TextStyle(fontSize: 18),
                                )),
                            const Divider(),
                            const SizedBox(
                              // margin: const EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(
                                  'YOUR WALLET HISTORY',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff0096bb),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: dataList == null
                                  ? const Center(
                                      child: Text('No Data'),
                                    )
                                  : ListView.builder(
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: dataList?.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 0, 8, 0),
                                                child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              "Recharge",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              "To User Id - $usedId",
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              dataList![index][
                                                                      'date_time']
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            const Text(
                                                              "Transaction_Id - ",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Text(
                                                              dataList![index][
                                                                      'trasnsection_id']
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black54),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              " ₹ ${dataList![index]['amount'].toString()}",
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              height: 50,
                                                            ),
                                                            const Text(
                                                              "Successfull",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .green),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 110,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Available Balance',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '₹ ${walletbalance.toString()}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Status',
                            ),
                          ],
                        ),
                        Image.asset(
                          'images/money.png',
                          scale: 1.5,
                        )
                      ],
                    ))
              ],
            ),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: ABConstraints.themeColor,
          onPressed: () {
            initState();
          },
          child: const Icon(Icons.refresh)),
    );
  }
}
