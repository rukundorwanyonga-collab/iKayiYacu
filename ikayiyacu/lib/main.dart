// ignore_for_file: deprecated_member_use, non_constant_identifier_names, unused_field, unused_local_variable

import 'package:flutter/material.dart';

void main() {
  runApp(const IKayiYacuApp());
}

class IKayiYacuApp extends StatefulWidget {
  const IKayiYacuApp({super.key});

  @override
  State<IKayiYacuApp> createState() => _IKayiYacuAppState();
}

class _IKayiYacuAppState extends State<IKayiYacuApp> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iKayiYacu',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      // ✅ Gukosora uburyo bwo kwinjira: Niba ari logged in, jya kuri MainLayoutPage, bitari ibyo jya kuri AuthScreen
      home: _isLoggedIn
          ? MainLayoutPage(
              onLogout: () => setState(() => _isLoggedIn = false),
            )
          : AuthScreen(
              onLogin: () => setState(() => _isLoggedIn = true),
            ),
    );
  }
}

// ✅ Twahinduye AuthScreen kuko ari yo ifite Form ya Login, tuyiha `onLogin` callback
class AuthScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const AuthScreen({super.key, required this.onLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final Map<String, String> _usersDatabase = {
    'admin': '12345',
    'rwanyonga': 'kaji123',
  };

  bool _isLogin = true;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorMessage;

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Banza winjize izina n\'ijambo ry\'ibanga!';
      });
      return;
    }

    if (_usersDatabase.containsKey(username) && _usersDatabase[username] == password) {
      setState(() {
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ushoboye kwinjira neza! Murakaza neza, $username.'),
          backgroundColor: Colors.green,
        ),
      );

      // ✅ Guhamagara onLogin() kugira ngo isanduku ihinduke `_isLoggedIn = true`
      widget.onLogin();
    } else {
      setState(() {
        _errorMessage = 'Izina cyangwa ijambo ry\'ibanga si ryo!';
      });
    }
  }

  void _handleRegister() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Uzuza amakuru yose asabwa!';
      });
      return;
    }

    if (_usersDatabase.containsKey(username)) {
      setState(() {
        _errorMessage = 'Iryo zina cyangwa telefone bisanzwe bikoreshwa!';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Amajambo y\'ibanga (Passwords) ntabwo ahuye!';
      });
      return;
    }

    setState(() {
      _usersDatabase[username] = password;
      _errorMessage = null;
      _isLogin = true;
      _confirmPasswordController.clear();
      _passwordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Konte nshya yakozwe neza! Yahise ibikwa. Ningombwa kwinjira.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  _isLogin ? Icons.lock_person_rounded : Icons.person_add_rounded,
                  size: 64,
                  color: const Color(0xFF0D47A1),
                ),
                const SizedBox(height: 12),
                Text(
                  _isLogin ? 'Kwinjira muri  iKayiYacu' : 'Gufungura Konte Nshya',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Izina koresha / Telefone',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Ijambo ry\'ibanga (Password)',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (!_isLogin) ...[
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Soma/Emeza Ijambo ry\'ibanga',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                ElevatedButton(
                  onPressed: _isLogin ? _handleLogin : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(_isLogin ? 'Kwinjira' : 'Kwiyandikisha'),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = null;
                    });
                  },
                  child: Text(
                    _isLogin ? 'Nta konte ufite? Fungura nshya' : 'Usanzwe ufite konte? Injira',
                    style: const TextStyle(color: Color(0xFF0D47A1)),
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItsindaApp extends StatelessWidget {
  const ItsindaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itsinda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const WizardPage(),
    );
  }
}

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  State<WizardPage> createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  int _currentStep = 0;

  // Variables zo kubikamo amakuru
  String groupName = '';
  String contributionType = 'icyumweru';
  String contributionAmount = '';
  String supportFund = '';
  String penalty = '';
  String membersCount = '';
  String loanRate = '2.5%';
  String customLoanRate = '';

  // Imfunguzo z'umutekano wa buri fomu (Form Keys)
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Helper method yo kubaka Step mu buryo bo kugaragara neza
  Step _buildStep(int stepIndex, String title, Widget content) {
    return Step(
      title: Text(title),
      isActive: _currentStep == stepIndex,
      state: _currentStep > stepIndex ? StepState.complete : StepState.indexed,
      content: Form(
        key: _formKeys[stepIndex],
        child: content,
      ),
    );
  }

  void _nextStep() {
    // Reba ko fomu yo ku ntambwe iriho yuzuye neza
    if (_currentStep < 6) {
      if (_formKeys[_currentStep].currentState!.validate()) {
        _formKeys[_currentStep].currentState!.save();
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      // Intambwe ya nyuma: Bika amakuru cyangwa yohereze mu C++ Core Engine
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amakuru y\'itsinda yabikuwe neza!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Umurongo ngenderwaho w'itsinda"),
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        onStepTapped: (step) {
          if (step < _currentStep) {
            setState(() => _currentStep = step);
          }
        },
        steps: [
          // STEP 0: Izina ry'itsinda
          _buildStep(
            0,
            "Izina ry’itsinda",
            TextFormField(
              initialValue: groupName,
              decoration: const InputDecoration(
                labelText: "Andika izina ry’itsinda",
                prefixIcon: Icon(Icons.group),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Izina ry’itsinda rirakenewe" : null,
              onSaved: (value) => groupName = value!,
            ),
          ),

          // STEP 1: Umusanzu
          _buildStep(
            1,
            "Umusanzu",
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text("Buri cyumweru"),
                  value: "icyumweru",
                  // ignore: duplicate_ignore
                  // ignore: deprecated_member_use
                  groupValue: contributionType,
                  // ignore: duplicate_ignore
                  // ignore: deprecated_member_use
                  onChanged: (v) => setState(() => contributionType = v!),
                ),
                RadioListTile<String>(
                  title: const Text("Buri kwezi"),
                  value: "ukwezi",
                  // ignore: duplicate_ignore
                  // ignore: deprecated_member_use
                  groupValue: contributionType,
                  onChanged: (v) => setState(() => contributionType = v!),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: contributionAmount,
                  decoration: const InputDecoration(
                    labelText: "Amafaranga y’umusanzu",
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? "Umusanzu urakenewe" : null,
                  onSaved: (v) => contributionAmount = v!,
                ),
              ],
            ),
          ),

          // STEP 2: Ingoboka
          _buildStep(
            2,
            "Ingoboka",
            TextFormField(
              initialValue: supportFund,
              decoration: const InputDecoration(
                labelText: "Amafaranga y’ingoboka",
                prefixIcon: Icon(Icons.volunteer_activism),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? "Ingoboka irakenewe" : null,
              onSaved: (v) => supportFund = v!,
            ),
          ),

          // STEP 3: Amande
          _buildStep(
            3,
            "Amande",
            TextFormField(
              initialValue: penalty,
              decoration: const InputDecoration(
                labelText: "Amafaranga y’amande",
                prefixIcon: Icon(Icons.gavel),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? "Amande zirakenewe" : null,
              onSaved: (v) => penalty = v!,
            ),
          ),

          // STEP 4: Abanyamuryango
          _buildStep(
            4,
            "Abanyamuryango",
            TextFormField(
              initialValue: membersCount,
              decoration: const InputDecoration(
                labelText: "Umubare w’abanyamuryango",
                prefixIcon: Icon(Icons.person_add),
              ),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || int.tryParse(v) == null ? "Injiza umubare nyawo" : null,
              onSaved: (v) => membersCount = v!,
            ),
          ),

          // STEP 5: Ijanisha ku nguzanyo
          _buildStep(
            5,
            "Ijanisha ku nguzanyo",
            Column(
              children: [
                for (var rate in ["2.5%", "5%", "10%"])
                  RadioListTile<String>(
                    title: Text("$rate ku kwezi"),
                    value: rate,
                    groupValue: loanRate,
                    onChanged: (v) => setState(() => loanRate = v!),
                  ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: customLoanRate,
                  decoration: const InputDecoration(
                    labelText: "Ijanisha yihariye (%)",
                    prefixIcon: Icon(Icons.percent),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (v) => customLoanRate = v ?? '',
                ),
              ],
            ),
          ),

          // STEP 6: Ibisubizo byose
          Step(
            title: const Text("Ibisubizo byose"),
            isActive: _currentStep == 6,
            content: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Izina: $groupName",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text("Umusanzu: $contributionAmount Frw / $contributionType"),
                      leading: const Icon(Icons.payments),
                      dense: true,
                    ),
                    ListTile(
                      title: Text("Ingoboka: $supportFund Frw"),
                      leading: const Icon(Icons.medical_services),
                      dense: true,
                    ),
                    ListTile(
                      title: Text("Amande: $penalty Frw"),
                      leading: const Icon(Icons.warning),
                      dense: true,
                    ),
                    ListTile(
                      title: Text("Abanyamuryango: $membersCount"),
                      leading: const Icon(Icons.people),
                      dense: true,
                    ),
                    ListTile(
                      title: Text(
                        "Ijanisha: ${customLoanRate.isNotEmpty ? customLoanRate : loanRate}",
                      ),
                      leading: const Icon(Icons.percent),
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
class MainLayoutPage extends StatefulWidget {
  final VoidCallback onLogout;

  const MainLayoutPage({super.key, required this.onLogout});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentPageIndex = 0;

  final List<Map<String, dynamic>> _menuItems = const [
    {'title': 'Amategeko', 'icon':Icons.playlist_add_check},
    {'title': 'Raporo/Ahabanza', 'icon': Icons.dashboard},
    {'title': 'Abanyamuryango', 'icon': Icons.people},
    {'title': 'Inguzanyo', 'icon': Icons.credit_card},
    {'title': 'Amateka', 'icon': Icons.book},
    {'title': 'Komite Nyobozi', 'icon': Icons.groups},
    {'title': 'Igenamiterere', 'icon': Icons.fax_rounded},
    
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const WizardPage(),
      const DashboardContent(),
      const MembersContent(),
      const LoansContent(),
      const HistoryContent(),
      const CommitteeContent(),
      const SettingsContent(),
      
    ];

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: pages[_currentPageIndex]),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 290,
      color: const Color(0xFFF9FAFC),
      child: Column(
        children: [
          Container(
            height: 88,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
            alignment: Alignment.centerLeft,
            child: const Text(
              'iKayiYacu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _currentPageIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE3F2FD)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        color: isSelected
                            ? const Color(0xFF0D47A1)
                            : Colors.blueGrey,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF0D47A1)
                              : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () => setState(() => _currentPageIndex = index),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Sohoka',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }
}
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Data y'amacards 6 yegeranye kandi afite amakuru akenewe
    final metrics = [
      {
        'title': 'Abanyamuryango',
        'value': '28',
        'subtext': '+3 uyu kwezi',
        'trend': '+12%',
        'isPositive': true,
        'icon': Icons.people_outline,
        'color': const Color(0xFF1E88E5),
      },
      {
        'title': 'Ikigega Total',
        'value': '2,450,000 Frw',
        'subtext': 'Ubwiteganyirize',
        'trend': '+8.5%',
        'isPositive': true,
        'icon': Icons.savings_outlined,
        'color': const Color(0xFF43A047),
      },
      {
        'title': 'Inguzanyo Zatanzwe',
        'value': '850,000 Frw',
        'subtext': 'Mu banyamuryango 5',
        'trend': '-2%',
        'isPositive': false,
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFFFB8C00),
      },
      {
        'title': 'Ingoboka',
        'value': '120,000 Frw',
        'subtext': 'Imfashanyo',
        'trend': '0%',
        'isPositive': true,
        'icon': Icons.favorite_outline,
        'color': const Color(0xFFE53935),
      },
      {
        'title': 'Igikorwamari / Inyungu',
        'value': '340,000 Frw',
        'subtext': 'Inyungu y’inguzanyo',
        'trend': '+15%',
        'isPositive': true,
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFF8E24AA),
      },
      {
        'title': 'Amande Akusanyijwe',
        'value': '15,000 Frw',
        'subtext': 'Ibyerekeye gukererwa',
        'trend': '-5%',
        'isPositive': true,
        'icon': Icons.gavel_outlined,
        'color': const Color(0xFF00ACC1),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Ahabanza',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Color(0xFF0D47A1),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GRID Y'AMACARDS 6
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1100
                    ? 6
                    : constraints.maxWidth > 700
                        ? 3
                        : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: metrics.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 110,
                  ),
                  itemBuilder: (context, index) {
                    final item = metrics[index];
                    return MetricCard(
                      title: item['title'] as String,
                      value: item['value'] as String,
                      subtext: item['subtext'] as String,
                      trend: item['trend'] as String,
                      isPositive: item['isPositive'] as bool,
                      icon: item['icon'] as IconData,
                      color: item['color'] as Color,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // 2. PANELS ZIJIYEHAMO: Activity Log (Ibyakozwe vuba), Integuza, n'Ibikorwa Byihuse
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return isWide
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Graph yakuwemo, haza Panel y'Ibyakozwe (Activity Log)
                          Expanded(flex: 5, child: RecentActivityPanel()),
                          SizedBox(width: 16),
                          Expanded(flex: 3, child: InteguzaPanel()),
                          SizedBox(width: 16),
                          Expanded(flex: 3, child: QuickActionsPanel()),
                        ],
                      )
                    : const Column(
                        children: [
                          RecentActivityPanel(),
                          SizedBox(height: 16),
                          InteguzaPanel(),
                          SizedBox(height: 16),
                          QuickActionsPanel(),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Compact Metric Card
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtext;
  final String trend;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtext,
    required this.trend,
    required this.isPositive,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 1. PANEL NSHYA: Inshamake y'Ibyakozwe vuba (Recent Activity Log)
class RecentActivityPanel extends StatelessWidget {
  const RecentActivityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'title': 'Kubitsa Ubwiteganyirize',
        'user': 'Mugisha Jean',
        'amount': '+10,000 Frw',
        'time': 'Min 15 zishize',
        'icon': Icons.arrow_downward_rounded,
        'color': Colors.green,
      },
      {
        'title': 'Kwishyura Inguzanyo',
        'user': 'Uwase Marie',
        'amount': '+45,000 Frw',
        'time': 'Isaha 1 ishize',
        'icon': Icons.refresh_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Gutanga Inguzanyo',
        'user': 'Keza Alice',
        'amount': '-150,000 Frw',
        'time': 'Uyu munsi',
        'icon': Icons.arrow_upward_rounded,
        'color': Colors.orange,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ibyakozwe Vuba",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Reba Byose", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: activities.map((item) {
              final color = item['color'] as Color;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: color.withOpacity(0.12),
                      child: Icon(item['icon'] as IconData, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            "${item['user']} • ${item['time']}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item['amount'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: (item['amount'] as String).startsWith('+')
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// 2. Panel y'Integuza
class InteguzaPanel extends StatelessWidget {
  const InteguzaPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = [
      {
        'title': 'Kwirinda amande y’ukwezi',
        'desc': 'Kwishyura inguzanyo mbere ya 05/08',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'Inama y’Ubwiteganyirize',
        'desc': 'Bimwe mu bintu bizigwa Kuwa Gatandatu',
        'icon': Icons.event_note,
        'color': Colors.blue,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Integuza n'Ibyitonderwa",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: reminders.map((item) {
              final color = item['color'] as Color;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, color: color, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            item['desc'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// 3. Quick Actions Panel
class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ibikorwa Byihuse",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(Icons.add_card, "Tanga Inguzanyo"),
              _buildActionButton(Icons.person_add_alt_1, "Ongeramo Member"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFF1F5F9),
          child: Icon(icon, color: const Color(0xFF0D47A1), size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class MembersContent extends StatefulWidget {
  const MembersContent({super.key});

  @override
  State<MembersContent> createState() => _MembersContentState();
}

class _MembersContentState extends State<MembersContent> {
  // Data y'abanyamuryango irimo Phone n'Indangamuntu (ID)
  final List<Map<String, dynamic>> _allMembers = [
    {
      'izina': 'Yohani kagabo',
      'phone': '0788123456',
      'indangamuntu': '1199880012345678',
      'umusanzu': 5000,
      'inyungu': 1000,
      'ingoboka': 500,
      'amande': 0,
      'itariki': '18/06/2026',
    },
    {
      'izina': 'Maria nyirarukundo',
      'phone': '0789987654',
      'indangamuntu': '1199580087654321',
      'umusanzu': 10000,
      'inyungu': 1500,
      'ingoboka': 1000,
      'amande': 200,
      'itariki': '18/06/2026',
    },
    {
      'izina': 'Jean nyiranzoga',
      'phone': '0722334455',
      'indangamuntu': '1200080055443322',
      'umusanzu': 7000,
      'inyungu': 1200,
      'ingoboka': 700,
      'amande': 0,
      'itariki': '19/06/2026',
    },
  ];

  String _query = '';

  // 1. Dialog yo GUTERANYA AMAFARANGA
  void _openAddMoneyDialog(int index) {
    final member = _allMembers[index];
    String selectedCategory = 'umusanzu';
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Ongeraho Amafaranga: ${member['izina']}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone: ${member['phone']} | ID: ${member['indangamuntu']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Text('Hitamo ubwoko bw\'amafaranga:'),
                  DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'umusanzu', child: Text('Umusanzu')),
                      DropdownMenuItem(value: 'inyungu', child: Text('Inyungu')),
                      DropdownMenuItem(value: 'ingoboka', child: Text('Ingoboka')),
                      DropdownMenuItem(value: 'amande', child: Text('Amande')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedCategory = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amafaranga yo guteranyaho (Frw)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Reka'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final addedAmount = int.tryParse(amountController.text) ?? 0;
                    if (addedAmount > 0) {
                      setState(() {
                        final currentAmount = _allMembers[index][selectedCategory] as int;
                        _allMembers[index][selectedCategory] = currentAmount + addedAmount;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Yongeweho $addedAmount Frw kuri ${selectedCategory.toUpperCase()}!',
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Guteranya & Bika'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 2. Dialog yo Kongeramo Umunyamuryango Mushya
  void _openAddMemberDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final idController = TextEditingController();
    final umusanzuController = TextEditingController(text: '0');
    final inyunguController = TextEditingController(text: '0');
    final ingobokaController = TextEditingController(text: '0');
    final amandeController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ongeraho Umunyamuryango Mushya'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Izina ryose'),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Nambari ya Telefone'),
                ),
                TextField(
                  controller: idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Nambari y\'Indangamuntu (ID)'),
                ),
                TextField(
                  controller: umusanzuController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Umusanzu w\'ibanze (Frw)'),
                ),
                TextField(
                  controller: inyunguController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Inyungu (Frw)'),
                ),
                TextField(
                  controller: ingobokaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Ingoboka (Frw)'),
                ),
                TextField(
                  controller: amandeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amande (Frw)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bimburire'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _allMembers.add({
                      'izina': nameController.text,
                      'phone': phoneController.text,
                      'indangamuntu': idController.text,
                      'umusanzu': int.tryParse(umusanzuController.text) ?? 0,
                      'inyungu': int.tryParse(inyunguController.text) ?? 0,
                      'ingoboka': int.tryParse(ingobokaController.text) ?? 0,
                      'amande': int.tryParse(amandeController.text) ?? 0,
                      'itariki': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Bika'),
            ),
          ],
        );
      },
    );
  }

  // 3. Dialog yo GUHINDURA (EDIT) Umunyamuryango
  void _openEditMemberDialog(int index) {
    final member = _allMembers[index];

    final nameController = TextEditingController(text: member['izina'].toString());
    final phoneController = TextEditingController(text: member['phone'].toString());
    final idController = TextEditingController(text: member['indangamuntu'].toString());
    final umusanzuController = TextEditingController(text: member['umusanzu'].toString());
    final inyunguController = TextEditingController(text: member['inyungu'].toString());
    final ingobokaController = TextEditingController(text: member['ingoboka'].toString());
    final amandeController = TextEditingController(text: member['amande'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guhindura Umunyamuryango'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Izina ryose'),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Nambari ya Telefone'),
                ),
                TextField(
                  controller: idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Nambari y\'Indangamuntu (ID)'),
                ),
                TextField(
                  controller: umusanzuController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Umusanzu (Frw)'),
                ),
                TextField(
                  controller: inyunguController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Inyungu (Frw)'),
                ),
                TextField(
                  controller: ingobokaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Ingoboka (Frw)'),
                ),
                TextField(
                  controller: amandeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amande (Frw)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Reka'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _allMembers[index] = {
                      ..._allMembers[index],
                      'izina': nameController.text,
                      'phone': phoneController.text,
                      'indangamuntu': idController.text,
                      'umusanzu': int.tryParse(umusanzuController.text) ?? 0,
                      'inyungu': int.tryParse(inyunguController.text) ?? 0,
                      'ingoboka': int.tryParse(ingobokaController.text) ?? 0,
                      'amande': int.tryParse(amandeController.text) ?? 0,
                    };
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Amakuru yahinduwe neza!')),
                  );
                }
              },
              child: const Text('Bika Impinduka'),
            ),
          ],
        );
      },
    );
  }

  // 4. Function yo Gusiba Umunyamuryango
  void _deleteMember(int index) {
    setState(() {
      _allMembers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Umunyamuryango wasibwe neza!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredWithIndex = [];
    for (int i = 0; i < _allMembers.length; i++) {
      final member = _allMembers[i];
      final q = _query.toLowerCase();
      if (member['izina'].toString().toLowerCase().contains(q) ||
          member['phone'].toString().contains(q) ||
          member['indangamuntu'].toString().contains(q) ||
          member['itariki'].toString().contains(q)) {
        filteredWithIndex.add({...member, 'originalIndex': i});
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Abanyamuryango'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFF0D47A1),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                        hintText: 'Shakisha ukoresheje Izina, Phone, cyangwa ID...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _openAddMemberDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Ongeraho Umunyamuryango'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dividerThickness: 1,
                      columns: const [
                        DataColumn(label: Text('Izina')),
                        DataColumn(label: Text('Telefone')),
                        DataColumn(label: Text('Indangamuntu')),
                        DataColumn(label: Text('Umusanzu')),
                        DataColumn(label: Text('Inyungu')),
                        DataColumn(label: Text('Ingoboka')),
                        DataColumn(label: Text('Amande')),
                        DataColumn(label: Text('Itariki')),
                        DataColumn(label: Text('Ibikorwa')),
                      ],
                      rows: filteredWithIndex.map((item) {
                        final originalIndex = item['originalIndex'] as int;

                        return DataRow(
                          cells: [
                            DataCell(Text(item['izina'].toString())),
                            DataCell(Text(item['phone'].toString())),
                            DataCell(Text(item['indangamuntu'].toString())),
                            DataCell(Text('${item['umusanzu']} Frw')),
                            DataCell(Text('${item['inyungu']} Frw')),
                            DataCell(Text('${item['ingoboka']} Frw')),
                            DataCell(Text('${item['amande']} Frw')),
                            DataCell(Text(item['itariki'].toString())),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Guteranya Amafaranga',
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: () => _openAddMoneyDialog(originalIndex),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _openEditMemberDialog(originalIndex);
                                      } else if (value == 'delete') {
                                        _deleteMember(originalIndex);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: Colors.blue, size: 20),
                                            SizedBox(width: 8),
                                            Text('Hindura'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red, size: 20),
                                            SizedBox(width: 8),
                                            Text('Siba'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
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
class LoansContent extends StatefulWidget {
  const LoansContent({super.key});

  @override
  State<LoansContent> createState() => _LoansContentState();
}

class _LoansContentState extends State<LoansContent> {
  String searchQuery = '';

  final List<Map<String, String>> loans = [
    {
      'user': 'Yohani kanziga',
      'phone': '0788123456',
      'amount': '500,000',
      'reason': 'Ubuhinzi',
      'umudugudu': 'Kagugu',
      'akagari': 'Gacuriro',
      'umwishingizi': 'Mukamana Devotha',
      'start': '18/06/2026',
      'due': '18/07/2026',
      'status': 'Itegerejwe',
    },
    {
      'user': 'Maria munyazirinda',
      'phone': '0789987654',
      'amount': '300,000',
      'reason': 'Amashuri',
      'umudugudu': 'Nyarugenge',
      'akagari': 'Kiyovu',
      'umwishingizi': 'Hakizimana Jean',
      'start': '10/06/2026',
      'due': '10/07/2026',
      'status': 'Yishyuwe',
    },
  ];

  void _deleteLoan(int index) {
    setState(() {
      loans.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Umunyamuryango wasibwe neza!'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _openLoanDialog({Map<String, String>? existingLoan, int? index}) {
    final isEditing = existingLoan != null;

    final nameController = TextEditingController(
      text: isEditing ? existingLoan['user'] : '',
    );
    final phoneController = TextEditingController(
      text: isEditing ? existingLoan['phone'] : '',
    );
    final amountController = TextEditingController(
      text: isEditing ? existingLoan['amount'] : '',
    );
    final reasonController = TextEditingController(
      text: isEditing ? existingLoan['reason'] : '',
    );
    final umuduguduController = TextEditingController(
      text: isEditing ? existingLoan['umudugudu'] : '',
    );
    final akagariController = TextEditingController(
      text: isEditing ? existingLoan['akagari'] : '',
    );
    final umwishingiziController = TextEditingController(
      text: isEditing ? existingLoan['umwishingizi'] : '',
    );

    String selectedStatus = isEditing
        ? (existingLoan['status'] ?? 'Itegerejwe')
        : 'Itegerejwe';

    showDialog(
      context: context,
      builder: (context) {
        // KOSORA: Ukoresha StatefulBuilder aho gukoresha StatefulWidget
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                isEditing ? 'Vugurura Inguzanyo' : 'Inguzanyo Nshya',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(nameController, 'Izina ry\'Umunyamuryango', Icons.person),
                    const SizedBox(height: 12),
                    _buildTextField(phoneController, 'Telefone', Icons.phone, keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildTextField(amountController, 'Amafaranga (Frw)', Icons.payments, keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildTextField(reasonController, 'Impamvu', Icons.description),
                    const SizedBox(height: 12),
                    _buildTextField(umuduguduController, 'Umudugudu', Icons.location_city),
                    const SizedBox(height: 12),
                    _buildTextField(akagariController, 'Akagari', Icons.map),
                    const SizedBox(height: 12),
                    _buildTextField(umwishingiziController, 'Umwishingizi', Icons.verified_user),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        prefixIcon: const Icon(Icons.info_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Itegerejwe', child: Text('Itegerejwe')),
                        DropdownMenuItem(value: 'Yishyuwe', child: Text('Yishyuwe')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedStatus = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Bimburire', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final newEntry = {
                      'user': nameController.text,
                      'phone': phoneController.text,
                      'amount': amountController.text,
                      'reason': reasonController.text,
                      'umudugudu': umuduguduController.text,
                      'akagari': akagariController.text.isNotEmpty
                          ? akagariController.text
                          : 'Kigali',
                      'umwishingizi': umwishingiziController.text.isNotEmpty
                          ? umwishingiziController.text
                          : 'N/A',
                      'start': isEditing ? (existingLoan['start'] ?? '01/08/2026') : '01/08/2026',
                      'due': isEditing ? (existingLoan['due'] ?? '01/09/2026') : '01/09/2026',
                      'status': selectedStatus,
                    };

                    setState(() {
                      if (isEditing && index != null) {
                        loans[index] = newEntry;
                      } else {
                        loans.add(newEntry);
                      }
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    isEditing ? 'Bika Ibihinduwe' : 'Ongeraho',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLoans = loans.where((loan) {
      final name = loan['user']?.toLowerCase() ?? '';
      final phone = loan['phone']?.toLowerCase() ?? '';
      final village = loan['umudugudu']?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();
      return name.contains(query) || phone.contains(query) || village.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Icungamutungo ry\'Inguzanyo'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Controls
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Shakisha izina, telefone, umudugudu...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FB),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _openLoanDialog(),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Inguzanyo Nshya'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Table Area
              Expanded(
                child: filteredLoans.isEmpty
                    ? const Center(
                        child: Text(
                          'Nta nguzanyo zabonetse.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            // KOSORA: headingRowColor aho gukoresha headingRowBackgroundColor
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF1F5F9),
                            ),
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                            columns: const [
                              DataColumn(label: Text('Umunyamuryango')),
                              DataColumn(label: Text('Telefone')),
                              DataColumn(label: Text('Amafaranga')),
                              DataColumn(label: Text('Impamvu')),
                              DataColumn(label: Text('Umudugudu')),
                              DataColumn(label: Text('Akagari')),
                              DataColumn(label: Text('Umwishingizi')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Ibikorwa')),
                            ],
                            rows: filteredLoans.asMap().entries.map((entry) {
                              final loan = entry.value;
                              final isPaid = loan['status'] == 'Yishyuwe';

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      loan['user'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(Text(loan['phone'] ?? '')),
                                  DataCell(
                                    Text(
                                      '${loan['amount'] ?? '0'} Frw',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0D47A1),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(loan['reason'] ?? '')),
                                  DataCell(Text(loan['umudugudu'] ?? '')),
                                  DataCell(Text(loan['akagari'] ?? '')),
                                  DataCell(Text(loan['umwishingizi'] ?? '')),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPaid
                                            ? Colors.green.shade50
                                            : Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isPaid
                                              ? Colors.green.shade300
                                              : Colors.orange.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        loan['status'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isPaid
                                              ? Colors.green.shade800
                                              : Colors.orange.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _openLoanDialog(
                                            existingLoan: loan,
                                            index: loans.indexOf(loan),
                                          );
                                        } else if (value == 'delete') {
                                          _deleteLoan(loans.indexOf(loan));
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, color: Colors.blue, size: 18),
                                              SizedBox(width: 8),
                                              Text('Hindusta'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.red, size: 18),
                                              SizedBox(width: 8),
                                              Text('Siba'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
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

class HistoryContent extends StatefulWidget {
  const HistoryContent({super.key});

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  final TextEditingController _searchController = TextEditingController();

  // 1. Data y'Amateka (Mu gihe utarashyiramo Database/Backend)
  final List<Map<String, String>> _allHistory = [
    {
      'user': 'Yohani nyanzoga',
      'ibyabaye': 'Inguzanyo',
      'ingano': '101000',
      'impamvu': 'Ubuhinzi',
      'itariki': '18/06/2026',
      'itarikiYokwishyura': '12/09/2026',
    },
    {
      'user': 'Mugisha Eric',
      'ibyabaye': 'Umusanzu',
      'ingano': '5000',
      'impamvu': 'Umusanzu w\'ukwezi',
      'itariki': '20/06/2026',
      'itarikiYokwishyura': '-',
    },
    {
      'user': 'Keza Alice',
      'ibyabaye': 'Amande',
      'ingano': '2000',
      'impamvu': 'Kutaza mu nteko',
      'itariki': '22/06/2026',
      'itarikiYokwishyura': '-',
    },
  ];

  // List izajya ibamo filtered dynamic data
  List<Map<String, String>> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    _filteredHistory = _allHistory;
  }

  // Function yo gushakisha muri history
  void _filterHistory(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHistory = _allHistory;
      } else {
        _filteredHistory = _allHistory.where((item) {
          final user = item['user']?.toLowerCase() ?? '';
          final impamvu = item['impamvu']?.toLowerCase() ?? '';
          final ibyabaye = item['ibyabaye']?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          return user.contains(searchLower) ||
              impamvu.contains(searchLower) ||
              ibyabaye.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Amateka y\'Ikimina'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 16,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Input Search Field
              TextField(
                controller: _searchController,
                onChanged: _filterHistory,
                decoration: InputDecoration(
                  hintText: 'Shakisha amateka ku izina, impamvu...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0D47A1)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterHistory('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF8F9FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. DataTable ikaye mu kadi
              Expanded(
                child: _filteredHistory.isEmpty
                    ? const Center(
                        child: Text(
                          'Nta mateka aboneka ajyanye n\'ibyo ushakishije.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF1F5F9),
                            ),
                            columns: const [
                              DataColumn(label: Text('Umunyamuryango', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Igikorwa', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Amafaranga', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Impamvu', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Itariki', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Kwishyura', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: _filteredHistory.map((item) {
                              final actionType = item['ibyabaye'] ?? '';
                              
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      item['user'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(
                                    _buildActionBadge(actionType),
                                  ),
                                  DataCell(
                                    Text(
                                      '${item['ingano'] ?? '0'} Frw',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0D47A1),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(item['impamvu'] ?? '')),
                                  DataCell(Text(item['itariki'] ?? '')),
                                  DataCell(
                                    Text(
                                      item['itarikiYokwishyura'] ?? '-',
                                      style: TextStyle(
                                        color: item['itarikiYokwishyura'] != '-' 
                                            ? Colors.orange.shade800 
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
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

  // Widget ifasha guha amarange adasanzwe buri gikorwa
  Widget _buildActionBadge(String action) {
    Color bg;
    Color fg;

    switch (action.toLowerCase()) {
      case 'inguzanyo':
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade900;
        break;
      case 'umusanzu':
        bg = Colors.green.shade50;
        fg = Colors.green.shade900;
        break;
      case 'amande':
        bg = Colors.red.shade50;
        fg = Colors.red.shade900;
        break;
      default:
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        action,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
class CommitteeContent extends StatefulWidget {
  const CommitteeContent({super.key});

  @override
  State<CommitteeContent> createState() => _CommitteeContentState();
}

class _CommitteeContentState extends State<CommitteeContent> {
  var _isLoggedin = true;

  final List<Map<String, String>> _members = [
    {'name': 'Jean Mukanabana', 'role': 'Perezida', 'phone': '0788123456'},
    {'name': 'Marie Mukeshimana', 'role': 'Umubitsi', 'phone': '0788654321'},
    {'name': 'Claude Rukundo', 'role': 'Umwanditsi', 'phone': '0788999888'},
  ];

  void _showMemberDialog({int? index}) {
    final isEditing = index != null;
    final nameController = TextEditingController(
      text: isEditing ? _members[index]['name'] : '',
    );
    final phoneController = TextEditingController(
      text: isEditing ? _members[index]['phone'] : '',
    );
    String selectedRole = isEditing
        ? (_members[index]['role'] ?? 'Perezida')
        : 'Perezida';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit_note : Icons.person_add_alt_1,
                    color: const Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? 'Hindura Umunyamuryango' : 'Umunyamuryango Mushya',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Izina Ryose',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Umwanya / Inshingano',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Perezida', child: Text('Perezida')),
                        DropdownMenuItem(value: 'Visi Perezida', child: Text('Visi Perezida')),
                        DropdownMenuItem(value: 'Umubitsi', child: Text('Umubitsi')),
                        DropdownMenuItem(value: 'Umwanditsi', child: Text('Umwanditsi')),
                        DropdownMenuItem(value: 'Umujyanama', child: Text('Umujyanama')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedRole = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Numero ya Telefone',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Reka', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();

                    if (name.isNotEmpty && phone.isNotEmpty) {
                      setState(() {
                        if (isEditing) {
                          _members[index] = {
                            'name': name,
                            'role': selectedRole,
                            'phone': phone,
                          };
                        } else {
                          _members.add({
                            'name': name,
                            'role': selectedRole,
                            'phone': phone,
                          });
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isEditing ? 'Bika Ibyahinduwe' : 'Ongeramo'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Kwemeza Gusiba'),
          content: Text(
            'Uraharaye gusiba ${_members[index]['name']} muri Komite Nyobozi?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Reka'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  _members.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Siba'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Komite Nyobozi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF1E293B),
      ),
      // Side Drawer ikoresheje Material kuri ListTile mu kubohoza Ink Splash
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0D47A1)),
              child: Text(
                'eKayi Navigation',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // FIXED: Gunyuzwe muri Material kugira ngo ListTile idakora error
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.people_alt_outlined),
                title: const Text('Komite Nyobozi'),
                onTap: () => Navigator.pop(context),
              ),
            ),

            const Divider(),

            // FIXED: ListTile ya Log out idakoresha ColoredBox n'ibindi bidafite Material
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Sohoka (Log Out)',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    _isLoggedin = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMemberDialog(),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Ongeramo Umunyamuryango',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER CARD (PERMISSIONS OVERVIEW)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D47A1).withValues(),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shield_outlined, color: Colors.white, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Ubushobozi bw\'Inshingano (Permissions)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: const [
                      _PermissionChip(role: 'Perezida', desc: 'Areba raporo n\'imibare yose'),
                      _PermissionChip(role: 'Umubitsi', desc: 'Yinjiza n\'agacunga amafaranga'),
                      _PermissionChip(role: 'Umwanditsi', desc: 'Yinjiza amateka n\'abanyamuryango'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 2. MAIN TABLE CONTAINER
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Urutonde rwa Komite (${_members.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _members.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              'Nta munyamuryango wa komite urajyamo.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 48,
                            dataRowMaxHeight: 64,
                            headingRowColor: const WidgetStatePropertyAll(
                              Color(0xFFF8FAFC),
                            ),
                            horizontalMargin: 16,
                            columnSpacing: 32,
                            columns: const [
                              DataColumn(
                                label: Text('Umunyamuryango',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              ),
                              DataColumn(
                                label: Text('Umwanya',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              ),
                              DataColumn(
                                label: Text('Telefone',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              ),
                              DataColumn(
                                label: Text('Ibyakorwa',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              ),
                            ],
                            rows: List.generate(_members.length, (index) {
                              final member = _members[index];
                              final name = member['name'] ?? '';
                              final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: const Color(0xFFE2E8F0),
                                          child: Text(
                                            initial,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0D47A1),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(_RoleBadge(role: member['role'] ?? '')),
                                  DataCell(Text(
                                    member['phone'] ?? '',
                                    style: const TextStyle(color: Color(0xFF475569)),
                                  )),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, color: Color(0xFF2563EB), size: 20),
                                          onPressed: () => _showMemberDialog(index: index),
                                          tooltip: 'Hindura',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
                                          onPressed: () => _confirmDelete(index),
                                          tooltip: 'Siba',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
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
}

class _PermissionChip extends StatelessWidget {
  final String role;
  final String desc;
  const _PermissionChip({required this.role, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '• $role: $desc',
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF475569);

    if (role.contains('Perezida')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
    } else if (role.contains('Umubitsi')) {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF15803D);
    } else if (role.contains('Umwanditsi')) {
      bg = const Color(0xFFE0F2FE);
      fg = const Color(0xFF0369A1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
class SettingsContent extends StatefulWidget {
  final VoidCallback? onLogout;

  const SettingsContent({super.key, this.onLogout});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Kinyarwanda';

  // Modal Dialog yo guhindura Password
  void _openChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.lock_reset, color: Color(0xFF0D47A1)),
              SizedBox(width: 10),
              Text(
                'Guhindura Umubare w\'Ibanganga',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Umubare w\'ibanganga usanzwe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Umubare w\'ibanganga mushya',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.key),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Komeza Umubare mushya',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.check_circle_outline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Reka', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (newPasswordController.text == confirmPasswordController.text &&
                    newPasswordController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Umubare w\'ibanganga wahinduwe neza!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Imibare ntabwo ihuye! Reka wongere ugerageze.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('Bika', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kuko iri muri MainLayout, dukoresha Container/Container yo gusimbuza Scaffold
    return Container(
      color: const Color(0xFFF5F7FB),
      child: Column(
        children: [
          // Header y'Igenamiterere idafunga umwanya
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: const Text(
              'Igenamiterere (Settings)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),
          const Divider(height: 1),
          // Content nyirizina
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Summary Card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF0D47A1),
                            child: Icon(Icons.person, color: Colors.white, size: 36),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rukundo Rwanyonga',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Umuyobozi w\'Isanduku / Admin',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 1: Umutekano
                  _buildSectionHeader('Umutekano & Konti'),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.lock, color: Color(0xFF0D47A1)),
                          title: const Text('Hindura Umubare w\'Ibanganga (Password)'),
                          subtitle: const Text('Guhindura password yawe yo kwinjiriraho'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _openChangePasswordDialog,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.person_outline, color: Color(0xFF0D47A1)),
                          title: const Text('Amakuru y\'Umusaruro / Profile'),
                          subtitle: const Text('Vugurura izina, telefone, n\'ibindi'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 2: Wizard & Setup
                  _buildSectionHeader('Igenamiterere rya Wizard & Setup'),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.auto_awesome, color: Colors.amber),
                          title: const Text('Subiramo Wizard y\'Ibanze'),
                          subtitle: const Text('Kongera kunyura mu ntambwe zo gutuza porogaramu'),
                          trailing: const Icon(Icons.replay, color: Color(0xFF0D47A1)),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gutangiza Wizard...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 3: Imiterere ya App
                  _buildSectionHeader('Imiterere y\'Ikoreshwa'),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.language, color: Color(0xFF0D47A1)),
                          title: const Text('Ururimi (Language)'),
                          subtitle: Text(_selectedLanguage),
                          trailing: DropdownButton<String>(
                            value: _selectedLanguage,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: 'Kinyarwanda', child: Text('Kinyarwanda')),
                              DropdownMenuItem(value: 'English', child: Text('English')),
                              DropdownMenuItem(value: 'Français', child: Text('Français')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedLanguage = value;
                                });
                              }
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          secondary: const Icon(Icons.notifications_active_outlined, color: Color(0xFF0D47A1)),
                          title: const Text('Notifications'),
                          subtitle: const Text('Kwakira ubutumwa bugaragaza ibikorwa n\'inguzanyo'),
                          value: _notificationsEnabled,
                          activeColor: const Color(0xFF0D47A1),
                          onChanged: (val) {
                            setState(() {
                              _notificationsEnabled = val;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF0D47A1)),
                          title: const Text('Ibara ry\'Ijoro (Dark Mode)'),
                          subtitle: const Text('Guhindura ibara rya porogaramu mu mwijima'),
                          value: _darkModeEnabled,
                          activeColor: const Color(0xFF0D47A1),
                          onChanged: (val) {
                            setState(() {
                              _darkModeEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 4: Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        side: BorderSide(color: Colors.red.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Sohoka muri Porogaramu (Logout)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Gusohoka'),
                            content: const Text('Wimfuzaga gusohoka muri iyi konti?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Oya'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (widget.onLogout != null) {
                                    widget.onLogout!();
                                  }
                                },
                                child: const Text('Yego, Sohoka', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }
}
