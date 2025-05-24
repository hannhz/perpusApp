import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_type.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen>
    with SingleTickerProviderStateMixin {
  String selectedRole = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  double scaleFontSize(double size) {
    double baseWidth = 375.0; // Base width for scaling (e.g., iPhone 8 width)
    double screenWidth = MediaQuery.of(context).size.width;
    return size * screenWidth / baseWidth;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectUser(String role) {
    setState(() {
      selectedRole = role;
    });
    HapticFeedback.selectionClick();
    if (role == 'Pengunjung') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userType: UserType.pengunjung),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Lanjutkan sebagai pustakawan?'),
              content: const Text(
                'Harus masuk untuk melanjutkan sebagai pustakawan.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const LoginScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          final tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Lanjut'),
                ),
              ],
            ),
      );
    }
  }

  Widget buildUserCard(
    String role,
    Color bgColor,
    Color iconColor,
    IconData icon,
    String title,
    String subtitle,
  ) {
    bool isSelected = selectedRole == role;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: isSelected ? 1.05 : 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: isSelected ? 14 : 8,
        shadowColor:
            isSelected
                ? const Color.fromARGB(255, 138, 138, 138)
                : Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => selectUser(role),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: scaleFontSize(
                            20,
                          ), //teks pengunjung dan pustakawan??
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: scaleFontSize(16),
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color:
                      isSelected
                          ? const Color.fromARGB(255, 69, 69, 69)
                          : const Color(0xFF9CA3AF),
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final String currentDate = 'Monday, January 1, 2023';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[500]!, Colors.grey[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selamat Datang di Perpustakaan Kami!',
                      style: TextStyle(
                        fontSize: scaleFontSize(26),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silahkan pilih role mu',
                      style: TextStyle(
                        fontSize: scaleFontSize(16),
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    buildUserCard(
                      'Pengunjung',
                      Colors.grey[400]!,
                      Colors.black87,
                      Icons.person,
                      'Pengunjung',
                      '',
                    ),
                    const SizedBox(height: 32),
                    buildUserCard(
                      'Pustakawan',
                      Colors.grey[800]!,
                      Colors.white70,
                      Icons.admin_panel_settings,
                      'Pustakawan',
                      '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
