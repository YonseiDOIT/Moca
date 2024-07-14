import 'package:app/main.dart';
import 'package:flutter/material.dart';

// global variables
import 'package:app/globals.dart' as globals;

// api
import 'package:app/data/api_wrapper.dart' as moca_api;

class BookAdd extends StatefulWidget {
  const BookAdd({super.key});

  @override
  State<BookAdd> createState() => _BookAddState();
}

class _BookAddState extends State<BookAdd> {
  Map<String, dynamic> bookData = {
    "title": "",
    "author": "",
    "publisher": "",
    "new_price": "",
  };

  bool enableInput = false;
  List<String> conditionList = ["최상", "상", "중", "하"];
  String condition = "최상";
  int price = 0;

  void setBookData(Map<String, dynamic> book) {
    setState(() {
      bookData = book;
      enableInput = true;
    });
  }

  void setBookText(String type, dynamic value) {
    setState(() {
      bookData[type] = value;
    });
  }

  void setPrice(int setPrice) {
    setState(() {
      price = setPrice;
    });
  }

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
                      "책 관리 페이지 > 책 등록하기",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: globals.ScreenSize.height,
                      child: Column(
                        children: [
                          SearchBook(
                            text: "제목",
                            enabled: true,
                            setBookData: setBookData,
                          ),
                          TextInput(
                            text: "지은이",
                            enabled: enableInput,
                            bookData: bookData,
                            type: "author",
                            setPrice: setPrice,
                            setBookText: setBookText,
                          ),
                          TextInput(
                            text: "출판사",
                            enabled: enableInput,
                            bookData: bookData,
                            type: "publisher",
                            setPrice: setPrice,
                            setBookText: setBookText,
                          ),
                          Row(
                            children: [
                              TextInput(
                                text: "판매가",
                                enabled: true,
                                bookData: bookData,
                                type: "new_price",
                                setPrice: setPrice,
                                setBookText: setBookText,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text('상태'),
                              ),
                              Container(
                                // decoration:
                                //     BoxDecoration(border: Border.all(color: Colors.black)),
                                width: globals.ScreenSize.width / 5,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: condition,
                                  items: conditionList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      condition = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              await moca_api.Books.addBook(
                                id: globals.MocaUser.id,
                                title: bookData["title"].toString(),
                                author: bookData["author"].toString(),
                                publisher: bookData["publisher"].toString(),
                                setPrice: 0,
                                sell: true,
                                rent: true,
                                condition: 0,
                              );
                            },
                            child: Container(
                              width: globals.ScreenSize.width,
                              height: 50,
                              margin: const EdgeInsets.symmetric(vertical: 25),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.black),
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text("책 등록하기"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // body: SingleChildScrollView(
        //   physics: const BouncingScrollPhysics(),
        //   child: SizedBox(
        //     height: globals.ScreenSize.height,
        //     child: Stack(
        //       children: [
        //         Positioned(
        //           child: Container(
        //             margin: const EdgeInsets.only(top: 75),
        //             padding: const EdgeInsets.symmetric(horizontal: 30),
        //             child: Column(
        //               children: [
        //                 SearchBook(
        //                   text: "제목",
        //                   enabled: true,
        //                   setBookData: setBookData,
        //                 ),
        //                 TextInput(
        //                   text: "지은이",
        //                   enabled: enableInput,
        //                   bookData: bookData,
        //                   type: "author",
        //                   setPrice: setPrice,
        //                   setBookText: setBookText,
        //                 ),
        //                 TextInput(
        //                   text: "출판사",
        //                   enabled: enableInput,
        //                   bookData: bookData,
        //                   type: "publisher",
        //                   setPrice: setPrice,
        //                   setBookText: setBookText,
        //                 ),
        //                 Row(
        //                   children: [
        //                     TextInput(
        //                       text: "판매가",
        //                       enabled: true,
        //                       bookData: bookData,
        //                       type: "new_price",
        //                       setPrice: setPrice,
        //                       setBookText: setBookText,
        //                     ),
        //                     const Padding(
        //                       padding: EdgeInsets.symmetric(horizontal: 10),
        //                       child: Text('상태'),
        //                     ),
        //                     Container(
        //                       // decoration:
        //                       //     BoxDecoration(border: Border.all(color: Colors.black)),
        //                       width: globals.ScreenSize.width / 5,
        //                       padding: const EdgeInsets.symmetric(vertical: 10),
        //                       child: DropdownButton(
        //                         isExpanded: true,
        //                         value: condition,
        //                         items: conditionList.map<DropdownMenuItem<String>>((String value) {
        //                           return DropdownMenuItem(
        //                             value: value,
        //                             child: Text(value),
        //                           );
        //                         }).toList(),
        //                         onChanged: (String? value) {
        //                           setState(() {
        //                             condition = value!;
        //                           });
        //                         },
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 GestureDetector(
        //                   onTap: () async {
        //                     Map response = await moca_api.Books.addBook(
        //                       id: globals.MocaUser.id,
        //                       title: bookData["title"].toString(),
        //                       author: bookData["author"].toString(),
        //                       publisher: bookData["publisher"].toString(),
        //                       setPrice: 0,
        //                       sell: true,
        //                       rent: true,
        //                       condition: 0,
        //                     );
        //                   },
        //                   child: Container(
        //                     width: globals.ScreenSize.width,
        //                     height: 50,
        //                     margin: const EdgeInsets.symmetric(vertical: 25),
        //                     alignment: Alignment.center,
        //                     decoration: BoxDecoration(
        //                       // border: Border.all(color: Colors.black),
        //                       color: Colors.grey[400],
        //                       borderRadius: BorderRadius.circular(20),
        //                     ),
        //                     child: const Text("책 등록하기"),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //         Positioned(
        //           height: 500,
        //           top: -1 * (500 - 75),
        //           width: globals.ScreenSize.width,
        //           child: Container(
        //             height: 500,
        //             alignment: Alignment.bottomCenter,
        //             padding: const EdgeInsets.symmetric(vertical: 25),
        //             decoration: const BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.only(
        //                 bottomRight: Radius.circular(30.0),
        //                 bottomLeft: Radius.circular(30.0),
        //               ),
        //               boxShadow: <BoxShadow>[
        //                 BoxShadow(
        //                   color: Colors.black54,
        //                   blurRadius: 10.0,
        //                   spreadRadius: -2.0,
        //                   offset: Offset(0.0, 0.0),
        //                 )
        //               ],
        //             ),
        //             child: const Text("책 등록하기", style: TextStyle(fontSize: 20)),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

class SearchBook extends StatefulWidget {
  final String text;
  final bool enabled;
  final Function(Map<String, dynamic> book) setBookData;
  final bool addImage = true;

  const SearchBook({
    super.key,
    required this.text,
    required this.enabled,
    required this.setBookData,
  });

  @override
  State<SearchBook> createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> {
  late InputDecoration textFieldDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 0,
    ),
    // fillColor: enabled ? Colors.grey[200] : Colors.white,
    fillColor: widget.enabled ? Colors.white : Colors.grey[300],
    filled: true,
    enabled: widget.enabled,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    hintText: "제목을 입력해주세요.",
  );

  late List<String> _lastOptions;
  String? _searchBook;

  late List _books;
  late Map<String, dynamic> _selectedBook;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(widget.text),
          ),
          Container(
            width: globals.ScreenSize.width / 1.5,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textValue) async {
                _searchBook = textValue.text;

                if (_searchBook == "") {
                  return const Iterable<String>.empty();
                }

                final Map<String, dynamic> response = await moca_api.Books.getGroups(keyword: _searchBook!);

                // If another search happened after this one, throw away these options.
                // Use the previous options intead and wait for the newer request to
                // finish.
                if (_searchBook != textValue.text) {
                  return _lastOptions;
                }

                if (response["total"] > 0) {
                  _books = response["items"];
                  List<String> _temp = [];
                  for (Map book in _books) {
                    _temp.add(book["title"]);
                  }
                  _lastOptions = _temp;
                  return _temp;
                } else {
                  return [""];
                  // return const Iterable<String>.empty();
                }
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 10,
                    child: SizedBox(
                      width: globals.ScreenSize.width / 1.5,
                      height: globals.ScreenSize.bottomPadding,
                      child: ListView.separated(
                        controller: ScrollController(),
                        physics: const BouncingScrollPhysics(),
                        // shrinkWrap: true,/
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);

                          if (option.isNotEmpty) {
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                                _selectedBook = _books.elementAt(index);
                                widget.setBookData(_selectedBook);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                height: 70,
                                width: globals.ScreenSize.width / 1.5,
                                child: Row(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 6 / 9,
                                      child: Image.network(
                                        _books.elementAt(index)["image_url"],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                text: option.toString(),
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            ),
                                            RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                text: "${_books.elementAt(index)["author"]} - ${_books.elementAt(index)["publisher"]}",
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text("새 책 추가하기"),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 10,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                return TextField(
                  controller: controller,
                  decoration: textFieldDecoration,
                  focusNode: focusNode,
                  onEditingComplete: onSubmit,
                  autofocus: true,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  final String text;
  final bool enabled;
  final Map<String, dynamic> bookData;
  final Function(String type, dynamic value) setBookText;

  final String type;

  final Function(int setPrice) setPrice;

  TextInput({
    super.key,
    required this.text,
    required this.enabled,
    required this.bookData,
    required this.type,
    required this.setPrice,
    required this.setBookText,
  });

  late InputDecoration textFieldDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 0,
    ),
    // fillColor: enabled ? Colors.grey[200] : Colors.white,
    fillColor: enabled ? Colors.white : Colors.grey[300],
    filled: true,
    enabled: enabled,

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),

    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (text != "판매가") {
      return SizedBox(
        height: 60,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Text(text),
            ),
            Container(
              width: globals.ScreenSize.width / 1.5,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: textFieldDecoration,
                controller: TextEditingController(text: bookData[type].toString()),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  setBookText(type, value);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 60,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Text(text),
            ),
            Container(
              width: globals.ScreenSize.width / 3,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: textFieldDecoration,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setPrice(value as int);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
