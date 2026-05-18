import 'package:flutter/material.dart';
//Auth
import '../../features/auth/login.dart';
import '../../features/auth/signup.dart';
import '../../features/auth/signup2.dart';
//Landing Page
import '../../features/landing_page/landing_page.dart';
import '../../features/landing_page/onboarding_page.dart';
//Home
import '../../features/home/home_customer.dart';
import '../../features/home/home_kasir.dart';
// Cart
import '../../features/cart/cart_customer.dart';
//Notifications
import '../../features/notifications/notification_customer.dart';
//Orders
import '../../features/orders/order_customer.dart';
//Profile
import '../../features/profile/profile_customer.dart';
import '../../features/profile/edit_informasi_akun.dart';
import '../../features/scan/scan_customer.dart';

class AppRoutes {
  // Nama-nama route
  //Landing Page
  static const String onboarding = '/onboarding';
  static const String landingPage = '/landing-page';
  //Auth
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signup2 = '/signup2';
  //Home
  static const String homeCustomer = '/home-customer';
  static const String homeKasir = '/home-kasir';
  //Cart n Order
  static const String cartCustomer = '/cart-customer';
  static const String orderCustomer = '/order-customer';
  //Scan
  static const String scanCustomer = '/scan-customer';
  //Profile
  static const String profileCustomer = '/profile-customer';
  static const String editInformasiAkun = '/edit-informasi-akun';
  //Notifications
  static const String notificationCustomer = '/notification-customer';

  // Map untuk digunakan di MaterialApp
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      initial: (_) => const LandingPage(),
      signup: (_) => const SignUpScreen(),
      login: (_) => const LoginScreen(),
      onboarding: (_) => const WelcomePage(),
      homeKasir: (_) => const DashboardKasirPage(),
      homeCustomer: (_) => const HomeScreen(),
      cartCustomer: (_) => const CartCustomerPage(),
      orderCustomer: (_) => const MyOrderPage(),
      scanCustomer: (_) => const ScanCustomerPage(),
      profileCustomer: (_) => const ProfileCustomer(),
      notificationCustomer: (_) => const NotificationCustomerPage(),

      signup2: (context) {
        // Ambil data dari arguments jika ada
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] ?? '';
        final username = args?['username'] ?? '';
        final password = args?['password'] ?? '';

        return Signup2(email: email, username: username, password: password);
      },

      editInformasiAkun: (context) {
        // Ambil data user dari arguments jika ada
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final nama = args?['nama'] ?? '';
        final telepon = args?['telepon'] ?? '';
        final email = args?['email'] ?? '';
        final username = args?['username'] ?? '';

        return EditInformasiAkun(
          namaAwal: nama,
          teleponAwal: telepon,
          emailAwal: email,
          usernameAwal: username,
        );
      },
    };
  }
}
