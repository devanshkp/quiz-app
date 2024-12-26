import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utility/custom_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of widgets to be displayed
    final List<Widget> sections = [
      topPortion(),
      middlePortion(),
      bottomPortion(),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
        child: ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            return sections[index];
          },
        ),
      ),
    );
  }

  Widget topPortion() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            // Ensure the Column takes the available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Text
                Text(
                  'Hi, Devansh',
                  style: TextStyle(
                    color: Colors.white70, // Subdued color for greeting
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  'Let’s play!',
                  style: TextStyle(
                    color: Colors.white, // Bright color for emphasis
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20), // Space between greeting and content
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GestureDetector(
                onTap: () => (print("Notification button pressed")),
                child: SvgPicture.asset('assets/icons/home/Bolt.svg')),
          )
        ],
      ),
    );
  }

  Widget middlePortion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: DailyTaskCard(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Ensures space between the text and icon
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                  onTap: () => (print("Categories button pressed.")),
                  child: categoriesButton()),
            ),
            const SizedBox(width: 15), // Space between the two columns
            Expanded(
              flex: 4,
              child: GestureDetector(
                  onTap: () => (print("History button pressed.")),
                  child: historyButton()),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: GestureDetector(
              onTap: () => (print("Quick play button pressed.")),
              child: quickPlayButton()),
        )
      ],
    );
  }

  Widget bottomPortion() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Categories >',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              customCategoryButton(
                  title: 'Foundational Math',
                  titleFontSize: 9,
                  iconName: 'math.png',
                  iconSize: 70,
                  onTap: () => (print('Foudational math pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'Sorting Algorithms',
                  titleFontSize: 9,
                  iconName: 'sort.png',
                  iconSize: 70,
                  onTap: () => (print('Sorting Algorithms pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'Neural Networks',
                  titleFontSize: 9,
                  iconName: 'neural_network.png',
                  iconSize: 70,
                  onTap: () => (print('Neural networks pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'Machine Learning',
                  titleFontSize: 9,
                  iconName: 'machine_learning.png',
                  iconSize: 70,
                  onTap: () => (print('Machine learning pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'Data Structures',
                  titleFontSize: 9,
                  iconName: 'brace.png',
                  iconSize: 70,
                  onTap: () => (print('Data structures pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'Programming Basics',
                  titleFontSize: 9,
                  iconName: 'programming.png',
                  iconSize: 70,
                  onTap: () => (print('Programming basics pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'Popular Algorithms',
                  titleFontSize: 9,
                  iconName: 'algorithm.png',
                  iconSize: 70,
                  onTap: () => (print('Popular algorithms pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'Database',
                  titleFontSize: 9,
                  iconName: 'database.png',
                  iconSize: 70,
                  onTap: () => (print('Database pressed.')),
                  spacing: 5),
              customCategoryButton(
                  title: 'SWE Fundamentals',
                  titleFontSize: 9,
                  iconName: 'swe.png',
                  iconSize: 70,
                  onTap: () => (print('SWE fundamentals pressedd.')),
                  spacing: 5),
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget historyButton() {
    return SizedBox(
        height: 72,
        child: customHomeButton(
          title: 'Session History',
          titleFontSize: 16,
          subtitle: 'Explore your most recent gameplay sessions.',
          subtitleFontSize: 9,
          iconPath: 'assets/icons/home/History.svg',
          iconSize: 25,
          onTap: () => print('History button tapped'),
          textPadding: const EdgeInsets.only(left: 15, right: 7, bottom: 3),
          iconPadding: const EdgeInsets.only(bottom: 20),
        ));
  }

  Widget categoriesButton() {
    return SizedBox(
        height: 72,
        child: customHomeButton(
          title: 'Select Categories',
          titleFontSize: 16,
          iconPath: 'assets/icons/home/Edit.svg',
          iconSize: 15,
          onTap: () => print('Categories button tapped'),
          textPadding: const EdgeInsets.only(left: 15, right: 11),
          iconPadding: const EdgeInsets.only(bottom: 25),
        ));
  }

  Widget quickPlayButton() {
    return SizedBox(
        height: 82,
        child: customHomeButton(
          title: 'QUICK PLAY',
          titleFontSize: 28,
          titleFontWeight: FontWeight.bold,
          subtitle: 'Play questions from your selected categories!',
          subtitleFontSize: 11,
          iconPath: 'assets/icons/home/Play.svg',
          iconSize: 22,
          onTap: () => print('Quick play button tapped'),
          textPadding: const EdgeInsets.only(left: 17, right: 12, bottom: 5),
          iconPadding: const EdgeInsets.only(bottom: 20),
        ));
  }
}

class DailyTaskCard extends StatelessWidget {
  const DailyTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 15),
      decoration: BoxDecoration(
        color: Colors.purple[00],
        image: const DecorationImage(
            image: AssetImage('assets/images/mesh.png'), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center, // Center the widgets in the stack
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
                  'assets/images/task.png', // Replace with your icon path
                  height: 70, // Set the height to match the container
                  width: 70, // Set the width to match the container
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and subtitle
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                              height: 2), // Space between title and subtitle
                          Text(
                            '15 Questions',
                            style: TextStyle(
                              color: Color(0xddFFFFFF),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => (print("Friends button pressed.")),
                        child: SvgPicture.asset('assets/icons/home/Mask.svg',
                            width: 30, height: 30),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16), // Space before progress bar
                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // Background progress bar
                        Container(
                          height: 9,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Filled progress bar
                        Container(
                          height: 9,
                          width: 120, // Placeholder width for progress
                          decoration: BoxDecoration(
                            color: const Color(0xffEDD9F6),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ],
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
                      '7/15',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
