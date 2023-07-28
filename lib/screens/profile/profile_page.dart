import 'package:counsller_flutter_app/screens/Dashboard/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Constraints_color/constraints.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ProfilePage(
      {Key? key, required this.name, required this.mobile, required this.email})
      : super(key: key);
  String name;
  String email;
  String mobile;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ABConstraints.themeColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            title: const Text(
              "Profile",
            ),
            foregroundColor: ABConstraints.white,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey.shade200,
                      elevation: 0.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          image: AssetImage("images/bg.jpg"),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // Text(
                                    //   '${widget.name.toString()}',
                                    //   style: const TextStyle(
                                    //       color: Colors.black,
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 15),
                                    // ),
                                    // Text(
                                    //   "${widget.mobile}",
                                    //   style: const TextStyle(
                                    //       color: Colors.black,
                                    //       //fontWeight: FontWeight.bold,
                                    //       fontSize: 14),
                                    // ),
                                    // Text(
                                    //   "${widget.email}",
                                    //   style: const TextStyle(
                                    //       color: Colors.black,
                                    //       //fontWeight: FontWeight.bold,
                                    //       fontSize: 13),
                                    // ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(Icons.share),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(Icons.share),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "About me",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                                "In literary theory, a text is any object that can be read, whether this object is a work of literature, a street sign, an arrangement of buildings on a city block, or styles of clothing. It is a coherent set of signs that transmits some kind of informative message."),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>))
                            },
                            child: SizedBox(
                              height: 180,
                              width: MediaQuery.of(context).size.width / 2.14,
                              child: Card(
                                color: Colors.grey.shade200,
                                elevation: 0.0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.close_outlined,
                                              color: Colors.black,
                                              size: 55,
                                            )),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, bottom: 10),
                                        child: Text("Interest",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(11)),
                                          color: ABConstraints.themeColor,
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Breakup & Relationship",
                                            style: TextStyle(
                                                color: ABConstraints.white,
                                                fontSize: 9),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 180,
                            width: MediaQuery.of(context).size.width / 2.14,
                            child: Card(
                              color: Colors.grey.shade200,
                              elevation: 0.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text("a b",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, bottom: 10),
                                        child: Text("Details",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 17,
                                              width: 17,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50)),
                                                color: ABConstraints.themeColor,
                                              ),
                                              child: Icon(
                                                Icons.info_outline,
                                                size: 12,
                                                color: ABConstraints.blackshade,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              "Male",
                                              style: TextStyle(
                                                  color: ABConstraints.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 32,
                                            ),
                                            Text(
                                              "32 Years",
                                              style: TextStyle(
                                                color: ABConstraints.black,
                                                fontSize: 13,
                                                //fontWeight: FontWeight.w700
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Container(
                                              height: 17,
                                              width: 17,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50)),
                                                color: ABConstraints.themeColor,
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                size: 12,
                                                color: ABConstraints.blackshade,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              "Language",
                                              style: TextStyle(
                                                  color: ABConstraints.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 180,
                            width: MediaQuery.of(context).size.width / 2.14,
                            child: Card(
                              color: Colors.grey.shade200,
                              elevation: 0.0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          children: const [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 0),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.black,
                                                size: 50,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text("Rating",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: const [
                                            Text("4.61",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text("1245REVIEW",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10)),
                                            Text("Listening Hours",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10)),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Text("200",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14)),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.8,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        RatingBarIndicator(
                                          rating: 1,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            size: 55,
                                            color: Colors.orange,
                                          ),
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1),
                                          itemCount: 5,
                                          itemSize: 19,
                                          direction: Axis.horizontal,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 180,
                            width: MediaQuery.of(context).size.width / 2.16,
                            child: Card(
                              color: Colors.grey.shade200,
                              elevation: 0.0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          children: const [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 0),
                                                child: Icon(
                                                  Icons.currency_rupee_outlined,
                                                  color: Colors.black,
                                                  size: 46,
                                                )),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text("Charges",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Stack(
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Padding(
                                            padding: EdgeInsets.only(left: 28),
                                            child: Text("₹  8.0",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
                                          ),
                                        ),
                                        const Positioned(
                                          top: 7,
                                          left: 80,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Text("per min",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Center(
                                      child: Text("Available Now",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14)),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: const <Widget>[
                                              Icon(Icons
                                                  .chat_bubble_outline_outlined),
                                              Center(
                                                child: Text("Chat",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11)),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            children: const <Widget>[
                                              Icon(Icons.call_outlined),
                                              Center(
                                                child: Text("Call",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width,
                      color: ABConstraints.themeColor,
                      child: Center(
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                              color: ABConstraints.blackshade,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 92,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          SizedBox(
                            height: 29,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: RatingBar.builder(
                                    initialRating: 3.5,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 15.0,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      size: 50,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) async {},
                                  ),
                                ),
                                const Spacer(),
                                const Text("Yesterday"),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Good",
                                style: TextStyle(
                                    color: Colors.black,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
