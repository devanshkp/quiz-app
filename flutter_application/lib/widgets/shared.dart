import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/pages/topic.dart';
import 'package:flutter_application/widgets/home/home_widgets.dart';
import 'package:string_extensions/string_extensions.dart';

class CustomHorizontalDivider extends StatelessWidget {
  final double padding;
  final Color color;
  final double thickness;

  const CustomHorizontalDivider({
    super.key,
    required this.padding,
    this.color = Colors.white24,
    this.thickness = 1.25,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
      child: Divider(color: color, thickness: thickness),
    );
  }
}

class CustomVerticalDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  const CustomVerticalDivider({
    super.key,
    this.color = Colors.white30,
    this.height = double.infinity,
    this.width = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final double horizontalPadding;
  final EdgeInsets indicatorPadding;
  final double textSize;
  final double tabHeight;
  final TabController controller;
  final Color indicatorColor;
  final Color labelColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.horizontalPadding = 60.0,
    this.indicatorPadding = const EdgeInsets.all(3),
    this.textSize = 14.0,
    this.tabHeight = 45.0,
    this.indicatorColor = backgroundPageColor,
    this.labelColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 34, 34, 34),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: TabBar(
          controller: controller,
          tabs: tabs
              .map((tab) => Tab(
                    text: tab,
                    height: tabHeight,
                  ))
              .toList(),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: textSize,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
            fontSize: textSize,
          ),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: indicatorPadding,
          labelColor: labelColor,
          unselectedLabelColor: Colors.white70,
          indicator: BoxDecoration(
            boxShadow: [buttonDropShadow],
            color: indicatorColor,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
    );
  }
}

class TopicButton extends StatelessWidget {
  final String title;
  final String iconName;
  final double iconSize;
  final Color color;
  final double titleFontSize;
  final String buttonType;
  final double? radius;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? bottomOffset;
  final double? rightOffset;
  final String? section;

  const TopicButton({
    super.key,
    required this.title,
    required this.iconName,
    required this.iconSize,
    required this.color,
    required this.titleFontSize,
    required this.buttonType,
    this.radius,
    this.buttonWidth,
    this.buttonHeight,
    this.bottomOffset,
    this.rightOffset,
    this.section,
  });

  @override
  Widget build(BuildContext context) {
    final String heroBaseTag = section != null
        ? '${title}_${buttonType}_$section'
        : '${title}_$buttonType';

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TopicDetailsPage(
                topicName: title,
                iconName: iconName,
                topicColor: color,
                buttonType: buttonType,
                heroBaseTag: heroBaseTag,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        child: Container(
          width: buttonWidth ?? double.infinity,
          height: buttonHeight ?? double.infinity,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ], gradient: createGradientFromColor(color)),
          child: Stack(
            children: [
              // Positioned image for bottom-right corner
              Positioned(
                bottom: bottomOffset ?? -10,
                right: rightOffset ?? -10,
                child: Hero(
                  tag: 'topic_icon_$heroBaseTag',
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Image.asset(
                      'assets/images/topics/$iconName',
                      width: iconSize,
                      height: iconSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Positioned text for top-left corner
              Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Hero(
                    tag: 'topic_title_$heroBaseTag',
                    child: Material(
                      color: Colors.transparent,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Text(
                          title.replaceAll('_', ' ').toTitleCase,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: radius != null
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarImage extends StatelessWidget {
  final String? avatarUrl;
  final double avatarRadius;
  const AvatarImage(
      {super.key, required this.avatarUrl, required this.avatarRadius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: avatarRadius,
      backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
          ? NetworkImage(avatarUrl!)
          : const AssetImage('assets/images/avatar.jpg'),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double avatarRadius;
  const UserAvatar(
      {super.key, required this.avatarUrl, required this.avatarRadius});

  @override
  Widget build(BuildContext context) {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return CircleAvatar(
        radius: avatarRadius,
        backgroundImage: const AssetImage('assets/images/avatar.jpg'),
      );
    }

    return CachedNetworkImage(
      memCacheWidth: 250,
      memCacheHeight: 250,
      maxHeightDiskCache: 500,
      maxWidthDiskCache: 500,
      imageUrl: avatarUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: avatarRadius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => Container(
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: avatarRadius,
        backgroundImage: const AssetImage('assets/images/avatar.jpg'),
      ),
    );
  }
}

class DeveloperAvatar extends StatefulWidget {
  final String imageUrl;
  final double size;
  final VoidCallback? onTap;

  const DeveloperAvatar({
    super.key,
    required this.imageUrl,
    this.size = 80.0,
    this.onTap,
  });

  @override
  State<DeveloperAvatar> createState() => _DeveloperAvatarState();
}

class _DeveloperAvatarState extends State<DeveloperAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Define rainbow colors
  final List<Color> rainbowColors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Get current color based on animation value
  Color getCurrentGlowColor(double animValue) {
    // Calculate which segment of the rainbow we're in
    final int colorIndex = (animValue * (rainbowColors.length - 1)).floor();
    final double colorPosition =
        (animValue * (rainbowColors.length - 1)) - colorIndex;

    // Interpolate between current and next color
    if (colorIndex < rainbowColors.length - 1) {
      return Color.lerp(
        rainbowColors[colorIndex],
        rainbowColors[colorIndex + 1],
        colorPosition,
      )!;
    } else {
      return rainbowColors.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Get current glow color based on animation
          final glowColor = getCurrentGlowColor(_controller.value);

          return Container(
            width: widget.size * 2 + 12,
            height: widget.size * 2 + 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glowColor,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.7),
                  blurRadius: 12,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: glowColor.withOpacity(0.3),
                  blurRadius: 18,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipOval(
                child: Container(
                  width: widget.size * 2,
                  height: widget.size * 2,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: widget.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HorizontalDividerWithText extends StatelessWidget {
  final String text;
  final double dividerPadding;
  final Color dividerColor;
  final double dividerThickness;
  final TextStyle textStyle;

  const HorizontalDividerWithText({
    super.key,
    required this.text,
    this.dividerPadding = 5.0,
    this.dividerColor = Colors.white70,
    this.dividerThickness = 0.5,
    this.textStyle = const TextStyle(color: Colors.white70, fontSize: 13),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomHorizontalDivider(
            padding: dividerPadding,
            color: dividerColor,
            thickness: dividerThickness,
          ),
        ),
        Text(
          text,
          style: textStyle,
        ),
        Expanded(
          child: CustomHorizontalDivider(
            padding: dividerPadding,
            color: dividerColor,
            thickness: dividerThickness,
          ),
        ),
      ],
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: Color(0xFF2C2C2C),
      ),
      padding: const EdgeInsets.all(5),
      child: const SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  const CustomCard({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black45,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.085),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmationButtonText;
  final String cancelButtonText;
  final VoidCallback onPressed;
  const CustomAlertDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.confirmationButtonText,
      required this.cancelButtonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      content: Text(
        content,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelButtonText,
            style: TextStyle(color: Colors.blue[200]),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed();
          },
          child: Text(
            confirmationButtonText,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class GradientElevatedButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final LinearGradient gradient;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final double iconSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final bool fullWidth;

  // Touch interaction properties
  final Color splashColor;
  final Color highlightColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final Duration animationDuration;
  final bool enableFeedback;
  final HitTestBehavior hitTestBehavior;
  final bool enableScale; // New property to enable/disable scale animation

  const GradientElevatedButton({
    super.key,
    this.icon,
    required this.text,
    required this.gradient,
    required this.textColor,
    required this.borderColor,
    required this.onPressed,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.elevation = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.iconSize = 22.0,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w600,
    this.iconSpacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.fullWidth = false,

    // Default values for touch interaction
    this.splashColor = Colors.white24,
    this.highlightColor = Colors.white10,
    this.splashFactory = InkRipple.splashFactory,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableFeedback = true,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.enableScale = true,
  });

  @override
  Widget build(BuildContext context) {
    return _ScaleOnPress(
      duration: animationDuration,
      onPressed: onPressed,
      enabled: enableScale,
      child: PhysicalModel(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: elevation,
        child: Container(
          width: fullWidth ? double.infinity : width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: splashColor,
              highlightColor: highlightColor,
              splashFactory: splashFactory,
              enableFeedback: enableFeedback,
              hoverColor: Colors.white.withOpacity(0.1),
              focusColor: Colors.white.withOpacity(0.1),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Container(
                  padding: padding,
                  child: Row(
                    mainAxisSize:
                        fullWidth ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: mainAxisAlignment,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: iconSize,
                          color: textColor,
                        ),
                        SizedBox(width: iconSpacing),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget to add scale animation on press
class _ScaleOnPress extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;
  final bool enabled;

  const _ScaleOnPress({
    required this.child,
    required this.onPressed,
    required this.duration,
    required this.enabled,
  });

  @override
  _ScaleOnPressState createState() => _ScaleOnPressState();
}

class _ScaleOnPressState extends State<_ScaleOnPress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
