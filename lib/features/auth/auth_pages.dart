import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_store.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  int index = 0;
  final titles = [
    'Help turn\ninnovative ideas\ninto reality',
    'Be a part of\nsomething\nbigger.',
    'Change the\nworld with your\ncontributions.',
  ];
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void finish() {
    final s = AppScope.of(context);
    s.onboarded = true;
    s.save();
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        PageView.builder(
          controller: controller,
          itemCount: 3,
          onPageChanged: (i) => setState(() => index = i),
          itemBuilder: (context, i) => LayoutBuilder(
            builder: (context, box) {
              final image = ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                child: art(
                  'onboarding-${i + 1}',
                  width: double.infinity,
                  height: box.maxHeight * .53,
                ),
              );
              final text = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'AIR FUNDING',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    titles[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: box.maxWidth < 350 ? 30 : 38,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  StepDots(i),
                ],
              );
              return i == 1
                  ? Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: art(
                            'onboarding-2',
                            height: box.maxHeight * .56,
                          ),
                        ),
                        Container(
                          height: box.maxHeight * .49,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(32),
                            ),
                          ),
                          child: SafeArea(child: Center(child: text)),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        image,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 90),
                            child: Center(child: text),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 4,
          right: 12,
          child: TextButton(
            onPressed: finish,
            child: Text(
              'Skip',
              style: TextStyle(
                color: index == 0 || index == 2 ? Colors.white : muted,
              ),
            ),
          ),
        ),
        Positioned(
          left: 30,
          right: 30,
          bottom: MediaQuery.paddingOf(context).bottom + 24,
          child: PrimaryButton(
            index == 2 ? 'Get Started' : 'Next',
            onPressed: () {
              if (index == 2) {
                finish();
              } else {
                controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            art('welcome', width: double.infinity, height: 240),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Text(
                    'Welcome to Filllo',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Create an account to support the causes\nand communities you care about.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  for (final provider in ['Google', 'Apple', 'Facebook'])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ink,
                          side: const BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Continue with $provider'),
                            content: const Text(
                              'This preview uses a local demo account. No external account will be connected.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  final s = AppScope.of(context);
                                  s.signedIn = true;
                                  s.save();
                                  home(context);
                                },
                                child: const Text('Try demo'),
                              ),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              provider == 'Apple'
                                  ? Icons.apple
                                  : provider == 'Facebook'
                                  ? Icons.facebook
                                  : Icons.g_mobiledata,
                              color: provider == 'Apple' ? ink : Colors.blue,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text('Continue with $provider'),
                          ],
                        ),
                      ),
                    ),
                  PrimaryButton(
                    'Sign up with Email',
                    onPressed: () => go(context, '/signup'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => go(context, '/signin'),
                    child: const Text('Already a subscriber? Log In'),
                  ),
                  TextButton(
                    onPressed: () => go(context, '/home'),
                    child: const Text(
                      'Explore as a guest',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                  const Text(
                    'By continuing, you agree to use this local demo.\nNo real donations or account registration.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class AuthPage extends StatefulWidget {
  final bool signUp;
  const AuthPage({super.key, this.signUp = false});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController();
  bool hidden = true;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    final s = AppScope.of(context);
    s.email = email.text.trim();
    if (widget.signUp) {
      s.name = name.text.trim();
      go(context, '/verify');
    } else {
      s.signedIn = true;
      s.save();
      home(context);
    }
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.signUp ? 'Sign up' : '',
    child: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        children: [
          if (!widget.signUp) ...[
            Text(
              'Welcome to Filllo',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Sign in to continue your giving journey.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 32),
          ],
          if (widget.signUp) ...[
            const Text('Name'),
            const SizedBox(height: 10),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(hintText: 'Your full name'),
              validator: (v) => v!.trim().isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 22),
          ],
          const Text('Email'),
          const SizedBox(height: 10),
          TextFormField(
            key: const Key('email'),
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'example@gmail.com',
              prefixIcon: Icon(Icons.mail_outline, size: 20),
            ),
            validator: (v) =>
                RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v!.trim())
                ? null
                : 'Enter a valid email',
          ),
          const SizedBox(height: 22),
          const Text('Password'),
          const SizedBox(height: 10),
          TextFormField(
            key: const Key('password'),
            controller: password,
            obscureText: hidden,
            decoration: InputDecoration(
              hintText: '••••••••',
              suffixIcon: IconButton(
                tooltip: 'Show password',
                onPressed: () => setState(() => hidden = !hidden),
                icon: Icon(
                  hidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.length < 8) return 'Use at least 8 characters';
              if (widget.signUp &&
                  [
                        RegExp('[a-z]'),
                        RegExp('[A-Z]'),
                        RegExp('[0-9]'),
                        RegExp(r'[^a-zA-Z0-9]'),
                      ].where((r) => r.hasMatch(v)).length <
                      3) {
                return 'Use at least 3 character types';
              }
              return null;
            },
          ),
          if (widget.signUp) ...[
            const SizedBox(height: 14),
            const Text(
              '(8+ characters)*',
              style: TextStyle(color: muted, fontSize: 12),
            ),
            const SizedBox(height: 24),
            const Text(
              'An 8 character password is required, with at least 3 of the following:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: canvas,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                '• 1 lower-case character\n• 1 upper-case character\n• 1 number\n• 1 special character',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
          if (!widget.signUp)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => go(context, '/forgot'),
                child: const Text('Forgot password?'),
              ),
            ),
          SizedBox(height: widget.signUp ? 42 : 100),
          PrimaryButton(
            widget.signUp ? 'Sign up' : 'Sign in',
            onPressed: submit,
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              widget.signUp ? '/signin' : '/signup',
            ),
            child: Text(
              widget.signUp
                  ? 'Already a subscriber? Log In'
                  : "Don't have an account yet? Sign Up",
            ),
          ),
          const Text(
            'Demo mode · use any valid email and password',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final controllers = List.generate(4, (_) => TextEditingController());
  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '',
    child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFFFFF4F2),
          child: Icon(Icons.send, color: coral, size: 30),
        ),
        const SizedBox(height: 18),
        Text(
          'Verification Code',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter the demo code sent to your email.\nDemo verification code: 1234',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 32),
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: TextField(
                  controller: controllers[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '-',
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 3) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 42),
        TextButton(
          onPressed: () => toast(context, 'Demo code: 1234'),
          child: const Text('01:59  Resend'),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          'Verify Code',
          onPressed: () {
            if (controllers.map((c) => c.text).join() != '1234') {
              toast(context, 'Enter the demo code 1234');
              return;
            }
            final s = AppScope.of(context);
            s.signedIn = true;
            s.save();
            home(context);
          },
        ),
      ],
    ),
  );
}

class ForgotPage extends StatelessWidget {
  const ForgotPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Reset password',
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 36),
          Text(
            'A fresh start.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'This demo has no remote account. You can sign in using any valid email and an 8 character password.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            'Back to sign in',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}

class FundraiseForPage extends StatefulWidget {
  const FundraiseForPage({super.key});
  @override
  State<FundraiseForPage> createState() => _FundraiseForPageState();
}

class _FundraiseForPageState extends State<FundraiseForPage> {
  String selected = 'Yourself';
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Start a fundraiser',
    bottom: PrimaryButton(
      'Continue',
      onPressed: () {
        AppScope.of(context).fundraiserFor = selected;
        go(context, '/fundraise-details');
      },
    ),
    child: ListView(
      padding: const EdgeInsets.all(30),
      children: [
        Center(child: art('brand', width: 76, height: 76)),
        const SizedBox(height: 14),
        const Text(
          'Who are you\nfundraising for?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 26),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: .94,
          children: [
            for (final (label, icon) in [
              ('Yourself', Icons.volunteer_activism_outlined),
              ('Someone else', Icons.waving_hand_outlined),
              ('Charity', Icons.savings_outlined),
              ('Other', Icons.recycling),
            ])
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => selected = label),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected == label
                          ? purple
                          : const Color(0xFFEEEEEE),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 42,
                        color: selected == label ? ink : muted,
                      ),
                      const SizedBox(height: 14),
                      Text(label),
                      if (selected == label) const CheckBadge(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

class FundraiseDetailsPage extends StatefulWidget {
  const FundraiseDetailsPage({super.key});
  @override
  State<FundraiseDetailsPage> createState() => _FundraiseDetailsPageState();
}

class _FundraiseDetailsPageState extends State<FundraiseDetailsPage> {
  final title = TextEditingController();
  String category = 'Animals';
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final store = AppScope.of(context);
      title.text = store.fundraiserTitle;
      category = store.fundraiserCategory;
      initialized = true;
    }
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  Future<void> select() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select a category',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  for (final c in [
                    'Animals',
                    'Travel',
                    'Medical',
                    'Business',
                    'Community',
                    'Family',
                    'Creative',
                    'Faith',
                  ])
                    ChoiceChip(
                      label: Text(c),
                      selected: category == c,
                      onSelected: (_) => Navigator.pop(ctx, c),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null) setState(() => category = result);
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Fundraise details',
    bottom: PrimaryButton(
      'Continue',
      onPressed: () {
        if (title.text.trim().isEmpty) {
          toast(context, 'Add a title for your fundraiser');
          return;
        }
        final s = AppScope.of(context);
        s.fundraiserTitle = title.text.trim();
        s.fundraiserCategory = category;
        s.save();
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Your draft is ready'),
            content: Text(
              '${s.fundraiserTitle}\nFor: ${s.fundraiserFor}\nCategory: $category\n\nThis local draft has not been published.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  home(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    ),
    child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 30),
        TextField(
          controller: title,
          decoration: const InputDecoration(
            hintText: 'Give your fundraiser a title',
          ),
        ),
        const SizedBox(height: 36),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: muted,
            side: const BorderSide(color: Color(0xFFE5E5E5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: select,
          child: Row(
            children: [
              Expanded(child: Text(category)),
              const Icon(Icons.expand_more, size: 18),
            ],
          ),
        ),
      ],
    ),
  );
}
