import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:http/http.dart' as http;

import '../../Constraints_color/constraints.dart';
import '../../HelperFunctions/HelperFunctions.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var getData;
  bool loading = false;

  String? userName;
  String? userNumber;
  String? userEmail;
  String? userProfilepic;
  String? userdob;
  String? userGender;
  String? userCity;
  String? userState;

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _gendercontroller = TextEditingController();
  TextEditingController _citycontroller = TextEditingController();
  TextEditingController _statecontroller = TextEditingController();

  TextEditingController otp = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  String? dob;
  late DateTime _myDateTime;
  final picker = ImagePicker();
  Future getProfile() async {
    setState(() {
      loading = true;
    });
    var api = Uri.parse(
        "https://counsellor.creditmywallet.in.net/api/getuserprofile");
    var userID = await HelperFunctions.getuserID();
    print(userID.toString());
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
          userdob = getData['dob'];
          userGender = getData['gender'];
          userCity = getData['city'];
          userState = getData['state'];
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

  Future updateData(
    String urllink,
    String parameter,
    String parameterValue,
  ) async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    print(userID.toString());
    Map data = {
      'user_id': userID.toString(),
      '$parameter': parameterValue,
    };
    Uri url = Uri.parse(urllink);
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    if (response.statusCode == 200) {
      var res = await json.decode(response.body);
      String msg = res['status_code'].toString();
      if (msg == "200") {
        setState(() {
          loading = false;
          getProfile();
          _validate = false;
          _mobileNumber.clear();
          Navigator.pop(context);
        });
        Fluttertoast.showToast(
            msg: res['status_message'].toString(),
            backgroundColor: Colors.green,
            gravity: ToastGravity.CENTER);
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(msg: res['status_message'].toString());
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  File? CropImage;
  Future CropImage1(context, ImageSource source) async {
    setState(() {
      loading = true;
    });
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        loading = false;
        CropImage = new File(pickedFile.path);
        print(CropImage!.path);
        EditProfile();
      });
    } else {
      setState(() {
        loading = false;
        Fluttertoast.showToast(
            msg: 'Something Went Wrong',
            backgroundColor: Colors.green,
            gravity: ToastGravity.CENTER);
      });
    }
  }

  Future EditProfile() async {
    setState(() {
      loading = true;
    });
    var userID = await HelperFunctions.getuserID();
    String addhar1 = CropImage!.path.split('/').last;
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': userID.toString(),
      'profile_pic':
          await MultipartFile.fromFile(CropImage!.path, filename: addhar1),
    });
    print(formData.toString());
    var response = await dio.post(
        'https://counsellor.creditmywallet.in.net/api/updateProfilePic',
        data: formData);
    print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
    print("response ====>>>" + response.toString());
    var res = response.data;
    int msg = res['status_code'];
    print("bjhgbvfjhdfgbfu====>..." + msg.toString());
    if (msg == 200) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          res['status_message'].toString(),
        ),
      ));
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          res['status_message'].toString(),
        ),
      ));
    }
  }

  bool _validate = false;

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ABConstraints.themeColor,
        // backgroundColor:Colors.white,
        title: const Text(
          "PROFILE PAGE",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        elevation: 1.0,
        foregroundColor: ABConstraints.white,
      ),
      backgroundColor: ABConstraints.themeColor,
      body: RefreshIndicator(
        onRefresh: getProfile,
        child: SingleChildScrollView(
          child: loading
              ? const Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 0, right: 0, top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // userProfilepic == 'avtar.png'
                            //     ?
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Upload profile image"),
                                      actions: <Widget>[
                                        MaterialButton(
                                          child: const Text("Camera"),
                                          onPressed: () {
                                            CropImage1(
                                                context, ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        MaterialButton(
                                          child: const Text("Gallery"),
                                          onPressed: () {
                                            CropImage1(
                                                context, ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 22),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        image:  DecorationImage(
                                            image: NetworkImage(
                                                userProfilepic!),
                                            fit: BoxFit.fill),
                                        color: Colors.white38,
                                        borderRadius: BorderRadius.circular(15),
                                        // border: Border.all(width: 1.5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Click to update profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                            // : CropImage == null
                            //     ? Padding(
                            //         padding: const EdgeInsets.only(
                            //             left: 10, top: 22),
                            //         child: Container(
                            //           height: 100,
                            //           width: 100,
                            //           decoration: BoxDecoration(
                            //               color: Colors.white38,
                            //               borderRadius:
                            //                   BorderRadius.circular(15),
                            //               border: Border.all(width: 1.5)),
                            //           child: CachedNetworkImage(
                            //             imageUrl: userProfilepic.toString(),
                            //             placeholder: (context, url) =>
                            //                 const CircularProgressIndicator(),
                            //             errorWidget:
                            //                 (context, url, error) =>
                            //                     const Icon(Icons.error),
                            //           ),
                            //         ),
                            //       )
                            //     : Padding(
                            //         padding: const EdgeInsets.only(
                            //             left: 10, top: 22),
                            //         child: Container(
                            //           height: 100,
                            //           width: 100,
                            //           decoration: BoxDecoration(
                            //               color: Colors.white38,
                            //               borderRadius:
                            //                   BorderRadius.circular(15),
                            //               border: Border.all(width: 1.5)),
                            //           child: Image.file(CropImage!,
                            //               fit: BoxFit.cover),
                            //         ),
                            //       ),
                            ,
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.only(top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        userNumber!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      height: 125,
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                            "Update Now",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const Divider(
                                                            thickness: 1,
                                                            color: Colors.black,
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          SizedBox(
                                                            height: 70,
                                                            child:
                                                                TextFormField(
                                                              maxLength: 10,
                                                              controller:
                                                                  _mobileNumber,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration: InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  errorText:
                                                                      _validate
                                                                          ? 'Value Can\'t Be Empty'
                                                                          : null,
                                                                  hintText:
                                                                      '+91 Enter Mobile Number',
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10),
                                                                  hintStyle: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10))),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      Center(
                                                        child: Container(
                                                            height: 35,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.65,
                                                            color: Colors
                                                                .transparent,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_mobileNumber
                                                                    .text
                                                                    .isEmpty) {
                                                                  setState(() {
                                                                    _validate =
                                                                        true;
                                                                  });
                                                                } else {
                                                                  updateData(
                                                                      'https://counsellor.creditmywallet.in.net/api/UpdateMobile',
                                                                      'mobile',
                                                                      _mobileNumber
                                                                          .text);
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Update",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                         
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.white70,
                                            )),
                                      )
                                    ],
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
                                    "My Profile :",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.black,
                                endIndent: 220,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Name :",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black45),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Text(
                                          userName!,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height: 170,
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                              "Update Now",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            // Divider(thickness: 1,color: Colors.black,),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            SizedBox(
                                                              height: 70,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _namecontroller,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration: InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    errorText: _validate
                                                                        ? 'Value Can\'t Be Empty'
                                                                        : null,
                                                                    hintText:
                                                                        'Update you Name',
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10))),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: ABConstraints
                                                                        .themeColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    MaterialButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (_namecontroller
                                                                        .text
                                                                        .isEmpty) {
                                                                      setState(
                                                                          () {
                                                                        _validate =
                                                                            true;
                                                                      });
                                                                    } else {
                                                                      updateData(
                                                                          'https://counsellor.creditmywallet.in.net/api/UpdateName',
                                                                          'name',
                                                                          _namecontroller
                                                                              .text);
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Update",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.black54,
                                            ))
                                      ],
                                    ),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Email_id :",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black45),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        userEmail == null
                                            ? const Text(
                                                'No Email Updated',
                                                style: TextStyle(fontSize: 15),
                                              )
                                            : Text(
                                                userEmail!,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height: 170,
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                              "Update Now",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            // Divider(thickness: 1,color: Colors.black,),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            SizedBox(
                                                              height: 70,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _emailcontroller,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .emailAddress,
                                                                decoration: InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    errorText: _validate
                                                                        ? 'Value Can\'t Be Empty'
                                                                        : null,
                                                                    hintText:
                                                                        'Update you Email',
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10))),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: ABConstraints
                                                                        .themeColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    MaterialButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (_emailcontroller
                                                                        .text
                                                                        .isEmpty) {
                                                                      setState(
                                                                          () {
                                                                        _validate =
                                                                            true;
                                                                      });
                                                                    } else {
                                                                      updateData(
                                                                          'https://counsellor.creditmywallet.in.net/api/UpdateEmail',
                                                                          'email',
                                                                          _emailcontroller
                                                                              .text);
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Update",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.black54,
                                            ))
                                      ],
                                    ),
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
                              GestureDetector(
                                onTap: () async {
                                  _myDateTime = (await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2050),
                                  ))!;
                                  setState(() {
                                    dob = DateFormat('yyyy-MM-dd')
                                        .format(_myDateTime);
                                  });
                                  updateData(
                                      'https://counsellor.creditmywallet.in.net/api/Updatedob',
                                      'dob',
                                      dob.toString());
                                },
                                child: Row(
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
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        userdob == null
                                            ? const Text(
                                                'No DOB Updated',
                                                style: TextStyle(fontSize: 15),
                                              )
                                            : Text(
                                                userdob!,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black38,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Gender :",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black45),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        userGender == null
                                            ? const Text(
                                                'No Gender Updated',
                                                style: TextStyle(fontSize: 15),
                                              )
                                            : Text(
                                                userGender == '1'
                                                    ? 'Female'
                                                    : 'Male',
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return AlertDialog(
                                                        content: SizedBox(
                                                          height: 180,
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                "Update Now",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              // Divider(thickness: 1,color: Colors.black,),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              SizedBox(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child: Row(
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                              width: 170,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Image.asset(
                                                                                    'images/boy.png',
                                                                                    width: 25,
                                                                                    height: 25,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  const Text(
                                                                                    'Male',
                                                                                    style: TextStyle(fontSize: 14),
                                                                                  ),
                                                                                  Radio(
                                                                                    activeColor: Theme.of(context).primaryColor,
                                                                                    value: gender[0],
                                                                                    groupValue: select,
                                                                                    onChanged: (value) {
                                                                                      setState(() {
                                                                                        select = value;
                                                                                      });
                                                                                      print(select);
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 170,
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Image.asset(
                                                                                    'images/girl.png',
                                                                                    width: 25,
                                                                                    height: 25,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  const Text(
                                                                                    'Female',
                                                                                    style: TextStyle(fontSize: 14),
                                                                                  ),
                                                                                  Radio(
                                                                                    activeColor: Theme.of(context).primaryColor,
                                                                                    value: gender[1],
                                                                                    groupValue: select,
                                                                                    onChanged: (value) {
                                                                                      setState(() {
                                                                                        select = value;
                                                                                      });
                                                                                      print(select);
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )),
                                                              const SizedBox(
                                                                height: 0,
                                                              ),
                                                              Container(
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color: ABConstraints
                                                                          .themeColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      updateData(
                                                                          'https://counsellor.creditmywallet.in.net/api/UpdateGender',
                                                                          'gender',
                                                                          select == 'Male'
                                                                              ? '0'
                                                                              : '1');
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Update",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.black54,
                                            ))
                                      ],
                                    ),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "City :",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black45),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        userCity == null
                                            ? const Text(
                                                'No City Updated',
                                                style: TextStyle(fontSize: 15),
                                              )
                                            : Text(
                                                userCity!,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height: 170,
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                              "Update Now",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            // Divider(thickness: 1,color: Colors.black,),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            SizedBox(
                                                              height: 70,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _citycontroller,
                                                                decoration: InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    errorText: _validate
                                                                        ? 'Value Can\'t Be Empty'
                                                                        : null,
                                                                    hintText:
                                                                        'Update you City',
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10))),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: ABConstraints
                                                                        .themeColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    MaterialButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (_citycontroller
                                                                        .text
                                                                        .isEmpty) {
                                                                      setState(
                                                                          () {
                                                                        _validate =
                                                                            true;
                                                                      });
                                                                    } else {
                                                                      updateData(
                                                                          'https://counsellor.creditmywallet.in.net/api/UpdateCity',
                                                                          'city',
                                                                          _citycontroller
                                                                              .text);
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Update",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.black54,
                                            ))
                                      ],
                                    ),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "State :",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black45),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        userState == null
                                            ? const Text(
                                                'No State Updated',
                                                style: TextStyle(fontSize: 15),
                                              )
                                            : Text(
                                                userState!,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height: 170,
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                              "Update Now",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            // Divider(thickness: 1,color: Colors.black,),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            SizedBox(
                                                              height: 70,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _statecontroller,
                                                                decoration: InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    errorText: _validate
                                                                        ? 'Value Can\'t Be Empty'
                                                                        : null,
                                                                    hintText:
                                                                        'Update you State',
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10))),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: ABConstraints
                                                                        .themeColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    MaterialButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (_statecontroller
                                                                        .text
                                                                        .isEmpty) {
                                                                      setState(
                                                                          () {
                                                                        _validate =
                                                                            true;
                                                                      });
                                                                    } else {
                                                                      updateData(
                                                                          'https://counsellor.creditmywallet.in.net/api/UpdateState',
                                                                          'state',
                                                                          _statecontroller
                                                                              .text);
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Update",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.black54,
                                            ))
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 0.5,
                                    color: Colors.black38,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List gender = ["Male", "Female", "Other"];
  String? select;
}
