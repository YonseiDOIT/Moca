// ignore_for_file: non_constant_identifier_names

library moca_api;

import 'dart:convert';
import 'dart:io';
import 'package:app/globals.dart' as globals;
import 'package:http/http.dart' as http;

Map<String, String> _headers = {
  'accept': 'application/json',
  'Content-Type': 'application/json',
  'Authorization': 'KakaoAK ${globals.kakaoRestApiKey}'
};

class Users {
  /// adds user to db
  ///
  /// [username], [nickname], [email], [image_url] are required to make a user
  /// for updating other data use "updateUser()" (e.g., [phone_number], [check_out_count])
  static Future<Map<String, dynamic>> addUser(
      {required String username, required String nickname, required String email, required String kakao_id, required String image_url}) async {
    Map<String, dynamic> body = {"username": username, "nickname": nickname, "email": email, "kakao_id": kakao_id, "image_url": image_url};

    var uri = Uri.https("api.0john-hong0.com", "/moca/users");
    var response = await http.post(uri, headers: _headers, body: jsonEncode(body));

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  static Future<Map<String, dynamic>> getUser({required String id}) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/users/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// gets user_history from the DB
  ///
  /// requires [id] of the user
  static Future<Map<String, dynamic>> getHistory({
    required String id,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/user_history/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  static Future<Map<String, dynamic>> updateUser({
    required String id,
    String? username,
    String? nickname,
    String? email,
    String? image_url,
    String? phone_number,
    int? check_out_count,
    int? overdue_count,
    int? purchase_count,
    int? damage_count,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/users/$id");
    var response = await http.put(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  static Future<Map<String, dynamic>> mocaCash(
    String id,
    int moca_cash,
    int time,
  ) async {
    Map<String, String> queryParameters = {"moca_cash": moca_cash.toString(), "time": time.toString()};

    var uri = Uri.https(
      "api.0john-hong0.com",
      "/moca/moca_cash/$id",
      queryParameters,
    );

    var response = await http.put(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    await globals.MocaUser.updateUser();
    return decodedResponse;
  }

  static Future<Map<String, dynamic>> deleteUser({required String id}) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/users/$id");
    var response = await http.delete(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }
}

class Books {
  /// gets bookGroups from the DB
  ///
  /// [sort] by "new_book.created_at" or "score".
  /// get books by [keyword]
  /// set [page] for getting the next page.
  /// set how much data to get in one [page] with [size].
  static Future<Map<String, dynamic>> getGroups({
    String sort = "new_book.created_at",
    String keyword = "",
    int page = 1,
    int size = 10,
  }) async {
    Map<String, String> queryParameters = {"sort": sort, "keyword": keyword, "page": page.toString(), "size": size.toString()};

    var uri = Uri.https("api.0john-hong0.com", "/moca/book_groups", queryParameters);
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// gets bookGroup from the DB
  ///
  /// requires [id] of the group to search
  static Future<Map<String, dynamic>> getGroup({
    required String id,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/book_groups/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// gets book from the DB
  ///
  /// requires [id] of the book to search
  static Future<Map<String, dynamic>> getBook({
    required String id,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/books/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// gets group books from the DB
  ///
  /// requires [id] of the group
  static Future<Map<String, dynamic>> getBooks({
    required String id,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/grouped_books/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// gets user book from the DB
  ///
  /// requires [id] of the user
  static Future<Map<String, dynamic>> getUserBooks({
    required String id,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/user_books/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// gets liked book from the DB
  ///
  /// requires [id] of the user
  static Future<Map<String, dynamic>> getLikedBooks({
    required String id,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/liked_books/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// adds a book to the DB
  ///
  /// requires [id] of owner, [title], [author], [publisher], [setPrice], [sell], [rent], [condition]
  static Future<Map<String, dynamic>> addBook({
    required String id,
    required String title,
    required String author,
    required String publisher,
    required int setPrice,
    required bool sell,
    required bool rent,
    required int condition,
  }) async {
    Map<String, dynamic> body = {
      "book_group": {
        "title": title,
        "author": author,
        "publisher": publisher,
      },
      "book": {
        "set_price": setPrice.toString(),
        "sell": sell.toString(),
        "rent": rent.toString(),
        "condition": condition.toString(),
      },
    };

    var uri = Uri.https("api.0john-hong0.com", "/moca/books/$id");
    var response = await http.post(uri, headers: _headers, body: jsonEncode(body));

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// buy/rent/return a book
  ///
  /// requires [transaction_type], [user_id] and [book_id]
  static Future<Map<String, dynamic>> updateBook({
    required String transaction_type,
    required String user_id,
    required String book_id,
    bool? sell,
    bool? rent,
    int? condition,
    int? set_price,
    String bookshelf = "null",
  }) async {
    Map<String, String> queryParameters;

    if (transaction_type == "manage") {
      queryParameters = {
        "user_id": user_id,
        "book_id": book_id,
        "sell": sell.toString(),
        "rent": rent.toString(),
        "condition": condition.toString(),
        "set_price": set_price.toString(),
      };
    } else if (transaction_type == "bookshelf") {
      queryParameters = {
        "user_id": user_id,
        "book_id": book_id,
        "bookshelf_id": bookshelf,
      };
    } else {
      queryParameters = {
        "user_id": user_id,
        "book_id": book_id,
      };
    }

    var uri = Uri.https("api.0john-hong0.com", "/moca/update_book/$transaction_type", queryParameters);
    var response = await http.put(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// deletes a book from the DB
  ///
  /// requires [id] of the book to delete
  static Future<Map<String, dynamic>> deleteBook(String id) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/books/$id");
    var response = await http.delete(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }
}

class Bookshelves {
  /// gets bookshelves from the DB
  ///
  /// get books by [keyword]
  /// set [page] for getting the next page.
  /// set how much data to get in one [page] with [size].
  static Future<Map<String, dynamic>> getBookshelves({
    required String address_name,
    required String longitude,
    required String latitude,
    int page = 1,
    int size = 10,
  }) async {
    Map<String, String> queryParameters = {
      "address_name": address_name,
      "longitude": longitude,
      "latitude": latitude,
      "page": page.toString(),
      "size": size.toString()
    };

    var uri = Uri.https("api.0john-hong0.com", "/moca/bookshelves", queryParameters);
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// gets bookshelf from the DB
  ///
  /// requires [id] of the bookshelf
  static Future<Map<String, dynamic>> getBookshelf({
    required String id,
  }) async {
    var uri = Uri.https("api.0john-hong0.com", "/moca/bookshelf/$id");
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return decodedResponse;
  }

  /// adds a bookshelf to the DB
  ///
  /// requires [id] of registrant, [name], [address_name], [image]
  static Future<Map<String, dynamic>> addBookshelf({
    required String id,
    required String name,
    required String address_name,
    required File image,
  }) async {
    Map coordResponse = await Location.addressToCoord(
      address: address_name,
    );

    List address_name_list = address_name.split(' ');
    Map<String, String> queryParameters = {
      "name": name,
      "address_name": address_name,
      "region_1depth_name": address_name_list[0],
      "region_2depth_name": address_name_list[1],
      "region_3depth_name": address_name_list[2],
      "longitude": coordResponse["documents"][0]["address"]["x"],
      "latitude": coordResponse["documents"][0]["address"]["y"],
    };

    var uri = Uri.https("api.0john-hong0.com", "/moca/bookshelves/$id", queryParameters);

    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.headers.addAll(_headers);
    // request.fields.addAll(body);

    var response = await http.Response.fromStream(await request.send());

    var decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}

class Location {
  /// coord to address
  ///
  /// [x] = 경도(longitude), [y] = 위도(latitude)
  static Future<Map<String, dynamic>> coordToAddress({
    required String x,
    required String y,
  }) async {
    Map<String, String> queryParameters = {"x": x, "y": y};

    var uri = Uri.https(
      "dapi.kakao.com",
      "/v2/local/geo/coord2address.json",
      queryParameters,
    );
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return decodedResponse;
  }

  /// address to coord
  ///
  /// [address] search
  static Future<Map<String, dynamic>> addressToCoord({
    required String address,
  }) async {
    Map<String, String> queryParameters = {"query": address};

    var uri = Uri.https(
      "dapi.kakao.com",
      "/v2/local/search/address.json",
      queryParameters,
    );
    var response = await http.get(uri, headers: _headers);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return decodedResponse;
  }
}
