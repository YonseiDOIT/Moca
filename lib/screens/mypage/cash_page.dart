import 'package:flutter/material.dart';

// global variables
import 'package:app/globals.dart';
import 'package:app/globals.dart' as globals;

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

class CashPage extends StatefulWidget {
  const CashPage({
    super.key,
    required this.setParentIndex,
  });
  final Function(int index) setParentIndex;

  static List<String> cashList = ["1000", " 5000", "10000", "30000", "50000"];

  @override
  State<CashPage> createState() => _CashPageState();
}

class _CashPageState extends State<CashPage> {
  late int mocaCash = MocaUser.moca_cash;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return widget.setParentIndex(0);
      },
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            Container(
              height: 80,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.setParentIndex(0);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  Text(
                    "마이페이지 > 캐시 관리",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "보유캐시",
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text(
                                "$mocaCash 원",
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            ],
                          ),
                          Image.asset("assets/images/receive cash.png", height: 150),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                border: const Border.symmetric(
                                  horizontal: BorderSide(color: Colors.black54),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("충전 캐시", style: Theme.of(context).textTheme.titleMedium),
                                  Text("결제 금액", style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            );
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("${CashPage.cashList[index - 1]} 캐시", style: Theme.of(context).textTheme.titleSmall),
                                GestureDetector(
                                  onTap: () {
                                    int time = DateTime.now().millisecond;
                                    int cash = int.parse(CashPage.cashList[index - 1]) * int.parse(MocaUser.kakao_id) * time;

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return FutureBuilder(
                                          future: moca_api.Users.mocaCash(
                                            MocaUser.id,
                                            cash,
                                            time,
                                          ),
                                          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                                            if (snapshot.hasData == false) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }

                                            // return Container();
                                            return AlertDialog(
                                              content: Text(
                                                "${CashPage.cashList[index - 1]}원 충전되었습니다.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('예'),
                                                  onPressed: () {
                                                    setState(() {
                                                      mocaCash = MocaUser.moca_cash;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text("${CashPage.cashList[index - 1]} 원"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // Column(
      //     children: [
      //       Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      //         width: globals.ScreenSize.width,
      //         decoration: const BoxDecoration(
      //           borderRadius: BorderRadius.vertical(
      //             bottom: Radius.circular(20),
      //           ),
      //           boxShadow: <BoxShadow>[
      //             BoxShadow(
      //               color: Colors.black54,
      //               blurRadius: 10.0,
      //               spreadRadius: -2.0,
      //               offset: Offset(0.0, 0.0),
      //             )
      //           ],
      //           color: Colors.white,
      //         ),
      //         child: Stack(
      //           alignment: Alignment.center,
      //           children: [
      //             const Text("캐시 관리"),
      //             Positioned(
      //               left: 0,
      //               child: IconButton(
      //                 onPressed: () {
      //                   widget.setParentIndex(0);
      //                 },
      //                 icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Container(
      //         padding: const EdgeInsets.symmetric(vertical: 50),
      //         child: Column(
      //           children: [const Text("보유캐시"), Text("$mocaCash 원")],
      //         ),
      //       ),
      //       Expanded(
      //         child: Container(
      //           child: ListView.builder(
      //             physics: const NeverScrollableScrollPhysics(),
      //             itemCount: 6,
      //             itemBuilder: (BuildContext context, int index) {
      //               if (index == 0) {
      //                 return Container(
      //                   padding: const EdgeInsets.symmetric(vertical: 10),
      //                   margin: const EdgeInsets.symmetric(horizontal: 30),
      //                   decoration: BoxDecoration(
      //                     color: Colors.grey[300],
      //                     border: const Border.symmetric(
      //                       horizontal: BorderSide(color: Colors.black),
      //                     ),
      //                   ),
      //                   child: const Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       Text("충전 캐시"),
      //                       Text("결제 금액"),
      //                     ],
      //                   ),
      //                 );
      //               }
      //               return Container(
      //                 padding: const EdgeInsets.symmetric(vertical: 4),
      //                 margin: const EdgeInsets.symmetric(horizontal: 30),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   children: [
      //                     Text("${CashPage.cashList[index - 1]} 캐시"),
      //                     TextButton(
      //                       style: ButtonStyle(
      //                         backgroundColor: MaterialStateProperty.all<Color>(
      //                           Colors.grey[200]!,
      //                         ),
      //                       ),
      //                       onPressed: () {
      //                         int time = DateTime.now().millisecond;
      //                         int cash = int.parse(CashPage.cashList[index - 1]) *
      //                             int.parse(MocaUser.kakao_id) *
      //                             time;
      //                         print(cash);
      //                         showDialog(
      //                           context: context,
      //                           barrierDismissible: false,
      //                           builder: (BuildContext context) {
      //                             return FutureBuilder(
      //                               future: moca_api.Users.mocaCash(
      //                                 MocaUser.id,
      //                                 cash,
      //                                 time,
      //                               ),
      //                               builder: (BuildContext context,
      //                                   AsyncSnapshot<Map> snapshot) {
      //                                 if (snapshot.hasData == false) {
      //                                   return const Center(
      //                                     child: CircularProgressIndicator(),
      //                                   );
      //                                 }

      //                                 // return Container();
      //                                 return AlertDialog(
      //                                   content: Text(
      //                                     "${CashPage.cashList[index - 1]}원 충전되었습니다.",
      //                                   ),
      //                                   actions: [
      //                                     TextButton(
      //                                       child: const Text('예'),
      //                                       onPressed: () {
      //                                         setState(() {
      //                                           mocaCash = MocaUser.moca_cash;
      //                                         });
      //                                         Navigator.of(context).pop();
      //                                       },
      //                                     ),
      //                                   ],
      //                                 );
      //                               },
      //                             );
      //                           },
      //                         );
      //                       },
      //                       child: Text("${CashPage.cashList[index - 1]} 원"),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
    );
  }
}
