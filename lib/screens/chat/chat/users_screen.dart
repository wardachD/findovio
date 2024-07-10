import 'package:findovio/screens/chat/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  FirebaseApp findoviobizFirebase = Firebase.app('findoviobiz');
  String _searchQuery = '';
  List<types.User> _searchResults = [];

  void _startChat(types.User otherUser) async {
    final User? user = FirebaseAuth.instance.currentUser;
    FirebaseChatCoreConfig config =
        FirebaseChatCoreConfig('findoviobiz', 'rooms', 'users');
    FirebaseChatCore.instance.setConfig(config);

    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(room: room),
      ),
    );
  }

  Future<void> _searchUsers(String query) async {
    final FirebaseFirestore _firestore =
        FirebaseFirestore.instanceFor(app: findoviobizFirebase);

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Normalizujemy zapytanie, aby wyszukiwanie było case-insensitive
    final searchKey = query.toLowerCase();

    // Tworzymy zakresy wyszukiwania dla pierwszego i ostatniego możliwego znaku
    final startKey = searchKey;
    final endKey = '$searchKey\uf8ff';

    final userQuery = await _firestore
        .collection('users')
        .where('firstName', isGreaterThanOrEqualTo: startKey)
        .where('firstName', isLessThanOrEqualTo: endKey)
        .get();

    final emailQuery = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: startKey)
        .where('email', isLessThanOrEqualTo: endKey)
        .get();

    final users = userQuery.docs
        .map((doc) {
          final userData = doc.data();
          var userRole =
              userData['role'] == 'agent' ? types.Role.agent : types.Role.user;
          return types.User(
            id: doc.id,
            firstName: userData['firstName'],
            imageUrl: userData['imageUrl'],
            email: userData['email'],
            role: userRole,
          );
        })
        .toList()
        .cast<types.User>();

    final emailUsers = emailQuery.docs
        .map((doc) {
          final userData = doc.data();
          var userRole =
              userData['role'] == 'agent' ? types.Role.agent : types.Role.user;
          return types.User(
            id: doc.id,
            firstName: userData['firstName'],
            imageUrl: userData['imageUrl'],
            email: userData['email'],
            role: userRole,
          );
        })
        .toList()
        .cast<types.User>();

    setState(() {
      _searchResults = [...users, ...emailUsers]
          .where((element) => element.role == types.Role.agent)
          .toSet()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_outlined)),
                const Text(
                  'Szukaj użytkownika',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 228, 228, 228),
              height: 6,
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _searchUsers(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email lub nazwa',
                        labelText: 'Wyszukaj',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 180, 180, 180)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 180, 180, 180)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 180, 180, 180)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 26,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 226, 226, 226))),
                    color: const Color.fromARGB(255, 53, 53, 53),
                    onPressed: () async {
                      _searchUsers(_searchQuery);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            AnimatedSwitcher(
              key: UniqueKey(),
              duration: Duration(milliseconds: 300),
              child: _searchQuery == ''
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 64.0, vertical: 26),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/glassessearch.png',
                                height: 60,
                              ),
                              const SizedBox(height: 22),
                              const Text(
                                textAlign: TextAlign.center,
                                'Szukaj po nazwie lub email',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Szukając po nazwie użytkownika możesz natrafić na te same wyniki, dlatego najlepiej używać adresu email.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 236, 236, 236),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      width: 48,
                      height: 48,
                      child: user.imageUrl != null
                          ? Image.network(user.imageUrl!)
                          : const Icon(Icons.home_outlined),
                    ),
                    title: Text(user.firstName ?? 'Brak nazwy'),
                    trailing: IconButton(
                        onPressed: () => _startChat(user),
                        icon: Icon(Icons.navigate_next_rounded)),
                    subtitle: Text(user.email ?? 'Brak adresu email'),
                    onTap: () => _startChat(user),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
