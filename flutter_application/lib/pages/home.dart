import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/providers/trivia_provider.dart';
import 'package:flutter_application/providers/user_provider.dart';
import 'package:flutter_application/widgets/home/session_history.dart';
import 'package:flutter_application/widgets/home/home_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // List of widgets to be displayed
    final List<Widget> sections = [
      const TopPortion(),
      MiddlePortion(
        userProvider: userProvider,
      ),
      BottomPortion(
        userProvider: userProvider,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: backgroundPageColor,
          image: DecorationImage(
            image: AssetImage('assets/images/shapes.png'),
            opacity: 0.2,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              return sections[index];
            },
          ),
        ),
      ),
    );
  }
}

class TopPortion extends StatelessWidget {
  const TopPortion({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final String firstName =
            userProvider.userProfile?.fullName.split(' ')[0] ?? 'Guest';
        final int questionCount =
            Provider.of<TriviaProvider>(context, listen: false)
                .questions
                .length;
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // Ensure the Column takes the available space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Text
                    Text(
                      'Hi, $firstName',
                      style: const TextStyle(
                        color: Colors.white70, // Subdued color for greeting
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Text(
                      "Let's play!",
                      style: TextStyle(
                        color: Colors.white, // Bright color for emphasis
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Space between greeting and content
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: GestureDetector(
                  onTap: () => debugPrint("$questionCount"),
                  child: SvgPicture.asset('assets/icons/home/Bolt.svg'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MiddlePortion extends StatelessWidget {
  final UserProvider userProvider;

  const MiddlePortion({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: DailyTaskCard(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: TopicSelectionButton(userProvider: userProvider),
            ),
            const SizedBox(width: 15), // Space between the two columns
            const Expanded(
              flex: 4,
              child: HistoryButton(),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15),
          child: QuickPlayButton(),
        )
      ],
    );
  }
}

class BottomPortion extends StatelessWidget {
  final UserProvider userProvider;

  const BottomPortion({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Topics >',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 11,
            mainAxisSpacing: 11,
            childAspectRatio: 1,
            children: const [
              TopicButton(
                title: 'discrete_math',
                iconName: 'discrete_math.png',
                iconSize: 65,
                color: discreteMathColor,
                rightOffset: -6,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'cloud_computing',
                iconName: 'cloud_computing.png',
                iconSize: 65,
                color: cloudComputingColor,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'artificial_intelligence',
                iconName: 'artificial_intelligence.png',
                iconSize: 73,
                color: artificialIntelligenceColor,
                bottomOffset: -15,
                rightOffset: -12,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'machine_learning',
                iconName: 'machine_learning.png',
                iconSize: 65,
                color: machineLearningColor,
                rightOffset: -8,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'data_structures',
                iconName: 'data_structures.png',
                iconSize: 65,
                color: dataStructuresColor,
                rightOffset: -8,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'cyber_security',
                iconName: 'cyber_security.png',
                iconSize: 70,
                color: cyberSecurityColor,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'algorithms',
                iconName: 'algorithms.png',
                iconSize: 65,
                color: algorithmsColor,
                rightOffset: -8,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'database',
                iconName: 'database.png',
                iconSize: 68,
                color: databaseColor,
                radius: 18,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
              TopicButton(
                title: 'swe_fundamentals',
                iconName: 'swe_fundamentals.png',
                iconSize: 65,
                color: sweFundamentalsColor,
                radius: 18,
                rightOffset: -7,
                titleFontSize: 11,
                buttonType: 'home',
                section: 'grid',
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class DailyTaskCard extends StatelessWidget {
  const DailyTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: backgroundPageColor),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [purpleAccent, darkPurpleAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        color: purpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.34),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Image.asset(
                  'assets/images/task.png',
                  height: 70,
                  width: 70,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Daily Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '15 Questions',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Wrap the progress bar and count with Consumer
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    int solvedTodayCount =
                        userProvider.userProfile?.solvedTodayCount ?? 0;
                    double progress = (solvedTodayCount / 15).clamp(0.0, 1.0);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 9,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double progressWidth =
                                    progress * constraints.maxWidth;
                                return Container(
                                  height: 9,
                                  width: progressWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Progress',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '$solvedTodayCount/15',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryButton extends StatelessWidget {
  const HistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: customHomeButton(
        title: 'Session History',
        titleFontSize: 16,
        subtitle: 'Explore your most recent gameplay sessions.',
        subtitleFontSize: 9,
        iconPath: 'assets/icons/home/History.svg',
        iconSize: 25,
        onTap: () => showDialog(
          context: context,
          builder: (context) => const SessionHistoryPopup(),
        ),
        textPadding: const EdgeInsets.only(left: 15, right: 7, bottom: 3),
        iconPadding: const EdgeInsets.only(bottom: 20),
      ),
    );
  }
}
