import 'package:flutter/material.dart';

import '../../core/app_store.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';
import '../profile/profile_pages.dart';

void openCampaign(BuildContext context, Campaign campaign) {
  AppScope.of(context).chooseCampaign(campaign);
  go(context, '/details');
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: index,
      children: [
        const HomePage(),
        const SearchPage(embedded: true),
        const HistoryPage(embedded: true),
        const ProfilePage(embedded: true),
      ],
    ),
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (final (i, label, icon) in [
                (0, 'Home', Icons.home_filled),
                (1, 'Search', Icons.search),
                (2, 'Your Giving', Icons.shopping_bag_outlined),
                (3, 'Profile', Icons.person_outline),
              ])
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => index = i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: index == i ? ink : const Color(0xFFBDBDBD),
                          size: 25,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: index == i ? ink : const Color(0xFFBDBDBD),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 12, 30, 0),
          child: HomeHeader(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 24, 30, 24),
          child: SearchInput(onTap: () => go(context, '/search')),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ExploreBanner(),
        ),
        const SizedBox(height: 16),
        const StepDots(1),
        const SizedBox(height: 24),
        Container(
          color: canvas,
          padding: const EdgeInsets.only(top: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 112,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemBuilder: (context, i) => Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/category',
                  arguments: categories[i],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    art('category-$i', width: 38, height: 38),
                    const SizedBox(height: 7),
                    Text(
                      categories[i].replaceFirst(' ', '\n'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: canvas,
          padding: const EdgeInsets.fromLTRB(30, 18, 30, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle('Find Nearby', onMore: () => go(context, '/nearby')),
              const SizedBox(height: 12),
              CampaignCard(
                campaign: campaigns[2],
                onTap: () => openCampaign(context, campaigns[2]),
                photoOnly: true,
                height: 320,
              ),
              const SizedBox(height: 24),
              const SectionTitle('Popular Organization'),
              const SizedBox(height: 16),
              SizedBox(
                height: 98,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, i) => const SizedBox(width: 12),
                  itemBuilder: (context, i) => Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => go(context, '/organization'),
                      child: SizedBox(
                        width: 85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OrganizationLogo(index: i + 1),
                            const SizedBox(height: 7),
                            const Text(
                              'Organization\nName',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => go(context, '/fundraise-for'),
                child: const Text('+ Start a fundraiser'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});
  Future<void> editLocation(BuildContext context) async {
    final s = AppScope.of(context),
        controller = TextEditingController(text: AppScope.of(context).location);
    final value = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'City, country'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (value != null && value.isNotEmpty) {
      s.location = value;
      s.save();
    }
    // Dispose after the dialog's closing animation has finished.
    Future<void>.delayed(const Duration(milliseconds: 300), controller.dispose);
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      InkWell(
        onTap: () => editLocation(context),
        borderRadius: BorderRadius.circular(30),
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFFFEEEB),
          child: Icon(Icons.location_on, color: coral, size: 21),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: GestureDetector(
          onTap: () => editLocation(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              Text(
                AppScope.of(context).location,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
      IconButton(
        tooltip: 'Reminders',
        onPressed: () async {
          final s = AppScope.of(context);
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
        icon: const Badge(
          smallSize: 7,
          backgroundColor: coral,
          child: Icon(Icons.notifications, color: Color(0xFFD0D0D0), size: 22),
        ),
      ),
    ],
  );
}

class ExploreBanner extends StatelessWidget {
  const ExploreBanner({super.key});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      height: 170,
      child: Stack(
        fit: StackFit.expand,
        children: [
          art('banner'),
          Positioned(
            left: 20,
            top: 23,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Give to\nOrganisations\n& causes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                    letterSpacing: -.6,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 95,
                  height: 32,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(95, 32),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => go(context, '/category'),
                    child: const Text(
                      'Explore',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class CampaignListPage extends StatefulWidget {
  final bool nearby;
  const CampaignListPage({super.key, this.nearby = false});
  @override
  State<CampaignListPage> createState() => _CampaignListPageState();
}

class _CampaignListPageState extends State<CampaignListPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as String?;
    final list = campaigns
        .where(
          (c) =>
              (widget.nearby || category == null || c.category == category) &&
              '${c.title} ${c.organization}'.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    return PageFrame(
      title: widget.nearby ? 'Find Nearby' : category ?? 'Explore causes',
      background: widget.nearby ? Colors.white : canvas,
      child: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          SearchInput(onChanged: (v) => setState(() => query = v)),
          const SizedBox(height: 18),
          if (!widget.nearby) ...[
            const ExploreBanner(),
            const SizedBox(height: 26),
            const SectionTitle('Need to help'),
            const SizedBox(height: 16),
          ],
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text('No causes found. Try another search.'),
            ),
          for (final c in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CampaignCard(
                campaign: c,
                photoOnly: widget.nearby,
                onTap: () => openCampaign(context, c),
              ),
            ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  final bool embedded;
  const SearchPage({super.key, this.embedded = false});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  String category = 'All', query = '';
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = campaigns
        .where(
          (c) =>
              (category == 'All' || c.category == category) &&
              '${c.title} ${c.organization} ${c.category}'
                  .toLowerCase()
                  .contains(query.toLowerCase()),
        )
        .toList();
    final searching = query.isNotEmpty || category != 'All';
    final body = Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(widget.embedded ? 30 : 20, 12, 30, 12),
          child: Row(
            children: [
              if (!widget.embedded)
                IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left),
                ),
              Expanded(
                child: SearchInput(
                  controller: controller,
                  onChanged: (v) => setState(() => query = v),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, i) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final c = i == 0 ? 'All' : categories[i - 1];
              return ChoiceChip(
                label: Text(
                  c,
                  style: TextStyle(
                    fontSize: 12,
                    color: category == c ? Colors.white : ink,
                  ),
                ),
                selected: category == c,
                showCheckmark: false,
                selectedColor: purple,
                backgroundColor: canvas,
                side: BorderSide.none,
                shape: const StadiumBorder(),
                onSelected: (_) => setState(() => category = c),
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              if (!searching) ...[
                const Text(
                  'Recent Search',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                for (final index in [4, 2])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      tileColor: canvas,
                      leading: OrganizationLogo(index: index, size: 28),
                      title: const Text(
                        'Organization Name',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: muted),
                      onTap: () => go(context, '/organization'),
                    ),
                  ),
                const SizedBox(height: 12),
              ],
              if (results.isEmpty) ...[
                const SizedBox(height: 70),
                const Icon(Icons.search_off, size: 64, color: muted),
                const SizedBox(height: 14),
                const Text(
                  'No matching causes',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try a different keyword or category.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted),
                ),
              ],
              for (final c in searching ? results : results.take(2))
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CampaignCard(
                    campaign: c,
                    onTap: () => openCampaign(context, c),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
    return widget.embedded
        ? SafeArea(bottom: false, child: body)
        : Scaffold(body: SafeArea(child: body));
  }
}

class OrganizationPage extends StatelessWidget {
  const OrganizationPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Organization Profile',
    child: ListView(
      padding: const EdgeInsets.all(30),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 30,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            children: [
              art('brand', width: 64, height: 64),
              const SizedBox(height: 20),
              Text(
                'Filllo Charity Organization',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Sylhet, Bangladesh',
                style: TextStyle(color: muted, fontSize: 13),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.public, color: purple, size: 18),
                  SizedBox(width: 12),
                  Icon(Icons.apple, size: 20),
                  SizedBox(width: 12),
                  Icon(Icons.facebook, color: Colors.blue, size: 20),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionTitle('Need to help'),
        const SizedBox(height: 16),
        CampaignCard(
          campaign: campaigns.first,
          onTap: () => openCampaign(context, campaigns.first),
        ),
        const SizedBox(height: 24),
        Text('Our Office', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: art('map', height: 180, width: double.infinity),
        ),
        const SizedBox(height: 12),
        const Text(
          '980 Corporate Drive, Suite 700\nFort Lauderdale',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          'View all causes',
          onPressed: () => go(context, '/category'),
        ),
      ],
    ),
  );
}
