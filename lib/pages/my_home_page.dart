import 'package:flutter/material.dart';
import 'package:flutter_payment_app/component/colors.dart';
import 'package:flutter_payment_app/models/transaction.dart';
import 'package:flutter_payment_app/pages/payment_page.dart';
import 'package:flutter_payment_app/widgets/buttons.dart';
import 'package:flutter_payment_app/widgets/large_buttons.dart';
import 'package:flutter_payment_app/widgets/new_transaction.dart';
import 'package:flutter_payment_app/widgets/text_size.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Transaction> _userTransactions = [];
  void loadData() async {
    // var list = await DatabaseHelper.instance.getTransactions() ?? [];
    //print("list: ${list[0].title}");
    //print(list.);
    // list.forEach((trans) {
    //   print("printing: $trans");
    //   print(_userTransactions);
    //   return _userTransactions.add(trans);
    //});
    setState(() {});
    //print("added from database");
  }

  // DatabaseHelper.instance.getTransactions() as List;

  // void loadData() {
  //   FutureBuilder<List<Transaction>>(
  //       future: DatabaseHelper.instance.getTransactions(),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
  //         if (!snapshot.hasData) {
  //           return;
  //         }
  //         snapshot.data
  //             .map((transaction) => _userTransactions.add(transaction));
  //       });
  // }

  // Future<List<Transaction>> loadData() async {
  //   final db = await Databs;

  //   final List<Map<String, dynamic>> maps = await db.query('expenses');
  // }

  bool _showChart = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    //setState(() {
    loadData();
    //});

    print("init :$_userTransactions");
    super.initState();
  }

  // after writing a listner you need to disposer it
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    print('didChange $_userTransactions');
    //loadData();
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewTransaction(String txTitle, String cashType, double txAmount,
      DateTime chosenDate) async {
    final newTx = Transaction(
      title: txTitle,
      cashType: cashType,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    // await DatabaseHelper.instance.add(newTx);
    // final db = DatabaseHelper.instance.getTransactions();
    // print("Database please" + db.toString());
    setState(() {
      // _userTransactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: Container(
        height: h,
        child: Stack(
          children: [
            _headSection(),
            _listBills(),
            _payButton(),
          ],
        ),
      ),
    );
  }

  _headSection() {
    return Container(
        height: 310,
        child: Stack(
          children: [
            _mainBackground(),
            _curveImageContainer(),
            _buttonContainer(),
            _textContainer(),
          ],
        ));
  }

  _buttonContainer() {
    return Positioned(
      right: 42,
      bottom: 10,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              barrierColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext Bc) {
                return Container(
                  height: MediaQuery.of(context).size.height - 240,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          // color: Colors.grey.withOpacity(0.5),
                          color: Color(0xFFeef1f4).withOpacity(0.7),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 300,
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 42,
                          child: Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 25),
                            width: 60,
                            height: 250,
                            decoration: BoxDecoration(
                              color: AppColor.mainColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppButtons(
                                    icon: Icons.cancel,
                                    iconColor: AppColor.mainColor,
                                    textColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    onTap: () {
                                      Navigator.pop(context);
                                    }),
                                AppButtons(
                                    icon: Icons.add,
                                    iconColor: AppColor.mainColor,
                                    textColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    text: "Add Bill",
                                    onTap: () {
                                      // Navigator.pop(context);
                                    }),
                                AppButtons(
                                    icon: Icons.history,
                                    iconColor: AppColor.mainColor,
                                    textColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    text: "History",
                                    onTap: () {
                                      // Navigator.pop(context);
                                    }),
                              ],
                            ),
                          ))
                    ],
                  ),
                );
              });
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "images/lines.png",
              ),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                offset: Offset(0, 1),
                color: Color(0xFF11324d).withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _mainBackground() {
    return Positioned(
        bottom: 10,
        left: 0,
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/background.png"),
          )),
        ));
  }

  _curveImageContainer() {
    return Positioned(
      left: 0,
      right: -13,
      bottom: 10,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("images/curve.png"),
        )),
      ),
    );
  }

  _listBills() {
    return Positioned(
      top: 320,
      left: 0,
      right: 0,
      bottom: 0,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (_, index) {
            return Container(
              margin: const EdgeInsets.only(top: 20, right: 20),
              height: 130,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFd8dbe0),
                    offset: Offset(1, 1),
                    blurRadius: 20.0,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 3, color: Colors.grey),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("images/Money3.jpg"),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "KenGen Power",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColor.mainColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  // "ID 844623",
                                  "cash: earned",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColor.idColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedText(
                          text: "Auto pay on 24th May 18",
                          color: AppColor.green,
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  //color: AppColor.selectBackground,
                                  //color: Color.fromARGB(255, 238, 67, 54)),
                                  color: Colors.orangeAccent),
                              child: Center(
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      fontSize: 16,
                                      //color: AppColor.selectColor,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "\$1248.00",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColor.mainColor,
                              ),
                            ),
                            Text(
                              "ID: 12345",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColor.idColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 5,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColor.halfOval,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _payButton() {
    return Positioned(
      bottom: 10,
      child: AppLargeButton(
        text: "Add new bill",
        textColor: Colors.white,
        onTap: () {
          //Get.to(() => const PaymentPage());
          return _startAddNewTransaction(context);
        },
      ),
    );
  }

  _textContainer() {
    return Stack(
      children: [
        Positioned(
            left: 0,
            top: 100,
            child: Text(
              "My Bills",
              style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF293952)),
            )),
        Positioned(
            left: 40,
            top: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My  Expenses",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "INCOME : \$20 000",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 170, 147, 147),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "EXP : \$20 000",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 170, 147, 147),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
