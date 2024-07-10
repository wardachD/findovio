import 'package:findovio/screens/chat/chat/users_screen.dart';
import 'package:findovio/widgets/title_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _auth = FirebaseAuth.instance;
  User? _currentUser;
  bool _showAllMessages = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Stream<List<types.Room>> _getRooms() {
    return FirebaseChatCore.instance.rooms();
  }

  Future<String> _getLastMessage(types.Room room) async {
    final messagesQuery = await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (messagesQuery.docs.isNotEmpty) {
      final data = messagesQuery.docs.first.data();
      return data['text'] as String;
    }

    return 'No messages yet';
  }

  Future<DateTime?> _getLastMessageDate(types.Room room) async {
    final messagesQuery = await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (messagesQuery.docs.isNotEmpty) {
      final data = messagesQuery.docs.first.data();
      final timestamp = data['createdAt'] as Timestamp;
      return timestamp.toDate();
    }

    return null;
  }

  Future<bool> _isLastMessageUnread(types.Room room) async {
    final messagesQuery = await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (messagesQuery.docs.isNotEmpty) {
      final data = messagesQuery.docs.first.data();
      return data['status'] != 'seen' && data['authorId'] != _currentUser?.uid;
    }

    return false;
  }

  void _toggleShowAllMessages() {
    setState(() {
      _showAllMessages = true;
    });
  }

  void _toggleShowUnreadMessages() {
    setState(() {
      _showAllMessages = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseChatCoreConfig config =
        FirebaseChatCoreConfig('findoviobiz', 'rooms', 'users');
    FirebaseChatCore.instance.setConfig(config);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Stack(children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  clipBehavior: Clip.none,
                  width: MediaQuery.sizeOf(context).width * 0.2,
                  height: 13, // Adjust the height of the line as needed
                  color: Colors.orange,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleBar(text: "wiadomości"),
                    Icon(Icons.message_sharp),
                  ],
                ),
              ]),
            ),
            const Divider(
              color: Color.fromARGB(255, 228, 228, 228),
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    key: UniqueKey(),
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: _showAllMessages
                            ? Color.fromARGB(255, 252, 200, 122)
                            : Color.fromARGB(255, 245, 245, 245),
                        borderRadius: BorderRadius.circular(6)),
                    child: GestureDetector(
                        onTap: _toggleShowAllMessages,
                        child: Text('Wszystkie')),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  AnimatedContainer(
                    key: UniqueKey(),
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: !_showAllMessages
                            ? Color.fromARGB(255, 252, 200, 122)
                            : Color.fromARGB(255, 245, 245, 245),
                        borderRadius: BorderRadius.circular(6)),
                    child: GestureDetector(
                        onTap: _toggleShowUnreadMessages,
                        child: Text('Nieprzeczytane')),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<types.Room>>(
                stream: _getRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(
                            width: 240,
                            height: 6,
                            child: const LinearProgressIndicator()));
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.6,
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 26,
                              ),
                              Text('Brak wiadomości...')
                            ],
                          )),
                    );
                  }

                  final rooms = snapshot.data!;

                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];

                      return FutureBuilder<bool>(
                        future: _isLastMessageUnread(room),
                        builder: (context, unreadSnapshot) {
                          if (unreadSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }

                          if (!_showAllMessages &&
                              !(unreadSnapshot.data ?? false)) {
                            return Container();
                          }

                          return FutureBuilder<String>(
                            future: _getLastMessage(room),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LinearProgressIndicator();
                              }
                              final lastMessage =
                                  snapshot.data ?? 'No messages yet';

                              return FutureBuilder<DateTime?>(
                                future: _getLastMessageDate(room),
                                builder: (context, dateSnapshot) {
                                  final lastMessageDate = dateSnapshot.data;
                                  final formattedDate = lastMessageDate != null
                                      ? DateFormat('dd.MM, HH:mm')
                                          .format(lastMessageDate)
                                      : '';

                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 236, 236, 236),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          width: 48,
                                          height: 48,
                                          child: room.imageUrl != null
                                              ? Image.network(room.imageUrl!)
                                              : const Icon(Icons.home_outlined),
                                        ),
                                        title: Text(
                                          room.name ?? 'Chat',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        trailing: Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        subtitle: Text(
                                          lastMessage,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 71, 71, 71)),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatScreen(room: room),
                                            ),
                                          );
                                        },
                                      ),
                                      const Divider(
                                        color:
                                            Color.fromARGB(255, 228, 228, 228),
                                      ), // Dodaje linię horyzontalną między elementami listy
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // Dodajemy nową sekcję poniżej listy wiadomości
            Container(
              width: MediaQuery.sizeOf(context).width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/messages.png', // Tutaj ustaw URL swojego obrazka
                      height: 100,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nowy kontakt?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Wciśnij przycisk plusa u dołu ekranu by dodać użytkownika używając jego adres email.',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserSearchScreen(), // Tutaj ustaw ekran dodawania użytkownika
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 189, 104),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
