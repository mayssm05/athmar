import 'package:flutter/material.dart';

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
        '/athmar/journey': (_) => const AthmarJourneyPlaceholderScreen(),
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
// Placeholder for the next page after "ابدأ رحلتك"
// ---------------------------------------------------------------------------
class AthmarJourneyPlaceholderScreen extends StatelessWidget {
  const AthmarJourneyPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kCream,
      body: SafeArea(child: SizedBox.expand()),
    );
  }
}
