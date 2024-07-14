// import 'package:flutter_test/flutter_test.dart';
import 'api_wrapper.dart' as moca_api;

void main() async {
  Map books = await moca_api.Books.getGroups(keyword: "일");
  print(books);
  print(books["items"]);
}
