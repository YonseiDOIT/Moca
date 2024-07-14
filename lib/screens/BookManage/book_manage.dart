import 'package:app/screens/mypage/mypage.dart';
import 'package:flutter/material.dart';

// screens/widgets
import 'package:app/widgets/book.dart';
import 'package:app/screens/BookManage/book_add.dart';

// global variables
import 'package:app/globals.dart';
import 'package:app/globals.dart' as globals;

// API
import 'package:app/data/api_wrapper.dart' as moca_api;
import 'package:flutter/rendering.dart';

class BookManagePage extends StatefulWidget {
  const BookManagePage({
    super.key,
    required this.setParentIndex,
  });
  final Function(int index) setParentIndex;

  @override
  State<BookManagePage> createState() => _BookManagePageState();
}

class _BookManagePageState extends State<BookManagePage> {
  List<bool> isSelected = [true, false, false, false];
  List<String> textList = ["모두보기", "빌린 책", "빌려간 책", "보관중인 책"];
  int bookCount = 0;
  late ScrollController _controller;
  bool showBookAdd = true;

  String message = "";

  void _scrollListener() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      debugPrint("up!!");
      // setState(() {
      //   showBookAdd = true;
      // });
    }

    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      debugPrint("down!!");
      // setState(() {
      //   showBookAdd = false;
      // });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (globals.isLoggedIn) {
      return Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            Container(
              height: 80,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "책 관리 페이지",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Image.asset("assets/images/cat lying on books.png")
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      // height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleButtons(
                            direction: Axis.horizontal,
                            renderBorder: false,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                              });
                            },
                            isSelected: isSelected,
                            children: List.generate(
                              isSelected.length,
                              (index) {
                                return Container(
                                  clipBehavior: Clip.antiAlias,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                                    color: isSelected[index] ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(textList[index]),
                                );
                              },
                            ),
                          ),
                          Text("총 ${MocaUser.owned_books.length + MocaUser.borrowed_books.length}권")
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          FutureBuilder(
                            future: moca_api.Books.getUserBooks(id: MocaUser.id),
                            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                              if (snapshot.hasData == false) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              List bookList = snapshot.data!["items"];

                              return ListView.separated(
                                controller: _controller,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.only(top: 70, bottom: 12),
                                itemBuilder: (BuildContext context, int index) {
                                  if (isSelected[1]) {
                                    if (bookList[index]["state"] == "borrowed") {
                                      return BookWidget(
                                        makeFrom: "manage",
                                        bookGroupData: bookList[index]["book_group"],
                                        bookData: bookList[index]["book"],
                                        state: bookList[index]["state"],
                                      );
                                    }
                                  } else if (isSelected[2]) {
                                    if (bookList[index]["book"]["borrower"] != null) {
                                      return BookWidget(
                                        makeFrom: "manage",
                                        bookGroupData: bookList[index]["book_group"],
                                        bookData: bookList[index]["book"],
                                        state: bookList[index]["state"],
                                      );
                                    }
                                  } else if (isSelected[3]) {
                                    if (bookList[index]["book"]["borrower"] == null) {
                                      return BookWidget(
                                        makeFrom: "manage",
                                        bookGroupData: bookList[index]["book_group"],
                                        bookData: bookList[index]["book"],
                                        state: bookList[index]["state"],
                                      );
                                    }
                                  } else {
                                    return BookWidget(
                                      makeFrom: "manage",
                                      bookGroupData: bookList[index]["book_group"],
                                      bookData: bookList[index]["book"],
                                      state: bookList[index]["state"],
                                    );
                                  }
                                  return Container();
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  if (isSelected[1]) {
                                    if (bookList[index]["state"] == "borrowed") {
                                      return const Divider(height: 5);
                                    }
                                  } else if (isSelected[2]) {
                                    if (bookList[index]["book"]["borrower"] != null) {
                                      return const Divider(height: 5);
                                    }
                                  } else if (isSelected[3]) {
                                    if (bookList[index]["book"]["borrower"] == null) {
                                      return const Divider(height: 5);
                                    }
                                  } else {
                                    return const Divider(height: 5);
                                  }
                                  return Container();
                                },
                                itemCount: bookList.length,
                              );
                            },
                          ),
                          // add btn
                          AnimatedPositioned(
                            height: 65,
                            top: showBookAdd ? 0.0 : -65.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                            child: Container(
                              width: globals.ScreenSize.width,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFDF5).withOpacity(0.8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: globals.ScreenSize.width / 3.5,
                                vertical: 12,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 250),
                                      reverseTransitionDuration: const Duration(milliseconds: 250),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (context, animation, secondaryAnimation) => const BookAdd(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text('책 등록하기', style: Theme.of(context).textTheme.labelLarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10.0,
                  spreadRadius: -2.0,
                  offset: Offset(0.0, 0.0),
                )
              ],
            ),
            child: const Text("책 관리 페이지", style: TextStyle(fontSize: 20)),
          ),
          // filter options
          Container(
            padding: const EdgeInsets.all(10),
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  direction: Axis.horizontal,
                  renderBorder: false,
                  splashColor: Colors.transparent,
                  fillColor: Colors.white30,
                  onPressed: (int index) {},
                  isSelected: isSelected,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text("모두보기"),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text("빌린 책"),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text("빌려간 책"),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text("보관중인 책"),
                    ),
                  ],
                ),
                const Text("총 0권")
              ],
            ),
          ),
          // const Divider(height: 0, thickness: 2, indent: 10, endIndent: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("로그인이 필요합니다"),
                TextButton(
                  onPressed: () {
                    const MyPageScreen().showLoginPopup(context);
                    widget.setParentIndex(1);
                  },
                  child: const Text("로그인 하러 가기 >"),
                )
              ],
            ),
          )
        ],
      );
    }
  }
}
