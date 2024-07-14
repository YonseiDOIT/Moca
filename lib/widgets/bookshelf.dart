import 'package:app/main.dart';
import 'package:app/widgets/book.dart';
import 'package:flutter/material.dart';
// API
import 'package:app/data/api_wrapper.dart' as moca_api;

// global variables
import 'package:app/globals.dart';
import 'package:app/globals.dart' as globals;

// double containerHeight = 150;

class BookshelfWidget extends StatelessWidget {
  final Map bookshelfData;

  const BookshelfWidget({
    super.key,
    required this.bookshelfData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
            pageBuilder: (context, animation, secondaryAnimation) => BookshelfDetail(
              bookshelfData: bookshelfData,
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: [
            Hero(
              tag: bookshelfData["_id"],
              child: AspectRatio(
                aspectRatio: 6 / 9,
                child: Image.network(
                  bookshelfData["image"],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${bookshelfData["name"]}",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      "${bookshelfData["distance"].toStringAsFixed(2)}m",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${bookshelfData["address_name"]}",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookshelfDetail extends StatefulWidget {
  final Map bookshelfData;

  const BookshelfDetail({
    super.key,
    required this.bookshelfData,
  });

  @override
  State<BookshelfDetail> createState() => _BookshelfDetailState();
}

class _BookshelfDetailState extends State<BookshelfDetail> {
  bool showBar = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
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
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Text(
                      "책장 목록 > ${widget.bookshelfData["name"]}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "${widget.bookshelfData["_id"]}",
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: Image.network(
                              widget.bookshelfData["image"],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          widget.bookshelfData["name"],
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          "${widget.bookshelfData["distance"].toStringAsFixed(2)}m",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "${widget.bookshelfData["address_name"]}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "등록된 중고책 모두 보기",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Divider(thickness: 2),
                        FutureBuilder(
                          future: moca_api.Bookshelves.getBookshelf(
                            id: widget.bookshelfData["_id"],
                          ),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData == false) {
                              return Container();
                            }
                            Map bookshelfData = snapshot.data!;
                            print(bookshelfData["name"]);

                            return Column(
                              children: [
                                for (Map book in bookshelfData["stored_books"])
                                  Column(
                                    children: [
                                      BookWidget(
                                        makeFrom: "bookshelf",
                                        bookGroupData: book["group_data"],
                                        bookData: book,
                                        bookshelfData: bookshelfData,
                                      ),
                                      const Divider(height: 0, thickness: 1.5),
                                    ],
                                  ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 64,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          // child: Text("asdf"),
                                          child: FutureBuilder(
                                            future: moca_api.Books.getUserBooks(id: MocaUser.id),
                                            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                                              if (snapshot.hasData == false) {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                              List bookList = snapshot.data!["items"];

                                              final List<GlobalObjectKey<BookWidgetState>> formKeyList =
                                                  List.generate(bookList.length, (index) => GlobalObjectKey<BookWidgetState>(index));

                                              List<bool> bookLength = [];

                                              for (int index = 0; index < bookList.length; index++) {
                                                bookLength.add(bookList[index]["book"]["owner"]["_id"] == MocaUser.id);
                                              }

                                              return Scaffold(
                                                body: Stack(
                                                  children: [
                                                    ListView.separated(
                                                      physics: const BouncingScrollPhysics(),
                                                      scrollDirection: Axis.vertical,
                                                      padding: const EdgeInsets.only(
                                                        top: 65,
                                                      ),
                                                      itemBuilder: (BuildContext context, int index) {
                                                        if (bookLength[index]) {
                                                          return BookWidget(
                                                            key: formKeyList[index],
                                                            makeFrom: "bookshelf_add",
                                                            bookGroupData: bookList[index]["book_group"],
                                                            bookData: bookList[index]["book"],
                                                            bookshelfData: bookshelfData,
                                                          );
                                                        }
                                                        return null;
                                                      },
                                                      separatorBuilder: (BuildContext context, int index) {
                                                        return const Divider(height: 5);
                                                      },
                                                      itemCount: bookList.length,
                                                    ),
                                                    AnimatedPositioned(
                                                      height: 65,
                                                      width: globals.ScreenSize.width - 64,
                                                      top: showBar ? 0 : -65,
                                                      duration: const Duration(milliseconds: 200),
                                                      curve: Curves.fastOutSlowIn,
                                                      child: Container(
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white70,
                                                        ),
                                                        padding: const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  color: Colors.grey[300],
                                                                ),
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 24,
                                                                ),
                                                                child: const Text('취소'),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                for (int bookIndex = 0; bookIndex < bookLength.length; bookIndex++) {
                                                                  if (bookLength[bookIndex]) {
                                                                    formKeyList[bookIndex].currentState?.saveBookshelf();
                                                                  }
                                                                }

                                                                Navigator.pop(context);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  color: Colors.grey[300],
                                                                ),
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 24,
                                                                ),
                                                                child: const Text('확인'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    child: const Text("이 책장에 내 책 놓기"),
                                  ),
                                ),
                                const Divider(height: 0, thickness: 1.5),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
