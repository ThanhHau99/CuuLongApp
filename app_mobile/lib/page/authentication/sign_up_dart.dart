import 'package:app_mobile/bloc/sign_up_bloc.dart';
import 'package:app_mobile/page/wrapper/authentication.dart';
import 'package:app_mobile/services/auth.dart';
import 'package:app_mobile/share/app_button.dart';
import 'package:app_mobile/share/app_color.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:app_mobile/share/app_textflie.dart';
import 'package:app_mobile/share/loading_task.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleView;
  const SignUpPage({Key key, this.toggleView}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthService _auth = AuthService();
  bool _showPass = false;
  bool _showRePass = false;
  bool _loading = false;
  TextEditingController _txtNameController = TextEditingController();
  TextEditingController _txtPhoneController = TextEditingController();
  TextEditingController _txtEmailController = TextEditingController();
  TextEditingController _txtPassController = TextEditingController();
  TextEditingController _txtRePassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Provider<SignUpBloc>.value(
      value: SignUpBloc(),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: LoadingTask(
            loading: _loading,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: _buildContainer(bloc),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildSignIn(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(SignUpBloc bloc) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "Đăng ký",
              style: AppStyle.h2.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _nameForm(bloc),
          _phoneForm(bloc),
          _emailForm(bloc),
          _passForm(bloc),
          _rePassForm(bloc),
          _buttonSignUp(bloc),
        ],
      ),
    );
  }

  Widget _buildSignIn() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ban đã có tài khoản ? ',
            style: AppStyle.h6.copyWith(
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              widget.toggleView();
              print("Dang dang nhap");
            },
            child: Text(
              "Đăng nhập",
              style: AppStyle.h6.copyWith(
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameForm(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.nameStream,
      child: Consumer<String>(
        builder: (context, mess, child) => AppTextFile(
          textController: _txtNameController,
          onChangefunction: (text) {
            bloc.nameSink.add(text);
          },
          lableTextFile: 'Tên',
          hintTextFile: 'Nhập tên của bạn',
          iconFile: Icon(Icons.person),
          errorText: mess,
        ),
      ),
    );
  }

  Widget _phoneForm(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder: (context, mess, child) => AppTextFile(
          textController: _txtPhoneController,
          onChangefunction: (text) {
            bloc.phoneSink.add(text);
          },
          lableTextFile: 'Số điện thoại',
          hintTextFile: 'Nhập số điện thoại',
          iconFile: Icon(Icons.phone),
          errorText: mess,
        ),
      ),
    );
  }

  Widget _emailForm(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.emailStream,
      child: Consumer<String>(
        builder: (context, mess, child) => AppTextFile(
          textController: _txtEmailController,
          onChangefunction: (text) {
            bloc.emailSink.add(text);
          },
          lableTextFile: 'Email',
          hintTextFile: 'abc@gmail.com',
          iconFile: Icon(Icons.email),
          errorText: mess,
        ),
      ),
    );
  }

  Widget _passForm(SignUpBloc bloc) {
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
                controller: _txtPassController,
                onChanged: (text) {
                  bloc.passSink.add(text);
                },
                obscureText: !_showPass,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Mật khẩu',
                  hintText: '******',
                  prefixIcon: Icon(Icons.lock),
                  errorText: mess,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15, bottom: 19),
              child: GestureDetector(
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
          ],
        ),
      ),
    );
  }

  Widget _rePassForm(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.rePassStream,
      child: Consumer<String>(
        builder: (context, mess, child) => Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _txtRePassController,
                onChanged: (text) {
                  //bloc.rePassSink.add(text);
                },
                obscureText: !_showRePass,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Nhập lại mật khẩu',
                  hintText: '******',
                  prefixIcon: Icon(Icons.lock),
                  //errorText: mess,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15, bottom: 19),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showRePass = !_showRePass;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: _showRePass ? AppColor.primaryColor : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonSignUp(SignUpBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => AppButton(
          text: 'Đăng ký',
          style: AppStyle.h4,
          onpressButton: enable
              ? () {
                  setState(() {
                    _loading = true;
                  });
                  signUpAction();
                }
              : null,
        ),
      ),
    );
  }

  void signUpAction() {
    Future.delayed(Duration(seconds: 5), () async {
      print("Dang ky");

      dynamic result = await _auth.signUpWithEmailAndPassWord(
          _txtNameController.text.trim(),
          _txtPhoneController.text.trim(),
          _txtEmailController.text.trim(),
          _txtPassController.text.trim(), [], []);
      if (result == "Account created") {
        showSuccesAlert();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AuthenticationPage()),
            (route) => false);
        setState(() {
          _txtNameController.text = '';
          _txtPhoneController.text = '';
          _txtEmailController.text = '';
          _txtPassController.text = '';
          _txtRePassController.text = '';
        });
      } else {
        print("Dang ky that bai");
        setState(() {
          _loading = false;
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

  void showSuccesAlert() {
    showTopSnackBar(
        context,
        CustomSnackBar.success(
          icon: null,
          backgroundColor: Colors.green,
          message: "Đăng ký thành công",
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ));
  }
}
