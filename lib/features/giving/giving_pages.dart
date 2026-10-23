import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_store.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      title: 'Details',
      background: canvas,
      action: IconButton(
        tooltip: 'Copy cause details',
        onPressed: () async {
          await Clipboard.setData(
            ClipboardData(
              text:
                  '${s.campaign.title}\nSupport ${s.campaign.organization} with Filllo.',
            ),
          );
          if (context.mounted) toast(context, 'Cause details copied');
        },
        icon: const Icon(Icons.share_outlined, size: 22),
      ),
      bottom: PrimaryButton('Give', onPressed: () => go(context, '/gift')),
      child: ListView(
        children: [
          Container(
            color: Colors.white,
            child: art(
              'detail-art',
              width: double.infinity,
              height: 264,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${s.campaign.raised.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  s.campaign.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                Text(
                  s.campaign.organization,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  expanded
                      ? 'Your gift provides emergency supplies, shelter and practical support to families affected by disaster. Together with local volunteers, we help communities recover and rebuild for the future. Every contribution makes a difference.'
                      : 'To a strategic donor, successful disaster relief support is rooted in thoughtful, educated decision making, despite the compelling pull to give...',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 30),
                  ),
                  onPressed: () => setState(() => expanded = !expanded),
                  child: Text(
                    expanded ? 'Read less' : 'Read more',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                FundLabel(text: 'Give to ${s.campaign.title}'),
                const SizedBox(height: 20),
                _fact(
                  Icons.favorite_outline,
                  'Join over 1 million good people',
                  'Who do more good with filllo',
                ),
                const SizedBox(height: 20),
                _fact(
                  Icons.location_on_outlined,
                  '980 Corporate Drive, Suite 700',
                  'Fort Lauderdale',
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: art('map', height: 210, width: double.infinity),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fact(IconData icon, String title, String subtitle) => Row(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: const Color(0xFFCCCCCC)),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(subtitle, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ],
  );
}

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});
  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      title: 'Details',
      background: canvas,
      bottom: PrimaryButton('Give', onPressed: () => go(context, '/summary')),
      child: ListView(
        children: [
          Container(
            color: Colors.white,
            child: art(
              'detail-art',
              width: double.infinity,
              height: 240,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 8),
            child: Column(
              children: [
                const Text(
                  'Select your gift',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const StepDots(0, connected: true),
                const SizedBox(height: 18),
                FundLabel(text: 'Give to ${s.campaign.title}'),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1.9,
                  children: [
                    for (final value in [
                      25,
                      35,
                      45,
                      55,
                      65,
                      75,
                      85,
                      95,
                      105,
                      115,
                    ])
                      _amount(value, s.amount == value, () {
                        s.amount = value.toDouble();
                        setState(() {});
                      }),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () => go(context, '/custom-gift'),
                        child: const Center(
                          child: Text(
                            'Other',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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

  Widget _amount(int amount, bool active, VoidCallback tap) => Material(
    color: active ? purple : Colors.white,
    borderRadius: BorderRadius.circular(40),
    child: InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(40),
      child: Center(
        child: Text(
          '\$$amount',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : ink,
          ),
        ),
      ),
    ),
  );
}

class CustomGiftPage extends StatefulWidget {
  const CustomGiftPage({super.key});
  @override
  State<CustomGiftPage> createState() => _CustomGiftPageState();
}

class _CustomGiftPageState extends State<CustomGiftPage> {
  final form = GlobalKey<FormState>();
  final amount = TextEditingController(text: '60.00');
  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Donate',
    bottom: PrimaryButton(
      'Continue',
      onPressed: () {
        if (!form.currentState!.validate()) return;
        AppScope.of(context).amount = double.parse(amount.text);
        go(context, '/summary');
      },
    ),
    child: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Text('Type your amount', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key('custom-amount'),
                  controller: amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  validator: (v) {
                    final value = double.tryParse(v ?? '');
                    return value == null ||
                            !value.isFinite ||
                            value <= 0 ||
                            value > 12980
                        ? 'Enter 0.01 – 12,980.00'
                        : RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(v!)
                        ? null
                        : 'Use up to 2 decimal places';
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'Available demo balance: 12,980.00',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose an amount that feels right for you.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});
  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late final TextEditingController message;
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      message.text = AppScope.of(context).message;
      initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    message = TextEditingController();
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      title: 'Details',
      background: canvas,
      bottom: PrimaryButton(
        'Continue',
        onPressed: () {
          s.message = message.text.trim();
          go(context, '/payment');
        },
      ),
      child: ListView(
        children: [
          Container(
            color: Colors.white,
            child: art(
              'detail-art',
              height: 240,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 16),
            child: Column(
              children: [
                const Text(
                  'Gift Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const StepDots(2, connected: true),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    '\$${s.amount.toStringAsFixed(s.amount % 1 == 0 ? 0 : 2)}  ◉',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FundLabel(text: 'Give to ${s.campaign.title}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _option(
                        'Edit amount',
                        Icons.add,
                        () => go(context, '/gift'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _option(
                        s.frequency == 'One time'
                            ? 'Set Recurring'
                            : s.frequency,
                        Icons.add,
                        () async {
                          final value = await frequencySheet(
                            context,
                            selected: s.frequency,
                          );
                          if (value != null) {
                            s.frequency = value;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: TextField(
                    controller: message,
                    onChanged: (value) => s.message = value,
                    maxLines: 3,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      hintText: 'Add Message',
                      counterText: '',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Preview donation · no real money is transferred',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _option(String text, IconData icon, VoidCallback tap) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: canvas,
              child: Icon(icon, size: 18, color: ink),
            ),
            const SizedBox(width: 6),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
          ],
        ),
      ),
    ),
  );
}

class WalletPage extends StatefulWidget {
  final bool payment;
  const WalletPage({super.key, this.payment = false});
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool paying = false;
  Future<void> pay() async {
    if (paying) return;
    setState(() => paying = true);
    try {
      await AppScope.of(context).donate();
      if (mounted) Navigator.pushReplacementNamed(context, '/receipt');
    } catch (_) {
      if (mounted) {
        toast(context, 'Unable to save your demo gift. Please try again.');
        setState(() => paying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      title: widget.payment ? 'Payment method' : 'Wallet',
      bottom: widget.payment
          ? PrimaryButton(
              paying ? 'Processing...' : 'Pay Now',
              onPressed: paying ? null : pay,
            )
          : null,
      child: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Text('Your Cards', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 18),
          for (final (i, card) in s.cards.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    s.selectedCard = i;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.payment && s.selectedCard == i
                            ? purple
                            : const Color(0xFFEEEEEE),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _cardIcon(i),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.split(' •').first,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${card.split(' ').last} xxx xxx xxxx xxx',
                                style: const TextStyle(
                                  color: Color(0xFFBDBDBD),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.payment)
                          Icon(
                            s.selectedCard == i
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: s.selectedCard == i
                                ? purple
                                : const Color(0xFFBDBDBD),
                            size: 21,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Add Payment method',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEEEEEE)),
              foregroundColor: ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 60),
            ),
            onPressed: () async {
              final last4 = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const AddCardSheet(),
              );
              if (last4 != null) {
                s.cards.add('Demo Card •••• $last4');
                s.save();
                s.selectedCard = s.cards.length - 1;
                setState(() {});
              }
            },
            child: Row(
              children: [
                _cardIcon(1),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Credit or debit card',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                const Text(
                  '+ Add',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          if (widget.payment) ...[
            const SizedBox(height: 24),
            Text(
              'Demo gift: \$${s.amount.toStringAsFixed(2)} · ${s.frequency}',
              style: const TextStyle(color: muted, fontSize: 12),
            ),
            const SizedBox(height: 6),
            const Text(
              'Uses a simulated card. No charge will be made.',
              style: TextStyle(color: muted, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cardIcon(int i) => SizedBox(
    width: 34,
    height: 26,
    child: i == 0
        ? const Center(
            child: Text(
              'VISA',
              style: TextStyle(
                color: Color(0xFF283593),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          )
        : i == 1
        ? const Stack(
            children: [
              Positioned(
                left: 0,
                top: 3,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFFEB001B),
                ),
              ),
              Positioned(
                right: 3,
                top: 3,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xDDFF9900),
                ),
              ),
            ],
          )
        : Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF20A8D1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'AMEX',
              style: TextStyle(fontSize: 9, color: Colors.white),
            ),
          ),
  );
}

class AddCardSheet extends StatefulWidget {
  const AddCardSheet({super.key});
  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final form = GlobalKey<FormState>(), number = TextEditingController();
  @override
  void dispose() {
    number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      30,
      28,
      30,
      MediaQuery.viewInsetsOf(context).bottom + 30,
    ),
    child: Form(
      key: form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a demo card',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const Text(
            'Only the last 4 digits are used in this preview.\nDo not enter real payment information.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: number,
            keyboardType: TextInputType.number,
            maxLength: 4,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Last 4 digits',
              counterText: '',
            ),
            validator: (v) => v?.length == 4 ? null : 'Enter exactly 4 digits',
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            'Add card',
            onPressed: () {
              if (form.currentState!.validate()) {
                Navigator.pop(context, number.text);
              }
            },
          ),
        ],
      ),
    ),
  );
}

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});
  @override
  Widget build(BuildContext context) {
    final gift =
        ModalRoute.of(context)?.settings.arguments as Donation? ??
        AppScope.of(context).lastDonation;
    return Scaffold(
      backgroundColor: const Color(0xFF424242),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: 'Close receipt',
                      onPressed: () => home(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: lime,
                    child: Icon(Icons.check, size: 52, color: ink),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    gift == null ? 'No donation yet' : 'Transfer Success',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    gift == null
                        ? 'Make your first gift and see the impact.'
                        : 'Your demo gift has been recorded for\n${gift.title}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: muted),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '\$${(gift?.amount ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recipient',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: canvas,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const OrganizationLogo(index: 4, size: 44),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gift?.title ?? 'Organization Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                gift == null
                                    ? 'No transaction'
                                    : '${gift.date.year}-${gift.date.month.toString().padLeft(2, '0')}-${gift.date.day.toString().padLeft(2, '0')} · ${gift.frequency}',
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (gift != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Reference: ${gift.id}\nDemo receipt · no real payment',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: muted, fontSize: 10),
                      ),
                    ),
                  const SizedBox(height: 28),
                  PrimaryButton('Go Home', onPressed: () => home(context)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
