// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/models/friend.dart';
import 'package:flutter_application/services/friend_service.dart';
import 'package:flutter_application/widgets/shared.dart';

class FriendsDrawer extends StatefulWidget {
  const FriendsDrawer({super.key});

  @override
  State<FriendsDrawer> createState() => _FriendsDrawerState();
}

class _FriendsDrawerState extends State<FriendsDrawer> {
  late Future<List<Friend>> _friendsFuture;
  final FriendService _friendService = FriendService();
  List<Friend> searchResults = [];
  List<Friend> friendRequests = [];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _friendsFuture = _friendService.getFriends(currentUserId!);
    _loadFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Friend>>(
      future: _friendsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final friends = snapshot.data ?? [];

        return _buildLeftDrawer(friends);
      },
    );
  }

  Future<void> _loadFriendRequests() async {
    try {
      if (currentUserId != null) {
        final friendService = FriendService();
        final requests =
            await friendService.getPendingFriendRequests(currentUserId!);

        if (!mounted) return;

        setState(() {
          friendRequests = requests;
        });
      }
    } catch (e) {
      debugPrint('Error loading friend requests');
    }
  }

  Widget _buildLeftDrawer(List<Friend> friends) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Friends',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search or add friend...',
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (query) async {
                if (query.isNotEmpty) {
                  await _searchUsers(query);
                }
              },
            ),
          ),
          if (searchResults.isNotEmpty)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: searchResults
                    .map((friend) => _buildSearchResultItem(friend, friends))
                    .toList(),
              ),
            ),
          if (searchResults.isEmpty)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  const SizedBox(height: 5),
                  if (friendRequests.isNotEmpty)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              const Text(
                                'Friend Requests',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              showCount(friendRequests.length)
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: friendRequests.length,
                          itemBuilder: (context, index) {
                            return _buildFriendRequestItem(
                                friendRequests[index]);
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Text(
                          'All Friends',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        showCount(friends.length),
                      ],
                    ),
                  ),
                  if (friends.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            return _buildFriendItem(friends[index]);
                          },
                        ),
                      ],
                    )
                  else
                    _buildEmptyState('Start adding friends!'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFriendItem(Friend friend) {
    return ListTile(
      minTileHeight: 0,
      dense: true,
      contentPadding: const EdgeInsets.only(left: 12, right: 6, top: 6),
      leading: AvatarImage(avatarUrl: friend.avatarUrl, avatarRadius: 20),
      title: Text(
        friend.fullName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        friend.userName,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),
      trailing: PopupMenuButton(
        icon: const Icon(Icons.more_vert, color: Colors.white54),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text('Remove Friend'),
            onTap: () => _removeFriend(friend.userId),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(Friend friend, List<Friend> friends) {
    final isFriend = friends.any((f) => f.userId == friend.userId);

    if (currentUserId == null) return const Column();

    return FutureBuilder<bool>(
      future:
          _friendService.isFriendRequestPending(currentUserId!, friend.userId),
      builder: (context, snapshot) {
        final isRequested = snapshot.data ?? false;

        return ListTile(
          minTileHeight: 0,
          dense: true,
          contentPadding: const EdgeInsets.only(left: 12, right: 6),
          leading: AvatarImage(avatarUrl: friend.avatarUrl, avatarRadius: 20),
          title: Text(
            friend.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            friend.userName,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          trailing: isFriend
              ? PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white54),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Remove Friend'),
                      onTap: () => _removeFriend(friend.userId),
                    ),
                  ],
                )
              : isRequested
                  ? const Text(
                      'Requested',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    )
                  : IconButton(
                      icon: const Icon(Icons.person_add, color: Colors.white54),
                      onPressed: () => _sendFriendRequest(friend.userId),
                    ),
        );
      },
    );
  }

  Widget _buildFriendRequestItem(Friend request) {
    return ListTile(
      minTileHeight: 0,
      dense: true,
      contentPadding: const EdgeInsets.only(left: 12, right: 6, top: 4),
      leading: AvatarImage(avatarUrl: request.avatarUrl, avatarRadius: 20),
      title: Text(
        request.fullName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        request.userName,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () => _acceptFriendRequest(request.userId),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => _declineFriendRequest(request.userId),
          ),
        ],
      ),
    );
  }

  Container showCount(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _searchUsers(String query) async {
    final result = await _friendService.searchUsers(query);

    if (result['error'] != null) {
      floatingSnackBar(
        message: result['error'],
        context: context,
      );
    } else if (mounted) {
      setState(() {
        searchResults = result['friends'];
      });
    }
  }

  Future<void> _sendFriendRequest(String receiverId) async {
    final result = await _friendService.sendFriendRequest(receiverId);

    if (!result['success']) {
      floatingSnackBar(
        message: result['error'],
        context: context,
      );
      return;
    }

    if (!mounted) return;
    // Update the UI state here to reflect the "Requested" state
    setState(
        () {}); // This will re-trigger the build method and update the trailing widget.
  }

  Future<void> _acceptFriendRequest(String senderId) async {
    final result = await _friendService.acceptFriendRequest(senderId);

    if (!result['success']) {
      floatingSnackBar(
        message: result['error'],
        context: context,
      );
      return;
    }
    if (!mounted) return;
    floatingSnackBar(
      message: 'Friend request accepted!',
      context: context,
    );

    // Refresh the friends list
    setState(() {
      friendRequests.removeWhere((request) => request.userId == senderId);
      _friendsFuture = _friendService.getFriends(currentUserId!);
    });
  }

  Future<void> _declineFriendRequest(String senderId) async {
    final result = await _friendService.declineFriendRequest(senderId);

    if (!result['success']) {
      floatingSnackBar(
        message: result['error'],
        context: context,
      );
    } else if (mounted) {
      // Remove from the local list
      setState(() {
        friendRequests.removeWhere((request) => request.userId == senderId);
      });
    }
  }

  Future<void> _removeFriend(String friendId) async {
    final result = await _friendService.removeFriend(friendId);

    if (!result['success']) {
      floatingSnackBar(
        message: result['error'],
        context: context,
      );
      return;
    }

    if (!mounted) return;
    // Refresh the friends list
    setState(() {
      _friendsFuture = _friendService.getFriends(currentUserId!);
    });
  }

  Widget _buildEmptyState(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }
}
