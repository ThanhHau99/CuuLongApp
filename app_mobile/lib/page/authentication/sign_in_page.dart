import 'package:app_mobile/bloc/sign_in_bloc.dart';
import 'package:app_mobile/page/home_page/home_page.dart';
import 'package:app_mobile/services/auth.dart';
import 'package:app_mobile/share/app_button.dart';
import 'package:app_mobile/share/app_color.dart';
import 'package:app_mobile/share/app_images.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:app_mobile/share/app_textflie.dart';
import 'package:app_mobile/share/loading_task.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;

  const SignInPage({Key key, this.toggleView}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _showPass = false;
  bool loading = false;
  final TextEditingController _txtEmailController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingTask(
        loading: loading,
        child: SingleChildScrollView(
          child: Provider<SignInBloc>.value(
            value: SignInBloc(),
            child: Consumer<SignInBloc>(
              builder: (context, bloc, child) {
                return SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogoApp(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildContainer(bloc),
                        SizedBox(
                          height: 20,
                        ),
                        _buildSignUp(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoApp() {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Image.asset(
          AppImages.logoApp,
          height: size.height * 0.4,
          width: size.height * 0.4,
        ),
      ),
    );
  }

  Widget _buildContainer(SignInBloc bloc) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "Đăng nhập",
              style: AppStyle.h2.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _emailForm(bloc),
          _passForm(bloc),
          _buttonSignIn(bloc),
        ],
      ),
    );
  }

  Widget _buildSignUp() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chưa có tài khoản ? ',
            style: AppStyle.h6.copyWith(
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              widget.toggleView();
              print("Dang dang ky");
            },
            child: Text(
              "Đăng ký",
              style: AppStyle.h6.copyWith(
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailForm(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.emailStream,
      child: Consumer<String>(
        builder: (context, mess, child) => AppTextFile(
          onChangefunction: (text) {
            bloc.emailSink.add(text);
          },
          textController: _txtEmailController,
          lableTextFile: 'Email',
          hintTextFile: 'abc@gmail.com',
          iconFile: Icon(Icons.email),
          errorText: mess,
        ),
      ),
    );
  }

  Widget _passForm(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context, mess, child) => Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                onChanged: (text) {
                  bloc.passSink.add(text);
                },
                controller: _txtPassController,
                obscureText: !_showPass,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Mật khẩu',
                  hintText: '******',
                  prefixIcon: Icon(Icons.lock),
                  errorText: mess,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showPass = !_showPass;
                      });
                    },
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: _showPass ? AppColor.primaryColor : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonSignIn(SignInBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => AppButton(
          text: 'Đăng nhập',
          style: AppStyle.h4,
          onpressButton: enable
              ? () {
                  setState(() {
                    loading = true;
                  });
                  signInAction();
                }
              : null,
        ),
      ),
    );
  }

  void signInAction() {
    Future.delayed(Duration(seconds: 5), () async {
      print("dang nhap");
      dynamic result = await _auth.signInWithEmailAndPassword(
          email: _txtEmailController.text.trim(),
          password: _txtPassController.text.trim());

      if (result == 'Welcome') {
        print('sign in');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false);
      } else {
        print('erro login : $result');
        setState(() {
          loading = false;
        });
        showErrAlert(result);
      }
    });
  }

  void showErrAlert(String mess) {
    showTopSnackBar(
        context,
        CustomSnackBar.error(
          icon: null,
          message: mess,
          textStyle: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }
}
