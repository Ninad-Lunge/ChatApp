import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../Components/my_drawer.dart';
import '../components/user_tile.dart';
import '../services/chat/chat_service.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Home",),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: buildUserList(),
    );
  }

  Widget buildUserList() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text("Error");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.map<Widget>((userData) => buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }

  Widget buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if(userData['email'] != authService.getCurrentUser()!.email){
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData['email'],
                  receiverID: userData['uid'],
                ),
              ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
