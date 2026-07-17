import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'raw_asset_image.dart';

void main() {
  runApp(const AthmarApp());
}

// Design colors (from Alinma reference screenshots)
const kNavy = Color(0xFF1B2B42);
const kCream = Color(0xFFFBF5EF);
const kCreamTop = Color(0xFFF8E7DB);
const kPill = Color(0xFFF1E5D8);
const kHint = Color(0xFF9AA1AA);
const kGreen = Color(0xFF57A15F);
const kCardWhite = Colors.white;

class AthmarApp extends StatelessWidget {
  const AthmarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: kCream,
      fontFamily: 'IBM Plex Sans Arabic',
    );
    return MaterialApp(
      title: 'أثمر',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      locale: const Locale('ar'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: PhoneFrame(child: child ?? const SizedBox()),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/services': (_) => const ServicesScreen(),
        '/athmar': (_) => const AthmarWelcomeScreen(),
        '/athmar/journey': (_) => const AthmarSavingsSetupScreen(),
        '/athmar/goal': (_) => const GoalScreen(amount: 10000, months: 20),
        '/athmar/plant': (_) =>
            const PlantScreen(goal: 'زواج', amount: 10000, months: 2),
        '/athmar/advisor': (_) => const AdvisorChatScreen(),
        '/athmar/tracker': (_) =>
            const TrackerScreen(goal: 'طوارئ', amount: 10000, months: 2),
        '/athmar/next': (_) => const AthmarPlaceholderPage(),
      },
    );
  }
}

/// Centers the app and frames it like a mobile phone in the web preview.
class PhoneFrame extends StatelessWidget {
  final Widget child;
  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9EDF2),
      alignment: Alignment.center,
      child: LayoutBuilder(builder: (context, c) {
        // If the viewport is already phone-like, fill it.
        if (c.maxWidth <= 500) return child;
        final h = c.maxHeight - 32;
        final w = h * (430 / 880);
        return Container(
          width: w + 20,
          height: h + 20,
          decoration: BoxDecoration(
            color: const Color(0xFF3A3A3C),
            borderRadius: BorderRadius.circular(44),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 12)),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: SizedBox(
              width: w,
              height: h,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: 430,
                  height: 430 * h / w,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        size: Size(430, 430 * h / w)),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class StatusBar extends StatelessWidget {
  final String time;
  const StatusBar({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        child: Row(
          children: [
            Text(time,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15, color: kNavy)),
            const Spacer(),
            const Icon(Icons.signal_cellular_alt, size: 16, color: kNavy),
            const SizedBox(width: 5),
            const Icon(Icons.wifi, size: 16, color: kNavy),
            const SizedBox(width: 5),
            const Icon(Icons.battery_5_bar, size: 16, color: kNavy),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Login screen
// ---------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  void _login() {
    Navigator.of(context).pushNamed('/services');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kCreamTop, kCream],
            stops: [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const StatusBar(time: '7:03'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _topRow(),
                      const SizedBox(height: 28),
                      const Text(
                        'مرحباً بك في الإنماء',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: kNavy,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _inputField(
                        controller: _username,
                        hint: 'اسم المستخدم أو رقم الهوية',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 14),
                      _inputField(
                        controller: _password,
                        hint: 'كلمة المرور',
                        icon: Icons.lock_outline,
                        obscure: true,
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('تذكرني',
                              style: TextStyle(
                                  color: kNavy,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 10),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: const Color(0xFFD8DCE1), width: 1.4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kNavy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'IBM Plex Sans Arabic')),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Center(
                        child: Text('نسيت اسم المستخدم او كلمة المرور ؟',
                            style: TextStyle(
                                color: kNavy,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 42),
                      const Center(
                        child: Text('فتح حساب أو التسجيل',
                            style: TextStyle(
                                color: kNavy,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      children: [
        // Alinma logo (right side in RTL = first child)
        const RawAssetImage('assets/images/alinma_logo.png',
            width: 46, height: 46),
        const Spacer(),
        _pill(
          child: const Icon(Icons.apps, size: 18, color: kNavy),
        ),
        const SizedBox(width: 8),
        _pill(
          child: const Icon(Icons.location_on_outlined, size: 18, color: kNavy),
        ),
        const SizedBox(width: 8),
        _pill(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.language, size: 18, color: kNavy),
              SizedBox(width: 5),
              Text('En',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pill({required Widget child}) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kPill,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboard,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: kNavy, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboard,
              style: const TextStyle(
                  color: kNavy, fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hint,
                hintStyle: const TextStyle(
                    color: kHint, fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('اتصل بنا',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text('|', style: TextStyle(color: kHint)),
              Text('الإيقاف الطارئ',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE7DCD0)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('جميع الحقوق محفوظة، الإنماء 2026',
              style: TextStyle(
                  color: kNavy.withValues(alpha: 0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Services screen
// ---------------------------------------------------------------------------
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const _services = [
    _Service('الحسابات', Icons.person_outline),
    _Service('البطاقات', Icons.credit_card),
    _Service('التمويل', Icons.paid_outlined),
    _Service('الإدخار', Icons.savings_outlined),
    _Service('الاستثمار', Icons.insert_chart_outlined_rounded),
    _Service('العائلة', Icons.groups_outlined),
    _Service('أكثر', Icons.auto_awesome, color: Color(0xFF7B6CF6)),
    _Service('الشهادات', Icons.article_outlined),
    _Service('متابعة الطلبات', Icons.content_paste_search_outlined),
    _Service('التأمين', Icons.health_and_safety_outlined),
    _Service('أثمر', null, isAthmar: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(time: '2:12'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kPill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('هـ',
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  const Text('هديل',
                      style: TextStyle(
                          color: kNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  const BackChip(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.18,
                      children: [
                        for (final s in _services) _ServiceCard(service: s),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _quickList(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _quickList() {
    const items = [
      ('النقد الطارئ', Icons.local_atm_outlined),
      ('محول العملات', Icons.currency_exchange),
      ('أسعار صرف العملات', Icons.paid_outlined),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(
                  height: 1, indent: 18, endIndent: 18, color: Color(0xFFF0EAE2)),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Row(
                children: [
                  Icon(items[i].$2, color: kNavy, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(items[i].$1,
                        style: const TextStyle(
                            color: kNavy,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                  const Icon(Icons.chevron_left, color: kHint, size: 20),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Service {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isAthmar;
  const _Service(this.label, this.icon, {this.color, this.isAthmar = false});
}

class _ServiceCard extends StatelessWidget {
  final _Service service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: kCardWhite,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (service.isAthmar)
            const RawAssetImage('assets/images/athmar_sprout.png',
                width: 21, height: 30)
          else
            Icon(service.icon, color: service.color ?? kNavy, size: 26),
          const SizedBox(height: 10),
          Text(service.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: kNavy, fontSize: 13.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );

    if (!service.isAthmar) return card;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed('/athmar'),
      child: card,
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('الرئيسية', Icons.account_balance_outlined, false),
      ('التحويل', Icons.swap_horiz, false),
      ('المدفوعات', Icons.receipt_long_outlined, false),
      ('المتجر', Icons.storefront_outlined, false),
      ('الخدمات', Icons.apps, true),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFE8E0))),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      child: Row(
        children: [
          for (final it in items)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(it.$2,
                      size: 24,
                      color: it.$3 ? kNavy : const Color(0xFFA9AFB8)),
                  const SizedBox(height: 4),
                  Text(it.$1,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight:
                            it.$3 ? FontWeight.w700 : FontWeight.w500,
                        color: it.$3 ? kNavy : const Color(0xFFA9AFB8),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// أثمر welcome screen (after tapping the أثمر card)
// ---------------------------------------------------------------------------
const kBlushCard = Color(0xFFF2D7C7);
const kSalmon = Color(0xFFE7A891);

class AthmarWelcomeScreen extends StatelessWidget {
  const AthmarWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(time: '2:12'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kPill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('هـ',
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  const Text('هديل',
                      style: TextStyle(
                          color: kNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  const BackChip(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    const Text('مرحبًا بك في',
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    const Text('أثمر',
                        style: TextStyle(
                            color: kSalmon,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            height: 1.2)),
                    const SizedBox(height: 22),
                    const Text(
                      'من بذرة ادخار صغيرة، تبدأ رحلتك\nنحو تحقيق أهدافك المالية.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kNavy,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          height: 1.6),
                    ),
                    const SizedBox(height: 34),
                    const RawAssetImage('assets/images/athmar_sprout.png',
                        width: 68, height: 96),
                    const SizedBox(height: 44),
                    _featuresCard(),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/athmar/journey'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPill,
                          foregroundColor: kNavy,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('ابدأ رحلتك',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'IBM Plex Sans Arabic')),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _featuresCard() {
    const rows = [
      ('حدّد هدفك', 'اختر ما تريد تحقيقه', Icons.track_changes),
      ('ادخر بسهولة', 'بطريقة تناسبك', Icons.account_balance_wallet_outlined),
      ('شاهد نبتتك تنمو', 'مع كل ادخار', Icons.energy_savings_leaf_outlined),
    ];
    return Container(
      decoration: BoxDecoration(
        color: kBlushCard,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                  height: 1,
                  color: kNavy.withValues(alpha: 0.12)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Icon(rows[i].$3, color: kNavy, size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rows[i].$1,
                            style: const TextStyle(
                                color: kNavy,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(rows[i].$2,
                            style: TextStyle(
                                color: kNavy.withValues(alpha: 0.65),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// كم ترغب في الادخار؟ — savings amount/duration setup
// ---------------------------------------------------------------------------
const kGrayCard = Color(0xFFD6D6D6);
const kBlushHelp = Color(0xFFEDD2C2);

class AthmarSavingsSetupScreen extends StatefulWidget {
  const AthmarSavingsSetupScreen({super.key});

  @override
  State<AthmarSavingsSetupScreen> createState() =>
      _AthmarSavingsSetupScreenState();
}

class _AthmarSavingsSetupScreenState extends State<AthmarSavingsSetupScreen> {
  double _amount = 10000;
  double _months = 20;

  String _fmt(num n) {
    final s = n.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final monthly = _amount / _months;
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(time: '2:12'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kPill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('هـ',
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  const Text('هديل',
                      style: TextStyle(
                          color: kNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  const BackChip(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text('كم ترغب في\nالادخار؟',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.25)),
                    const SizedBox(height: 8),
                    const Text(
                      'اختر المبلغ الذي تريد البدء به\nيمكنك التعديل لاحقًا في أي وقت.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kSalmon,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: kGrayCard,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        children: [
                          const Text('المبلغ',
                              style: TextStyle(
                                  color: kNavy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          _bigValue(_fmt(_amount), 'ريال'),
                          _slider(
                            value: _amount,
                            min: 100,
                            max: 500000,
                            onChanged: (v) => setState(() => _amount = v),
                          ),
                          _rangeLabels('100', '500,000'),
                          const SizedBox(height: 8),
                          const Text('المدة',
                              style: TextStyle(
                                  color: kNavy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          _bigValue(_fmt(_months), 'شهر'),
                          _slider(
                            value: _months,
                            min: 1,
                            max: 60,
                            onChanged: (v) =>
                                setState(() => _months = v.roundToDouble()),
                          ),
                          _rangeLabels('1', '60 شهر'),
                          const SizedBox(height: 8),
                          const Text('الادخار الشهري المتوقع',
                              style: TextStyle(
                                  color: kNavy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          _bigValue(_fmt(monthly), 'ريال'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/athmar/advisor'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kBlushHelp,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('تبغى مساعدة ؟',
                                      style: TextStyle(
                                          color: kNavy,
                                          fontSize: 10.5,
                                          height: 1.2,
                                          fontWeight: FontWeight.w700)),
                                  Text('استشر مزارعنا الذكي',
                                      style: TextStyle(
                                          color: kNavy.withValues(alpha: 0.7),
                                          fontSize: 9,
                                          height: 1.2,
                                          fontWeight: FontWeight.w500)),
                                  const Icon(Icons.arrow_back,
                                      color: kNavy, size: 11),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const RawAssetImage(
                                'assets/images/athmar_farmer.png',
                                width: 20, height: 33),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GoalScreen(
                              amount: _amount.round(),
                              months: _months.round(),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPill,
                          foregroundColor: kNavy,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('التالي',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'IBM Plex Sans Arabic')),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _bigValue(String value, String unit) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: kNavy,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.2)),
        Text(unit,
            style: TextStyle(
                color: kNavy.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _slider({
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 6,
          activeTrackColor: kSalmon,
          inactiveTrackColor: kCream,
          thumbColor: kSalmon,
          overlayColor: kSalmon.withValues(alpha: 0.15),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        ),
        child: Slider(value: value, min: min, max: max, onChanged: onChanged),
      ),
    );
  }

  Widget _rangeLabels(String lo, String hi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lo,
                style: TextStyle(
                    color: kNavy.withValues(alpha: 0.5), fontSize: 11)),
            Text(hi,
                style: TextStyle(
                    color: kNavy.withValues(alpha: 0.5), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ما هدفك من الادخار؟ — goal selection
// ---------------------------------------------------------------------------
const kTileGray = Color(0xFFD9D9D9);

/// Back button chip — same corner and style on every page.
class BackChip extends StatelessWidget {
  const BackChip({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: kPill,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.arrow_back,
            color: kNavy, size: 20, textDirection: TextDirection.ltr),
      ),
    );
  }
}

class HadeelBadge extends StatelessWidget {
  const HadeelBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kPill,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text('هـ',
              style: TextStyle(
                  color: kNavy, fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 10),
        const Text('هديل',
            style: TextStyle(
                color: kNavy, fontSize: 18, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key, required this.amount, required this.months});

  final int amount;
  final int months;

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  // Order matches the mockup grid (first item of each pair sits on the right).
  static const _goals = [
    ('طوارئ', 'goal_cash'),
    ('سفرة', 'goal_plane'),
    ('زواج', 'goal_couple'),
    ('سيارة', 'goal_car'),
    ('بيت', 'goal_house'),
  ];

  int? _selected; // 0..4 preset, 5 = custom
  final TextEditingController _custom = TextEditingController();
  final FocusNode _customFocus = FocusNode();

  @override
  void dispose() {
    _custom.dispose();
    _customFocus.dispose();
    super.dispose();
  }

  String? get _goalName {
    if (_selected == null) return null;
    if (_selected == 5) {
      final t = _custom.text.trim();
      return t.isEmpty ? null : t;
    }
    return _goals[_selected!].$1;
  }

  void _next() {
    final goal = _goalName;
    if (goal == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlantScreen(
          goal: goal,
          amount: widget.amount,
          months: widget.months,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(time: '2:12'),
            const SizedBox(height: 2),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [HadeelBadge(), BackChip()],
              ),
            ),
            const SizedBox(height: 14),
            const Text('ما هدفك من\nالأدخار؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kNavy,
                    fontSize: 26,
                    height: 1.25,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Tile order per mockup; last row: custom goal right, بيت left.
                    const SizedBox(height: 4),
                    for (final pair in const [
                      [0, 1],
                      [2, 3],
                      [5, 4],
                    ]) ...[
                      Row(
                        children: [
                          Expanded(child: _tile(pair[0])),
                          const SizedBox(width: 16),
                          Expanded(child: _tile(pair[1])),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _goalName == null ? null : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPill,
                    disabledBackgroundColor: kPill.withValues(alpha: 0.55),
                    foregroundColor: kNavy,
                    disabledForegroundColor: kNavy.withValues(alpha: 0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('التالي',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'IBM Plex Sans Arabic')),
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _tile(int index) {
    final selected = _selected == index;
    final border = selected
        ? Border.all(color: kNavy, width: 2)
        : Border.all(color: Colors.transparent, width: 2);
    if (index == 5) {
      return GestureDetector(
        onTap: () {
          setState(() => _selected = 5);
          _customFocus.requestFocus();
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: kTileGray,
            borderRadius: BorderRadius.circular(28),
            border: border,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RawAssetImage('assets/images/goal_pencil.png',
                  width: 38, height: 26),
              const SizedBox(height: 2),
              const Text('هدف مخصص',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 13,
                      fontWeight: FontWeight.w800)),
              Text('-اكتب هدفك',
                  style: TextStyle(
                      color: kNavy.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 3),
              Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _custom,
                  focusNode: _customFocus,
                  maxLength: 100,
                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                  onTap: () => setState(() => _selected = 5),
                  onChanged: (_) => setState(() {}),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: kNavy,
                  cursorHeight: 13,
                  style: const TextStyle(
                      color: kNavy,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBM Plex Sans Arabic'),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 7),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final (label, asset) = _goals[index];
    return GestureDetector(
      onTap: () => setState(() => _selected = index),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: kTileGray,
          borderRadius: BorderRadius.circular(28),
          border: border,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawAssetImage('assets/images/$asset.png', width: 78, height: 48),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(
                    color: kNavy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// بطاقة النبتة — plant chosen by AI from the saving duration
// ---------------------------------------------------------------------------
class PlantScreen extends StatefulWidget {
  const PlantScreen(
      {super.key,
      required this.goal,
      required this.amount,
      required this.months});

  final String goal;
  final int amount;
  final int months;

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  // Only lavender exists for now; later plants map to other durations.
  static const _plantName = 'الخزامى';
  static const _growth = '2-1 شهر';

  String? _reason;

  @override
  void initState() {
    super.initState();
    _loadReason();
  }

  String get _fallbackReason =>
      'لأنك اخترت هدف "${widget.goal}" لمدة ${widget.months} شهر فنبتة الخزامى هي المناسبة لك إذ تنمو سريعًا وتعكس حماسك للقرب من تحقيق هدفك';

  Future<void> _loadReason() async {
    try {
      final resp = await http
          .post(
            Uri.base.resolve('/api/advisor/plant'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'goal': widget.goal,
              'amount': widget.amount,
              'months': widget.months,
            }),
          )
          .timeout(const Duration(seconds: 30));
      String reason = '';
      if (resp.statusCode == 200) {
        reason = (jsonDecode(utf8.decode(resp.bodyBytes))
                as Map<String, dynamic>)['reason'] as String? ??
            '';
      }
      if (mounted) {
        setState(() => _reason = reason.isEmpty ? _fallbackReason : reason);
      }
    } catch (_) {
      if (mounted) setState(() => _reason = _fallbackReason);
    }
  }

  String _fmtInt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      b.write(s[i]);
      final left = s.length - i - 1;
      if (left > 0 && left % 3 == 0) b.write(',');
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(time: '2:12'),
            const SizedBox(height: 2),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [HadeelBadge(), BackChip()],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 24,
                            height: 1.35,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'IBM Plex Sans Arabic'),
                        children: [
                          TextSpan(
                              text: 'نبتتك ', style: TextStyle(color: kNavy)),
                          TextSpan(
                              text: 'الأولى\n',
                              style: TextStyle(color: kSalmon)),
                          TextSpan(
                              text: 'ستكون', style: TextStyle(color: kNavy)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('⟩',
                            style: TextStyle(
                                color: kSalmon.withValues(alpha: 0.8),
                                fontSize: 18)),
                        const SizedBox(width: 10),
                        const Text(_plantName,
                            style: TextStyle(
                                color: kSalmon,
                                fontSize: 24,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(width: 10),
                        Text('⟨',
                            style: TextStyle(
                                color: kSalmon.withValues(alpha: 0.8),
                                fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text('كلما ادخرت اكثر, نبتتك ستكبر\nوتزهر بوقتك الجميل.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 12.5,
                            height: 1.6,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    const RawAssetImage('assets/images/plant_lavender.png',
                        width: 100, height: 107),
                    const SizedBox(height: 20),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kBlushHelp,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          child: _reason == null
                              ? const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: kNavy),
                                  ),
                                )
                              : Text(_reason!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: kNavy,
                                      fontSize: 12.5,
                                      height: 1.7,
                                      fontWeight: FontWeight.w600)),
                        ),
                        const PositionedDirectional(
                          top: -9,
                          start: 16,
                          child: RawAssetImage(
                              'assets/images/plant_stamp.png',
                              width: 40, height: 19),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kTileGray,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: _summaryCol('نوع النبتة', _plantName)),
                          _divider(),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('المبلغ',
                                    style: TextStyle(
                                        color: kNavy,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(_fmtInt(widget.amount),
                                    style: const TextStyle(
                                        color: kNavy,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                                Text('ريال',
                                    style: TextStyle(
                                        color: kNavy.withValues(alpha: 0.6),
                                        fontSize: 10)),
                              ],
                            ),
                          ),
                          _divider(),
                          Expanded(
                              child:
                                  _summaryCol('وقت النمو المتوقع', _growth)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const RawAssetImage('assets/images/athmar_sprout.png',
                            width: 24, height: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                              'كلما زاد مبلغ ادخارك, تحصل على نبتة سعودية اكبر وتستغرق وقتًا اطول لتنمو وتزهر.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kSalmon.withValues(alpha: 0.95),
                                  fontSize: 11.5,
                                  height: 1.6,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => TrackerScreen(
                                  goal: widget.goal,
                                  amount: widget.amount,
                                  months: widget.months)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlushHelp,
                          foregroundColor: kNavy,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('ابدأ الأدخار',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'IBM Plex Sans Arabic')),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 52,
        color: kNavy.withValues(alpha: 0.15),
        margin: const EdgeInsets.symmetric(horizontal: 6),
      );

  Widget _summaryCol(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: kNavy, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: kSalmon, fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// محادثة المزارع الذكي — AI financial advisor chat
// ---------------------------------------------------------------------------
const kUserBubble = Color(0xFFDEB197);

class _ChatMessage {
  _ChatMessage(this.role, this.content);
  final String role; // 'user' | 'assistant'
  final String content;
}

class AdvisorChatScreen extends StatefulWidget {
  const AdvisorChatScreen({super.key});

  @override
  State<AdvisorChatScreen> createState() => _AdvisorChatScreenState();
}

class _AdvisorChatScreenState extends State<AdvisorChatScreen> {
  final List<_ChatMessage> _messages = [
    _ChatMessage('assistant',
        'اهلًا أنا المزارع الذكي ! صديقك في رحلة الادخار في أثمر\nسواء كنت محتار بمبلغ الادخار او عندك اي استفسار آخر (اكتبه لي)'),
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _sending = false;
  bool _showSuggestions = true;

  static const _suggestions = [
    'كم أدخر شهريًا؟',
    'اقترح لي هدف ادخار',
    'هل مبلغي مناسب؟',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _sending) return;
    setState(() {
      _messages.add(_ChatMessage('user', trimmed));
      _sending = true;
      _showSuggestions = false;
      _controller.clear();
    });
    _scrollToEnd();
    try {
      final resp = await http
          .post(
            Uri.base.resolve('/api/advisor/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'messages': _messages
                  .map((m) => {'role': m.role, 'content': m.content})
                  .toList(),
            }),
          )
          .timeout(const Duration(seconds: 60));
      String reply;
      if (resp.statusCode == 200) {
        reply = (jsonDecode(utf8.decode(resp.bodyBytes))
                as Map<String, dynamic>)['reply'] as String? ??
            '';
      } else {
        reply = 'عذرًا، صار خلل بسيط. جرّب مرة ثانية.';
      }
      if (reply.isEmpty) reply = 'عذرًا، ما وصلني رد. جرّب مرة ثانية.';
      if (mounted) {
        setState(() => _messages.add(_ChatMessage('assistant', reply)));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _messages
            .add(_ChatMessage('assistant', 'تعذّر الاتصال، جرّب مرة ثانية.')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(time: '2:12'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kPill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('هـ',
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  const Text('هديل',
                      style: TextStyle(
                          color: kNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  const BackChip(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemCount: _messages.length + (_sending ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == _messages.length) {
                    return _assistantRow(const _TypingDots());
                  }
                  final m = _messages[i];
                  if (m.role == 'assistant') {
                    return _assistantRow(_bubble(m.content, kBlushHelp));
                  }
                  return _userRow(_bubble(m.content, kUserBubble));
                },
              ),
            ),
            if (_showSuggestions)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in _suggestions)
                      GestureDetector(
                        onTap: () => _send(s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: kPill,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(s,
                              style: const TextStyle(
                                  color: kNavy,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: kPill, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _send,
                        textInputAction: TextInputAction.send,
                        style: const TextStyle(
                            color: kNavy,
                            fontSize: 13.5,
                            fontFamily: 'IBM Plex Sans Arabic'),
                        decoration: const InputDecoration(
                          hintText: 'اكتب سؤالك للمزارع الذكي...',
                          hintStyle: TextStyle(color: kHint, fontSize: 12.5),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _send(_controller.text),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _sending ? kHint : kNavy,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_upward,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _assistantRow(Widget bubble) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RawAssetImage('assets/images/athmar_farmer_chat.png',
                width: 30, height: 45),
            const SizedBox(width: 6),
            Flexible(
              child: Directionality(
                  textDirection: TextDirection.rtl, child: bubble),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userRow(Widget bubble) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: kPill,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('هـ',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 6),
            Flexible(child: bubble),
          ],
        ),
      ),
    );
  }

  Widget _bubble(String text, Color color) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(text,
          style: const TextStyle(
              color: kNavy,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.6)),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBlushHelp,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final active = (_c.value * 3).floor() % 3;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    color: i == active
                        ? kNavy
                        : kNavy.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Generic placeholder for pages not designed yet
// ---------------------------------------------------------------------------
class AthmarPlaceholderPage extends StatelessWidget {
  const AthmarPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kCream,
      body: SafeArea(child: SizedBox.expand()),
    );
  }
}

// ---------------------------------------------------------------------------
// صفحة متابعة النبتة — savings tracker with growing plant
// ---------------------------------------------------------------------------
class TrackerScreen extends StatefulWidget {
  const TrackerScreen(
      {super.key,
      required this.goal,
      required this.amount,
      required this.months});

  final String goal;
  final int amount;
  final int months;

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen>
    with TickerProviderStateMixin {
  int _saved = 0;
  final TextEditingController _amountCtrl = TextEditingController();
  bool _celebrate = false;
  int _celebrateKey = 0;
  bool _inputError = false;
  late final AnimationController _sway;

  static const _stages = [
    // asset, name, width, height
    ('stage1', 'بذرة', 78.0, 52.0),
    ('stage2', 'برعم', 52.0, 82.0),
    ('stage3', 'نبتة صغيرة', 86.0, 84.0),
    ('stage4', 'بداية الإزهار', 80.0, 82.0),
    ('stage5', 'شجيرة مزهرة', 108.0, 82.0),
    ('stage6', 'إزهار كامل', 122.0, 94.0),
  ];

  @override
  void initState() {
    super.initState();
    _sway = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sway.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  double get _pct =>
      widget.amount == 0 ? 0 : (_saved / widget.amount).clamp(0.0, 1.0);

  int get _stageIndex {
    final p = _pct * 100;
    if (p >= 100) return 5;
    if (p >= 75) return 4;
    if (p >= 50) return 3;
    if (p >= 25) return 2;
    if (p >= 5) return 1;
    return 0;
  }

  String _fmtInt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      b.write(s[i]);
      final left = s.length - i - 1;
      if (left > 0 && left % 3 == 0) b.write(',');
    }
    return b.toString();
  }

  /// Normalizes Arabic-Indic digits and strips grouping separators.
  int? _parseAmount(String raw) {
    const east = '٠١٢٣٤٥٦٧٨٩';
    const persian = '۰۱۲۳۴۵۶۷۸۹';
    final b = StringBuffer();
    for (final ch in raw.trim().runes) {
      final c = String.fromCharCode(ch);
      final e = east.indexOf(c);
      final p = persian.indexOf(c);
      if (e >= 0) {
        b.write(e);
      } else if (p >= 0) {
        b.write(p);
      } else if (RegExp(r'\d').hasMatch(c)) {
        b.write(c);
      } else if (c == ',' || c == '٬' || c == ' ') {
        // grouping separator — skip
      } else {
        return null;
      }
    }
    if (b.isEmpty) return null;
    return int.tryParse(b.toString());
  }

  void _addAmount() {
    final v = _parseAmount(_amountCtrl.text);
    if (v == null || v <= 0) {
      setState(() => _inputError = true);
      return;
    }
    final before = _stageIndex;
    setState(() {
      _inputError = false;
      _saved = (_saved + v).clamp(0, widget.amount);
      _amountCtrl.clear();
    });
    if (_stageIndex != before) {
      setState(() {
        _celebrate = true;
        _celebrateKey++;
      });
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) setState(() => _celebrate = false);
      });
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_stageIndex];
    final remaining = widget.amount - _saved;
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(time: '2:12'),
            const SizedBox(height: 2),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [HadeelBadge(), BackChip()],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, cons) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: cons.maxHeight),
                child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('مرحبا بك في أثمر',
                                  style: TextStyle(
                                      color: kNavy,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text('هدف الإدخار : ${widget.goal}',
                                  style: const TextStyle(
                                      color: kNavy,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                        _StreakBadge(days: 1),
                      ],
                    ),
                    const Spacer(flex: 2),
                    // Plant with sway + celebration sparkles
                    SizedBox(
                      height: 190,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AnimatedBuilder(
                            animation: _sway,
                            builder: (context, child) => Transform.rotate(
                              angle: (_sway.value - 0.5) * 0.05,
                              alignment: Alignment.bottomCenter,
                              child: child,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              switchInCurve: Curves.easeOutBack,
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(
                                scale: anim,
                                alignment: Alignment.bottomCenter,
                                child: FadeTransition(
                                    opacity: anim, child: child),
                              ),
                              child: RawAssetImage(
                                'assets/images/${stage.$1}.png',
                                key: ValueKey(stage.$1),
                                width: stage.$3 * 1.2,
                                height: stage.$4 * 1.2,
                              ),
                            ),
                          ),
                          if (_celebrate)
                            Positioned.fill(
                                child: _SparkleBurst(
                                    key: ValueKey(_celebrateKey))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(stage.$2,
                          key: ValueKey(stage.$2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kNavy.withValues(alpha: 0.75),
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 18),
                    _ProgressBar(fraction: _pct),
                    const SizedBox(height: 10),
                    if (_pct >= 1)
                      const Text(
                        'مبروك! نبتتك أزهرت بالكامل، وصلت هدفك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kSalmon,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      )
                    else
                      Text(
                        'باقي ${_fmtInt(remaining)} ريال لتزهر نبتتك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kNavy.withValues(alpha: 0.65),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    const Spacer(flex: 2),
                    // Add amount card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFEFE3D6)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                        children: [
                          const Text('إضافة مبلغ للادخار',
                              style: TextStyle(
                                  color: kNavy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: kCream,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: const Color(0xFFE8DCCE)),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: TextField(
                                    controller: _amountCtrl,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (_) => _addAmount(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: kNavy,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                      hintText: 'ادخل المبلغ',
                                      hintStyle: TextStyle(
                                          color:
                                              kNavy.withValues(alpha: 0.4),
                                          fontSize: 12.5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _addAmount,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kSalmon,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: const Text('أضف',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          fontFamily:
                                              'IBM Plex Sans Arabic')),
                                ),
                              ),
                            ],
                          ),
                          if (_inputError) ...[
                            const SizedBox(height: 6),
                            const Text('اكتب مبلغ صحيح بالأرقام',
                                style: TextStyle(
                                    color: Color(0xFFC0655A),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Farmer help card -> opens the advisor chat
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const AdvisorChatScreen())),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kBlushHelp,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        child: Row(
                          children: [
                            const RawAssetImage(
                                'assets/images/athmar_farmer.png',
                                width: 40, height: 66),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: const [
                                  Text('تبغى مساعدة ؟',
                                      style: TextStyle(
                                          color: kNavy,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w800)),
                                  SizedBox(height: 3),
                                  Text('استشر مزارعنا الذكي',
                                      style: TextStyle(
                                          color: kNavy,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 3),
                                  Icon(Icons.arrow_back,
                                      size: 15, color: kNavy),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
                ),
                ),
              ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }
}

/// Streak badge (top corner): days of commitment, pulses on appear.
class _StreakBadge extends StatefulWidget {
  const _StreakBadge({required this.days});
  final int days;

  @override
  State<_StreakBadge> createState() => _StreakBadgeState();
}

class _StreakBadgeState extends State<_StreakBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700))
    ..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut),
      child: Container(
        decoration: BoxDecoration(
          color: kBlushCard,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 3),
            Text('عداد الالتزام: ${widget.days} يوم',
                style: const TextStyle(
                    color: kNavy,
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text('التزام متواصل',
                style: TextStyle(
                    color: kNavy.withValues(alpha: 0.55),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Animated progress bar: knob color shifts purple -> gold with progress.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.fraction});
  final double fraction;

  @override
  Widget build(BuildContext context) {
    const knobPurple = Color(0xFF9B7EDE);
    const knobGold = Color(0xFFF2B33D);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: fraction),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, f, _) {
        final knobColor = Color.lerp(knobPurple, knobGold, f)!;
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              LayoutBuilder(builder: (context, c) {
                final w = c.maxWidth;
                return Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E4DF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      height: 12,
                      width: (16 + (w - 16) * f).clamp(16.0, w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          knobColor,
                          const Color(0xFF9CC8EC),
                          const Color(0xFFDDEBF7),
                        ]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      height: 12,
                      width: 16,
                      decoration: BoxDecoration(
                        color: knobColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${(f * 100).round()}%',
                    style: const TextStyle(
                        color: kNavy,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Small sparkles that fade out when the plant reaches a new stage.
class _SparkleBurst extends StatefulWidget {
  const _SparkleBurst({super.key});

  @override
  State<_SparkleBurst> createState() => _SparkleBurstState();
}

class _SparkleBurstState extends State<_SparkleBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500))
    ..forward();

  static const _spots = [
    (0.15, 0.25, 14.0),
    (0.80, 0.15, 18.0),
    (0.30, 0.05, 12.0),
    (0.65, 0.45, 13.0),
    (0.90, 0.55, 11.0),
    (0.08, 0.60, 12.0),
  ];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        final opacity = t < 0.2 ? t / 0.2 : (1 - t).clamp(0.0, 1.0);
        return LayoutBuilder(builder: (context, c) {
          return Stack(
            children: [
              for (final s in _spots)
                Positioned(
                  left: c.maxWidth * s.$1,
                  top: c.maxHeight * s.$2 - t * 12,
                  child: Opacity(
                    opacity: opacity,
                    child: Icon(Icons.auto_awesome,
                        size: s.$3, color: kSalmon),
                  ),
                ),
            ],
          );
        });
      },
    );
  }
}
