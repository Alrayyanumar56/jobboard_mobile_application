import 'package:flutter/material.dart';

class JobListSkeleton extends StatefulWidget {
  const JobListSkeleton({super.key, this.count = 5});
  final int count;

  @override
  State<JobListSkeleton> createState() => _JobListSkeletonState();
}

class _JobListSkeletonState extends State<JobListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _bar(Color color, {double? width, double height = 12}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return FadeTransition(
      opacity: Tween<double>(begin: 0.4, end: 1).animate(_c),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.count,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(radius: 24, backgroundColor: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _bar(color, width: 180, height: 16),
                  const SizedBox(height: 8),
                  _bar(color, width: 120),
                  const SizedBox(height: 12),
                  _bar(color, width: 150),
                  const SizedBox(height: 12),
                  Row(children: [
                    _bar(color, width: 70, height: 22),
                    const SizedBox(width: 6),
                    _bar(color, width: 90, height: 22),
                  ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}