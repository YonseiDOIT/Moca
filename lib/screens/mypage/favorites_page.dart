import 'package:app/widgets/book.dart';
import 'package:flutter/material.dart';
import 'package:app/globals.dart';

// global variables
import 'package:app/globals.dart' as globals;

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.setParentIndex,
  });
  final Function(int index) setParentIndex;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return setParentIndex(0);
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
                      setParentIndex(0);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  Text(
                    "마이페이지 > 찜한 목록 보기",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: moca_api.Books.getLikedBooks(id: MocaUser.id),
                        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                          if (snapshot.hasData == false) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          List bookList = snapshot.data!["items"];

                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            itemBuilder: (BuildContext context, int index) {
                              return BookWidget(
                                makeFrom: "favorites",
                                bookGroupData: bookList[index]["book_group"],
                                bookData: bookList[index]["book"],
                                state: bookList[index]["state"],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider(height: 5);
                            },
                            itemCount: bookList.length,
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
      //   children: [
      //     Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      //       width: globals.ScreenSize.width,
      //       decoration: const BoxDecoration(
      //         borderRadius: BorderRadius.vertical(
      //           bottom: Radius.circular(20),
      //         ),
      //         boxShadow: <BoxShadow>[
      //           BoxShadow(
      //             color: Colors.black54,
      //             blurRadius: 10.0,
      //             spreadRadius: -2.0,
      //             offset: Offset(0.0, 0.0),
      //           )
      //         ],
      //         color: Colors.white,
      //       ),
      //       child: Stack(
      //         alignment: Alignment.center,
      //         children: [
      //           const Text("찜한 목록 보기"),
      //           Positioned(
      //             left: 0,
      //             child: IconButton(
      //               onPressed: () {
      //                 setParentIndex(0);
      //               },
      //               icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Expanded(
      //       child: FutureBuilder(
      //         future: moca_api.Books.getLikedBooks(id: MocaUser.id),
      //         builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
      //           if (snapshot.hasData == false) {
      //             return const Center(child: CircularProgressIndicator());
      //           }
      //           List bookList = snapshot.data!["items"];

      //           return ListView.separated(
      //             physics: const BouncingScrollPhysics(),
      //             scrollDirection: Axis.vertical,
      //             padding: const EdgeInsets.symmetric(vertical: 25),
      //             itemBuilder: (BuildContext context, int index) {
      //               return BookWidget(
      //                 makeFrom: "favorites",
      //                 bookGroupData: bookList[index]["book_group"],
      //                 bookData: bookList[index]["book"],
      //                 state: bookList[index]["state"],
      //               );
      //             },
      //             separatorBuilder: (BuildContext context, int index) {
      //               return const Divider(height: 5);
      //             },
      //             itemCount: bookList.length,
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
