// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/colors.dart';
import 'package:flutter_application/models/friend.dart';
import 'package:flutter_application/services/friend_service.dart';
import 'package:flutter_application/widgets/shared.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/providers/user_provider.dart';
import 'package:flutter_application/pages/other_profile.dart';

class FriendsDrawer extends StatefulWidget {
  const FriendsDrawer({super.key});

  @override
  State<FriendsDrawer> createState() => _FriendsDrawerState();
}

class _FriendsDrawerState extends State<FriendsDrawer> {
  final FriendService _friendService = FriendService();
  List<Friend> searchResults = [];
  List<Friend> friendRequests = [];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _initializeFriends();
  }

  void _initializeFriends() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.friends.isEmpty) {
      userProvider.fetchFriendsList();
    }
    if (userProvider.friendRequests.isEmpty) {
      userProvider.fetchFriendRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final friends = userProvider.friends;
        final requests = userProvider.friendRequests;

        // Update the local friendRequests list with data from provider
        friendRequests = List.from(requests);

        return Container(
          decoration: const BoxDecoration(color: drawerColor),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                Expanded(
                  child: _buildContent(friends),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ),
          if (friendRequests.isNotEmpty) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue[200],
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${friendRequests.length} new',
                    style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black45,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.085),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search or add friend...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon:
                  Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onChanged: (query) {
              if (query.isEmpty) {
                setState(() {
                  searchResults = [];
                });
              } else if (query.length >= 2) {
                _searchUsers(query);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<Friend> friends) {
    if (searchResults.isNotEmpty) {
      return _buildSearchResults(friends);
    }
    return _buildFriendsList(friends);
  }

  Widget _buildSearchResults(List<Friend> friends) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildUserCard(searchResults[index], friends),
        );
      },
    );
  }

  Widget _buildFriendsList(List<Friend> friends) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (friendRequests.isNotEmpty) ...[
          _buildSectionHeader('Friend Requests', friendRequests.length,
              isRequest: true),
          const SizedBox(height: 12),
          ...friendRequests.map((request) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildRequestCard(request),
              )),
          const Divider(color: Colors.white24, height: 32),
        ],
        _buildSectionHeader('All Friends', friends.length),
        const SizedBox(height: 12),
        if (friends.isNotEmpty)
          ...friends.map((friend) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildFriendCard(friend),
              ))
        else
          _buildEmptyState('Start adding friends!'),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count,
      {bool isRequest = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isRequest ? Colors.blue[200] : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isRequest
                ? Colors.blue.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: isRequest ? Colors.blue[100] : Colors.white54,
              fontSize: 12,
            ),
          ),
        ),
        if (isRequest && count > 0)
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserCard(Friend friend, List<Friend> friends) {
    final isFriend = friends.any((f) => f.userId == friend.userId);

    return Card(
      elevation: 8,
      shadowColor: Colors.black45,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.085),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: FutureBuilder<bool>(
          future: _friendService.isFriendRequestPending(
              currentUserId!, friend.userId),
          builder: (context, snapshot) {
            final isRequested = snapshot.data ?? false;

            return ListTile(
              leading: AvatarImage(
                avatarUrl: friend.avatarUrl,
                avatarRadius: 20,
              ),
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
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              trailing:
                  _buildUserCardTrailing(friend.userId, isFriend, isRequested),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserCardTrailing(
      String userId, bool isFriend, bool isRequested) {
    if (isFriend) {
      return PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.5)),
        color: Colors.grey[900],
        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text('Remove Friend',
                style: TextStyle(color: Colors.white)),
            onTap: () => _removeFriend(userId),
          ),
        ],
      );
    } else if (isRequested) {
      return Text(
        'Requested',
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12,
        ),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.person_add, color: Colors.white.withOpacity(0.5)),
        onPressed: () => _sendFriendRequest(userId),
      );
    }
  }

  Widget _buildRequestCard(Friend request) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black45,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _navigateToUserProfile(request),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.blue.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Stack(
                  children: [
                    AvatarImage(
                      avatarUrl: request.avatarUrl,
                      avatarRadius: 20,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: drawerColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  request.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.userName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Wants to be your friend',
                      style: TextStyle(
                        color: Colors.blue[200],
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Just now', // You can replace this with actual timestamp
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: 'Accept',
                        icon: Icons.check,
                        color: Colors.green,
                        onTap: () => _acceptFriendRequest(request.userId),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActionButton(
                        label: 'Decline',
                        icon: Icons.close,
                        color: Colors.red,
                        onTap: () => _declineFriendRequest(request.userId),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(Friend friend) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black45,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _navigateToUserProfile(friend),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.085),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: AvatarImage(
              avatarUrl: friend.avatarUrl,
              avatarRadius: 20,
            ),
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
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.5)),
              color: Colors.grey[900],
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('View Profile',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => _navigateToUserProfile(friend),
                ),
                PopupMenuItem(
                  child: const Text('Remove Friend',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => _removeFriend(friend.userId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToUserProfile(Friend friend) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtherProfilePage(friend: friend),
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _searchUsers(String query) async {
    // Debounce the search to avoid too many requests
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      final result = await _friendService.searchUsers(query);

      if (mounted) {
        setState(() {
          searchResults = List<Friend>.from(result['friends'] ?? []);

          if (result['error'] != null &&
              result['error'] != 'User $query not found') {
            floatingSnackBar(
              message: result['error'],
              context: context,
            );
          }
        });
      }
    });
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
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final result = await _friendService.acceptFriendRequest(senderId);

      if (!result['success']) {
        if (mounted) {
          floatingSnackBar(
            message: result['error'],
            context: context,
          );
        }
        return;
      }

      if (!mounted) return;

      // Show success message
      floatingSnackBar(
        message: 'Friend request accepted!',
        context: context,
      );

      // Update local state
      setState(() {
        friendRequests.removeWhere((request) => request.userId == senderId);
      });

      // Refresh data from server
      userProvider.fetchFriendsList();
      userProvider.fetchFriendRequests();
    } catch (e) {
      if (mounted) {
        floatingSnackBar(
          message: 'Error accepting friend request: $e',
          context: context,
        );
      }
    }
  }

  Future<void> _declineFriendRequest(String senderId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final result = await _friendService.declineFriendRequest(senderId);

      if (!result['success']) {
        if (mounted) {
          floatingSnackBar(
            message: result['error'],
            context: context,
          );
        }
        return;
      }

      if (!mounted) return;

      // Update local state
      setState(() {
        friendRequests.removeWhere((request) => request.userId == senderId);
      });

      // Refresh data from server
      userProvider.fetchFriendRequests();
    } catch (e) {
      if (mounted) {
        floatingSnackBar(
          message: 'Error declining friend request: $e',
          context: context,
        );
      }
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
      _initializeFriends();
    });
  }
}
