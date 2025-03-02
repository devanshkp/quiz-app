import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/providers/user_provider.dart';
import 'package:flutter_application/providers/trivia_provider.dart';

class BadgesSection extends StatefulWidget {
  const BadgesSection({super.key});

  @override
  State<BadgesSection> createState() => _BadgesSectionState();
}

class _BadgesSectionState extends State<BadgesSection> {
  Map<String, int> _topicCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopicCounts();
  }

  Future<void> _loadTopicCounts() async {
    final triviaProvider = Provider.of<TriviaProvider>(context, listen: false);

    if (triviaProvider.topicCounts.isEmpty) {
      await triviaProvider.getTopicCounts();
    }
    final topicCounts = triviaProvider.topicCounts;

    debugPrint('BadgesSection - Topic Counts from Provider: $topicCounts');

    if (mounted) {
      setState(() {
        _topicCounts = topicCounts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userProfile = userProvider.userProfile;
        if (userProfile == null || _isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        debugPrint(
            'BadgesSection - Selected Topics: ${userProfile.selectedTopics}');
        debugPrint('BadgesSection - Topic Counts: $_topicCounts');
        debugPrint(
            'BadgesSection - Topic Questions Solved: ${userProfile.topicQuestionsSolved}');

        // Check if any topic has a perfect score (all questions solved)
        bool hasPerfectScore = false;
        String perfectTopic = '';

        if (_topicCounts.isNotEmpty &&
            userProfile.topicQuestionsSolved.isNotEmpty) {
          for (final entry in userProfile.topicQuestionsSolved.entries) {
            final topic = entry.key;
            final solvedCount = entry.value;
            final totalCount = _topicCounts[topic] ?? 0;

            debugPrint(
                'BadgesSection - Checking topic: $topic, solved: $solvedCount, total: $totalCount');

            if (totalCount > 0 && solvedCount == totalCount) {
              hasPerfectScore = true;
              perfectTopic = topic.replaceAll('_', ' ');
              perfectTopic = perfectTopic
                  .split(' ')
                  .map((word) => word.isNotEmpty
                      ? '${word[0].toUpperCase()}${word.substring(1)}'
                      : '')
                  .join(' ');
              debugPrint(
                  'BadgesSection - Perfect score found for topic: $perfectTopic');
              break;
            }
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grid of badges
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2C2C2C),
                      Color(0xFF232323),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: 6, // Number of badges
                  itemBuilder: (context, index) {
                    // Define badge data
                    final badges = [
                      {
                        'name': 'First Steps',
                        'icon': Icons.emoji_events,
                        'color': const Color(0xFFFFD700),
                        'unlocked': true,
                        'description': 'Solved your first question'
                      },
                      {
                        'name': 'Streak Master',
                        'icon': Icons.local_fire_department,
                        'color': const Color(0xFFFF7675),
                        'unlocked': userProfile.maxStreak >= 7,
                        'description': 'Maintained a 7-day streak'
                      },
                      {
                        'name': 'Topic Explorer',
                        'icon': Icons.explore,
                        'color': const Color(0xFF6C5CE7),
                        'unlocked':
                            userProfile.topicQuestionsSolved.length >= 5,
                        'description': 'Explored 5 different topics'
                      },
                      {
                        'name': 'Quiz Wizard',
                        'icon': Icons.psychology,
                        'color': const Color(0xFF00B894),
                        'unlocked': userProfile.questionsSolved >= 100,
                        'description': 'Solved 100 questions'
                      },
                      {
                        'name': 'Social Butterfly',
                        'icon': Icons.people,
                        'color': const Color(0xFF0984E3),
                        'unlocked': userProvider.friends.length >= 10,
                        'description': 'Added 10 friends'
                      },
                      {
                        'name': 'Perfect Score',
                        'icon': Icons.star,
                        'color': const Color(0xFFFD79A8),
                        'unlocked': hasPerfectScore,
                        'description': perfectTopic.isNotEmpty
                            ? 'Solved all questions in $perfectTopic'
                            : 'Solve all questions in any topic'
                      },
                    ];

                    final badge = badges[index];
                    final bool unlocked = badge['unlocked'] as bool;

                    return GestureDetector(
                      onTap: () {
                        // Show badge details
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF2C2C2C),
                            title: Text(
                              badge['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              badge['description'] as String,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // Badge icon with container
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: unlocked
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: unlocked
                                    ? (badge['color'] as Color)
                                    : Colors.grey.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: unlocked
                                  ? [
                                      BoxShadow(
                                        color: (badge['color'] as Color)
                                            .withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              badge['icon'] as IconData,
                              color: unlocked
                                  ? badge['color'] as Color
                                  : Colors.grey.withOpacity(0.5),
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Badge name
                          Text(
                            badge['name'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: unlocked ? Colors.white : Colors.white54,
                              fontSize: 12,
                              fontWeight: unlocked
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Progress section
              _buildProgressSection(userProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSection(UserProvider userProvider) {
    // Calculate unlocked badges count
    final userProfile = userProvider.userProfile!;
    int unlockedCount = 0;

    // First Steps is always unlocked
    unlockedCount++;

    // Streak Master (7-day streak)
    if (userProfile.maxStreak >= 7) unlockedCount++;

    // Topic Explorer (5 topics)
    if (userProfile.topicQuestionsSolved.length >= 5) unlockedCount++;

    // Quiz Wizard (100 questions)
    if (userProfile.questionsSolved >= 100) unlockedCount++;

    // Social Butterfly (10 friends)
    if (userProvider.friends.length >= 10) unlockedCount++;

    // Perfect Score (all questions in any topic)
    bool hasPerfectScore = false;
    if (_topicCounts.isNotEmpty &&
        userProfile.topicQuestionsSolved.isNotEmpty) {
      for (final entry in userProfile.topicQuestionsSolved.entries) {
        final topic = entry.key;
        final solvedCount = entry.value;
        final totalCount = _topicCounts[topic] ?? 0;

        if (totalCount > 0 && solvedCount == totalCount) {
          hasPerfectScore = true;
          break;
        }
      }
    }

    if (hasPerfectScore) unlockedCount++;

    const totalBadges = 6;
    final progressPercentage = unlockedCount / totalBadges;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2C2C2C),
            Color(0xFF232323),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Badge Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // Progress circle
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: progressPercentage,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C5CE7),
                        ),
                        strokeWidth: 8,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(progressPercentage * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$unlockedCount of $totalBadges badges unlocked',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Keep solving questions to unlock more!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
