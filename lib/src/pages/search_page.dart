import 'package:chat_app/src/models/user.dart';
import 'package:chat_app/src/pages/chatscreens/chat_screen.dart';
import 'package:chat_app/src/services/firebase_repository.dart';
import 'package:chat_app/src/styles/colors.dart';
import 'package:chat_app/src/styles/font_styles.dart';
import 'package:chat_app/src/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _repository.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: searchAppBar(context),
      body: buildSuggestions(query),
    );
  }

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [gradientColorStart, gradientColorEnd],
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context)),
      elevation: 0,
      bottom: PreferredSize(
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            cursorColor: blackColor,
            autofocus: true,
            style: searchStyle,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  searchController.clear();
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: searchStyle.copyWith(
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchUsername = _getUsername.contains(_query);
            bool matchName = _getName.contains(_query);
            return (matchUsername || matchName);
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        User searchedUser = suggestionList[index];
        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(receiver: searchedUser),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: suggestionTitleStyle,
          ),
          subTitle: Text(
            searchedUser.name,
            style: suggestionSubtitleStyle,
          ),
        );
      },
    );
  }
}
