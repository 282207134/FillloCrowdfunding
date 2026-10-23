import 'package:flutter/material.dart';

import '../../core/app_store.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class ProfilePage extends StatelessWidget {
  final bool embedded;
  const ProfilePage({super.key, this.embedded = false});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      backgroundColor: canvas,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 350 + MediaQuery.paddingOf(context).top,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: art(
                    'profile-cover',
                    height: 210 + MediaQuery.paddingOf(context).top,
                    width: double.infinity,
                  ),
                ),
                Container(
                  height: 210 + MediaQuery.paddingOf(context).top,
                  decoration: const BoxDecoration(
                    color: Color(0x55000000),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 12,
                  left: 24,
                  right: 24,
                  child: Row(
                    children: [
                      if (!embedded)
                        IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                      const Expanded(
                        child: Text(
                          'Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Positioned(
                  top: 152 + MediaQuery.paddingOf(context).top,
                  left: 30,
                  right: 30,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 54, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          s.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _stat(
                                '${s.donations.length}',
                                'Contribution',
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 48,
                              color: const Color(0xFFEEEEEE),
                            ),
                            Expanded(
                              child: _stat(
                                '\$${s.totalGiving.toStringAsFixed(2)}',
                                'Total Giving',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 115 + MediaQuery.paddingOf(context).top,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: art('avatar', height: 68, width: 68),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () {
                    s.following = !s.following;
                    s.save();
                  },
                  child: Text(s.following ? '✓  Following' : '+  Follow'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bio',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Helping communities recover, rebuild and thrive.\nSmall acts of kindness make a lasting difference.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 24),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      _menu(
                        context,
                        'Profile Details',
                        Icons.person,
                        '/profile-details',
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      _menu(context, 'History', Icons.settings, '/history'),
                      const Divider(indent: 16, endIndent: 16),
                      ListTile(
                        leading: _menuIcon(Icons.event_note),
                        title: const Text(
                          'Reminders',
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: muted),
                        onTap: () async {
                          final value = await frequencySheet(
                            context,
                            title: 'Your filllo Reminders',
                            reminder: true,
                            selected: s.reminder,
                          );
                          if (value != null) {
                            s.reminder = value;
                            s.save();
                          }
                        },
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      _menu(context, 'Wallet', Icons.credit_card, '/wallet'),
                      const Divider(indent: 16, endIndent: 16),
                      _menu(context, 'Recurring', Icons.person, '/recurring'),
                      const Divider(indent: 16, endIndent: 16),
                      _menu(context, 'Support', Icons.headset_mic, '/support'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    s.signedIn = false;
                    s.save();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/welcome',
                      (_) => false,
                    );
                  },
                  child: const Text('Log out', style: TextStyle(color: muted)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: muted, fontSize: 13)),
    ],
  );
  Widget _menuIcon(IconData icon) => CircleAvatar(
    radius: 16,
    backgroundColor: canvas,
    child: Icon(icon, size: 20, color: const Color(0xFFBBBBBB)),
  );
  Widget _menu(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) => ListTile(
    leading: _menuIcon(icon),
    title: Text(label, style: const TextStyle(fontSize: 14)),
    trailing: const Icon(Icons.chevron_right, color: muted),
    onTap: () => go(context, route),
  );
}

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});
  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController(),
      address = TextEditingController();
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final s = AppScope.of(context);
      name.text = s.name;
      email.text = s.email;
      phone.text = s.phone;
      address.text = s.address;
      initialized = true;
    }
  }

  @override
  void dispose() {
    for (final c in [name, email, phone, address]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Profile Details',
    bottom: PrimaryButton(
      'Save changes',
      onPressed: () async {
        if (!form.currentState!.validate()) return;
        final s = AppScope.of(context);
        s.name = name.text.trim();
        s.email = email.text.trim();
        s.phone = phone.text.trim();
        s.address = address.text.trim();
        await s.save();
        if (context.mounted) {
          toast(context, 'Profile saved');
          Navigator.pop(context);
        }
      },
    ),
    child: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Center(
            child: ClipOval(child: art('avatar', height: 116, width: 116)),
          ),
          const SizedBox(height: 30),
          for (final (label, controller) in [
            ('Full Name', name),
            ('Phone', phone),
            ('Email', email),
            ('Address', address),
          ]) ...[
            Text(label, style: const TextStyle(color: muted)),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: label == 'Email'
                  ? TextInputType.emailAddress
                  : label == 'Phone'
                  ? TextInputType.phone
                  : TextInputType.text,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Enter your ${label.toLowerCase()}';
                }
                if (label == 'Email' &&
                    !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
          ],
        ],
      ),
    ),
  );
}

class HistoryPage extends StatelessWidget {
  final bool embedded, recurring;
  const HistoryPage({super.key, this.embedded = false, this.recurring = false});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final gifts = s.donations
        .where((d) => !recurring || d.frequency != 'One time')
        .toList();
    final body = gifts.isEmpty
        ? LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              child: SizedBox(
                height: box.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    art(
                      'empty-history',
                      width: 320,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      recurring ? 'No recurring gifts' : 'No Contribution',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: Text(
                        recurring
                            ? 'Set a recurring gift to make a lasting difference.'
                            : 'Your kindness starts here. Find a cause and make your first contribution.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => go(context, '/category'),
                      child: const Text('Explore causes'),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recurring ? 'Your recurring impact' : 'Your total giving',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${gifts.fold<double>(0, (sum, d) => sum + d.amount).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${gifts.length} ${gifts.length == 1 ? 'contribution' : 'contributions'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              for (final d in gifts)
                Card(
                  elevation: 0,
                  color: canvas,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const OrganizationLogo(index: 4),
                    title: Text(
                      d.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${d.date.year}/${d.date.month}/${d.date.day} · ${d.frequency}',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                    trailing: Text(
                      '\$${d.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, '/receipt', arguments: d),
                  ),
                ),
              if (recurring)
                const Text(
                  'Recurring gifts are saved preferences in this demo. No automatic charges are scheduled.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
            ],
          );
    return embedded
        ? SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Your Giving',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          )
        : PageFrame(
            title: recurring ? 'Recurring Gifts' : 'History',
            child: body,
          );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Support',
    child: ListView(
      padding: const EdgeInsets.all(30),
      children: [
        const CircleAvatar(
          radius: 38,
          backgroundColor: canvas,
          child: Icon(Icons.headset_mic_outlined, color: purple, size: 38),
        ),
        const SizedBox(height: 24),
        Text(
          'A little help,\na bigger impact.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 26),
        for (final (question, answer) in [
          (
            'Is this a real payment app?',
            'This is an interactive Flutter preview based on the Filllo Pixso UI kit. All payments are simulated. No real money is transferred.',
          ),
          (
            'Where are my gifts saved?',
            'Your demo contributions and profile are stored on this device. Uninstalling the app or clearing its data removes them.',
          ),
          (
            'How do recurring gifts work?',
            'Choose a frequency in Gift Summary. The preference appears in Recurring Gifts. This demo does not schedule bank charges.',
          ),
          (
            'How can I start a fundraiser?',
            'Tap Start a fundraiser on Home, choose a recipient and enter a title and category. You can preview a local draft.',
          ),
        ])
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              question,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Text(
                  answer,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
              ),
            ],
          ),
        const SizedBox(height: 30),
        const Text(
          'Filllo · Made for a kinder world',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    ),
  );
}
