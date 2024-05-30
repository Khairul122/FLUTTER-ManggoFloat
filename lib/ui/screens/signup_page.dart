import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/ui/screens/widgets/custom_textfield.dart';
import 'package:flutter_onboarding/ui/screens/signin_page.dart';
import 'package:flutter_onboarding/services/register_service.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ValueNotifier<String> _selectedAddressNotifier = ValueNotifier<String>('Batuphat');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // List of address options
    final List<String> addressOptions = [
      'Batuphat',
      'Cunda',
      'Blang Pulo',
      'Simpang Len',
      'Medan',
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/signup.png'),
              const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextfield(
                controller: _emailController,
                obscureText: false,
                hintText: 'Masukkan Email',
                icon: Icons.alternate_email,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextfield(
                controller: _nameController,
                obscureText: false,
                hintText: 'Masukkan Nama',
                icon: Icons.person,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextfield(
                controller: _passwordController,
                obscureText: true,
                hintText: 'Masukkan Password',
                icon: Icons.lock,
              ),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder<String>(
                valueListenable: _selectedAddressNotifier,
                builder: (context, selectedAddress, child) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.home),
                      hintText: 'Pilih Alamat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedAddress,
                    items: addressOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      _selectedAddressNotifier.value = newValue!;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextfield(
                controller: _phoneController,
                obscureText: false,
                hintText: 'Masukkan No Telp',
                icon: Icons.phone,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    final response = await ApiService.registerUser(
                      namaPengguna: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      alamat: _selectedAddressNotifier.value,
                      noTelepon: _phoneController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['status'] == 'success'
                            ? 'Registrasi berhasil'
                            : 'Registrasi gagal: ${response['message']}'),
                      ),
                    );
                    if (response['status'] == 'success') {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: SignIn(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Registrasi gagal: $e'),
                      ),
                    );
                  }
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: const Center(
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: SignIn(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Sudah Memiliki Akun? ',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Masuk',
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                    ]),
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
