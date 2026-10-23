import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/models.dart';

Widget art(
  String name, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) => Image.asset(
  'assets/images/$name.png',
  width: width,
  height: height,
  fit: fit,
);
void go(BuildContext context, String route) =>
    Navigator.of(context).pushNamed(route);
void home(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
void toast(BuildContext context, String text) => ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );

class PageFrame extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottom, action;
  final Color background;
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.bottom,
    this.action,
    this.background = Colors.white,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    appBar: AppBar(
      title: Text(title),
      leading: IconButton(
        tooltip: 'Back',
        icon: const Icon(Icons.chevron_left),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            home(context);
          }
        },
      ),
      actions: action == null ? null : [action!, const SizedBox(width: 16)],
    ),
    body: SafeArea(top: false, child: child),
    bottomNavigationBar: bottom == null
        ? null
        : SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(30, 12, 30, 20),
            child: bottom!,
          ),
  );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton(this.label, {super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) =>
      FilledButton(onPressed: onPressed, child: Text(label));
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;
  const SectionTitle(this.title, {super.key, this.onMore});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      if (onMore != null)
        TextButton(
          onPressed: onMore,
          child: const Text(
            'See more',
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ),
    ],
  );
}

class SearchInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  const SearchInput({super.key, this.onChanged, this.onTap, this.controller});
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    readOnly: onTap != null,
    onTap: onTap,
    onChanged: onChanged,
    textInputAction: TextInputAction.search,
    decoration: const InputDecoration(
      hintText: 'Search...',
      prefixIcon: Icon(Icons.search, size: 23),
      suffixIcon: Icon(Icons.mic_none, size: 19, color: Color(0xFFBDBDBD)),
      contentPadding: EdgeInsets.symmetric(vertical: 12),
    ),
  );
}

class OrganizationLogo extends StatelessWidget {
  final int index;
  final double size;
  const OrganizationLogo({super.key, this.index = 1, this.size = 36});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: const EdgeInsets.all(4),
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: art('org-$index', fit: BoxFit.contain),
  );
}

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onTap;
  final bool photoOnly;
  final double height;
  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onTap,
    this.photoOnly = false,
    this.height = 250,
  });
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: photoOnly
          ? SizedBox(
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  art(campaign.image),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xDD101820)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 12,
                    bottom: 18,
                    child: Row(
                      children: [
                        const OrganizationLogo(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campaign.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -.6,
                                ),
                              ),
                              Text(
                                'by ${campaign.organization}',
                                style: const TextStyle(
                                  color: Color(0xFFCDCDCD),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                art(campaign.image, height: 150, width: double.infinity),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4F2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Disaster',
                              style: TextStyle(color: coral, fontSize: 12),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$${campaign.raised.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            ' / 2.99k',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        campaign.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const OrganizationLogo(index: 4, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'by ${campaign.organization}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ),
  );
}

class CheckBadge extends StatelessWidget {
  const CheckBadge({super.key});
  @override
  Widget build(BuildContext context) => const CircleAvatar(
    radius: 12,
    backgroundColor: lime,
    child: Icon(Icons.check, size: 17, color: ink),
  );
}

class FundLabel extends StatelessWidget {
  final String text;
  const FundLabel({
    super.key,
    this.text = 'Give to Hurricane Harvey Rebuild Fund',
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        const CheckBadge(),
        const SizedBox(width: 9),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}

class StepDots extends StatelessWidget {
  final int active;
  final bool connected;
  const StepDots(this.active, {super.key, this.connected = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      3,
      (i) => Row(
        children: [
          if (i > 0 && connected)
            Container(
              width: 18,
              height: 4,
              color: i <= active ? purple : const Color(0xFFE5E5E5),
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: connected ? 0 : 3),
            width: connected
                ? 12
                : i == active
                ? 10
                : 6,
            height: connected
                ? 12
                : i == active
                ? 10
                : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= active && connected
                  ? purple
                  : i == active
                  ? ink
                  : const Color(0xFFD3D3D3),
            ),
          ),
        ],
      ),
    ),
  );
}

const frequencies = [
  'Daily',
  'Weekly',
  'Every two weeks',
  '1st and 16th',
  'Monthly',
];
Future<String?> frequencySheet(
  BuildContext context, {
  String title = 'Set Recurring Gift',
  String selected = 'One time',
  bool reminder = false,
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
  ),
  builder: (context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(30, 26, 30, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(color: muted, fontSize: 16)),
          const SizedBox(height: 12),
          if (!reminder)
            const Text(
              'How often would you like to\nsend this gift',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -.6,
              ),
            ),
          const SizedBox(height: 22),
          for (final f in frequencies)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  foregroundColor: f == selected ? purple : ink,
                  side: BorderSide(
                    color: f == selected ? purple : const Color(0xFFE5E5E5),
                  ),
                ),
                onPressed: () => Navigator.pop(context, f),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(f),
                    if (f == selected) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.radio_button_checked, size: 19),
                    ],
                  ],
                ),
              ),
            ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, reminder ? 'Off' : 'One time'),
            child: Text(
              reminder
                  ? 'Turn off reminders'
                  : "Don't set this as a recurring Gift",
              style: const TextStyle(color: ink, fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  ),
);
