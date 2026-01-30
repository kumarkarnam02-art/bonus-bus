import 'package:flutter/material.dart';
import 'location_access_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showOtp = false;
  bool loading = false;
  bool otpSent = false;
  int resendTimer = 30;
  
  final TextEditingController mobileCtrl = TextEditingController();
  final List<TextEditingController> otpCtrl =
      List.generate(6, (_) => TextEditingController());

  // Demo OTP for testing
  final String demoOTP = "123456";

  @override
  void initState() {
    super.initState();
    // Start resend timer if OTP is shown
    if (showOtp) {
      startResendTimer();
    }
  }

  void startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (resendTimer > 0) {
        setState(() => resendTimer--);
        startResendTimer();
      }
    });
  }

  void sendOTP() {
    if (mobileCtrl.text.length != 10) {
      showSnack("Please enter a valid 10-digit mobile number");
      return;
    }

    setState(() {
      loading = true;
      otpSent = false;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showOtp = true;
        loading = false;
        otpSent = true;
        resendTimer = 30;
      });
      
      startResendTimer();
      showSnack("OTP sent to +91 ${mobileCtrl.text}");
    });
  }

  void verifyOTP() {
    String enteredOTP = otpCtrl.map((ctrl) => ctrl.text).join();
    
    if (enteredOTP.length != 6) {
      showSnack("Please enter 6-digit OTP");
      return;
    }

    setState(() => loading = true);

    // Simulate verification
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => loading = false);
      
      // For demo, accept any 6-digit OTP or the demo OTP
      if (enteredOTP == demoOTP || enteredOTP.length == 6) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LocationAccessPage(),
          ),
        );
      } else {
        showSnack("Invalid OTP. Try again or use: $demoOTP");
      }
    });
  }

  void resendOTP() {
    if (resendTimer > 0) return;
    
    setState(() {
      loading = true;
      resendTimer = 30;
    });
    
    // Simulate resend
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
        otpSent = true;
      });
      startResendTimer();
      showSnack("New OTP sent to +91 ${mobileCtrl.text}");
    });
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF00C853),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0F2027),
              const Color(0xFF203A43),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Skip for demo
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LocationAccessPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Skip for demo",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App Logo & Title
                  Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00C853).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.electric_car,
                          size: 60,
                          color: Color(0xFF00C853),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Bonus bus",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Electric Vehicle Booking",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Login Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            showOtp ? "Verify OTP" : "Login / Sign Up",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            showOtp 
                                ? "Enter the 6-digit code sent to +91 ${mobileCtrl.text}"
                                : "Enter your mobile number to continue",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Mobile Input or OTP Input
                          if (!showOtp) _buildMobileInput() else _buildOtpInput(),

                          const SizedBox(height: 20),

                          // Demo OTP Hint
                          if (showOtp)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue.shade100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info, color: Colors.blue.shade700, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Demo OTP: $demoOTP",
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 30),

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: loading ? null : (showOtp ? verifyOTP : sendOTP),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00C853),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                              ),
                              icon: loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      showOtp ? Icons.verified : Icons.send,
                                      size: 22,
                                    ),
                              label: loading
                                  ? const Text("Please wait...")
                                  : Text(
                                      showOtp ? "VERIFY & CONTINUE" : "SEND OTP",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          // Back/Resend Options
                          if (showOtp) ...[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      showOtp = false;
                                      // Clear OTP fields
                                      for (var ctrl in otpCtrl) {
                                        ctrl.clear();
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_back, size: 18),
                                  label: const Text("Change Number"),
                                ),
                                TextButton.icon(
                                  onPressed: resendTimer > 0 ? null : resendOTP,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: Text(
                                    resendTimer > 0
                                        ? "Resend in ${resendTimer}s"
                                        : "Resend OTP",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Terms and Privacy
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: "By continuing, you agree to our ",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                              color: Color(0xFF00C853),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              color: Color(0xFF00C853),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Alternative Login Options
                  Column(
                    children: [
                      Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(Icons.email, "Email"),
                          const SizedBox(width: 20),
                          _buildSocialButton(Icons.g_mobiledata, "Google"),
                          const SizedBox(width: 20),
                          _buildSocialButton(Icons.facebook, "Facebook"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileInput() {
    return Column(
      children: [
        TextField(
          controller: mobileCtrl,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            labelText: "Mobile Number",
            hintText: "Enter 10-digit mobile number",
            prefix: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text("+91", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onChanged: (value) {
            // Only allow numbers
            if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
              mobileCtrl.text = value.replaceAll(RegExp(r'[^0-9]'), '');
              mobileCtrl.selection = TextSelection.fromPosition(
                TextPosition(offset: mobileCtrl.text.length),
              );
            }
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.info, color: Colors.green.shade700, size: 16),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "We'll send an OTP to verify your number",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: TextField(
                controller: otpCtrl[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    FocusScope.of(context).nextFocus();
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).previousFocus();
                  }
                  
                  if (index == 5 && value.isNotEmpty) {
                    bool allFilled = otpCtrl.every((ctrl) => ctrl.text.isNotEmpty);
                    if (allFilled) {
                      Future.delayed(const Duration(milliseconds: 300), verifyOTP);
                    }
                  }
                },
              ),
            ),
          );
        }),
      ),
      // ... rest of your code
    ],
  );
}
  Widget _buildSocialButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}