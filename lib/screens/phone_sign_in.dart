import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:virusmapbr/services/phone_auth_service.dart';

class PhoneSignIn extends StatefulWidget {
  @override
  _PhoneSignInState createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  final phoneAuthService = PhoneAuthService();

  String _status = "begin";
  bool _isWaiting = false;

  TextEditingController _numberController;
  TextEditingController _codeController;

  String phoneNo;
  bool phoneValid = false;
  String _phoneNumberError;
  String _codeError;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: "");
    _codeController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VirusMapBRTheme.color(context, "modal"),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_isWaiting) LinearProgressIndicator(),
                _buildStatusPanel(),
                _buildControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPanel() {
    return Container(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 32.0,
                    width: 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color:
                          VirusMapBRTheme.color(context, "modal").withOpacity(0.2),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        color: VirusMapBRTheme.color(context, "white"),
                        icon: Icon(VirusMapBRIcons.return_icon),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildStatus()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -10),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildForm()],
            ),
          ),
        ],
      ),
    );
  }

  // Build the form for Phone/SMS authentication
  // The form will change according to the need to send the OTP code or not
  Widget buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            if (!phoneAuthService.codeSent) buildPhoneNumberInput(),
            if (phoneAuthService.codeSent) buildOTPCodeInput(),
            SizedBox(height: 32.0),
            buildFormSubmitButton()
          ],
        )
      ],
    );
  }

  // Build the phone number input field
  Widget buildPhoneNumberInput() {
    return TextField(
      controller: _numberController,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[+0-9]"))],
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.phone),
        labelText: "Número do telefone",
        helperText: "Use o formato +55 XX XXXXX XXXX",
        errorText: _phoneNumberError,
      ),
      onChanged: (val) {
        setState(() {
          _phoneNumberError = null;
          this.phoneNo = val;
          this.phoneValid = PhoneAuthService.isPhoneNumberValid(val);
        });
      },
    );
  }

  // Build the OTP code input field
  Widget buildOTPCodeInput() {
    if (phoneAuthService.codeSent) {
      return TextField(
        controller: _codeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.lock),
          labelText: "Digite o código de verificação",
          errorText: _codeError,
        ),
        onChanged: (val) {
          setState(() {
            _codeError = null;
            phoneAuthService.smsCode = val;
          });
        },
      );
    } else {
      return Container();
    }
  }

  // Build the form submit button
  Widget buildFormSubmitButton() {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 8.0,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                  child: Text(
                phoneAuthService.codeSent ? "Verificar" : "Continuar",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "white"))),
              )),
              onPressed: phoneValid
                  ? () {
                      setState(() {
                        _status = "waitingCode";
                        _isWaiting = true;
                      });
                      phoneAuthService.codeSent
                          ? phoneAuthService.verifyOTP(
                              onFailed: () {
                                setState(() {
                                  _status = "codeFailed";
                                  _codeError =
                                      "Código inválido. Tente novamente";
                                  _isWaiting = false;
                                });
                              },
                            )
                          : phoneAuthService.verifyPhone(
                              phoneNo,
                              onCodeSent: () {
                                setState(() {
                                  _status = "codeSent";
                                  _isWaiting = true;
                                  _codeError = null;
                                });
                              },
                              onTimeout: () {
                                setState(() {
                                  _status = "codeTimeout";
                                  _isWaiting = false;
                                });
                              },
                              onFailed: () {
                                setState(() {
                                  _status = "failed";
                                  _isWaiting = false;
                                  _phoneNumberError =
                                      "Número inválido. Tente novamente";
                                });
                              },
                            );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    switch (_status) {
      case "begin":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Olá! 👋🏼",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
            SizedBox(height: 4.0),
            Text(
              "Para ter acesso ao VirusMapBR, digite o número do seu celular.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )
          ],
        );
      case "waitingCode":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aguarde...",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
            SizedBox(height: 4.0),
            Text(
              "Aguarde o envio do código de verificação via SMS.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )
          ],
        );
      case "codeSent":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aguarde...",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
            SizedBox(height: 4.0),
            Text(
              "Já enviamos o código via SMS. Aguarde o recebimento.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )
          ],
        );
      case "codeTimeout":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Envie o código!",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
            SizedBox(height: 4.0),
            Text(
              "Não foi possível verificar automaticamente. Digite o código recebido por SMS.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )
          ],
        );
      case "codeFailed":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ops!",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
            SizedBox(height: 4.0),
            Text(
              "O código enviado está errado. Verifique se enviou o código correto e tente novamente.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )
          ],
        );
      case "failed":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ooops!",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
            SizedBox(height: 4.0),
            Text(
              "Não foi possível verificar o número do telefone. Verifique se ele está correto e tente novamente.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Erro desconhecido! 🤔",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
            SizedBox(height: 4.0),
            Text(
              "Aconteceu um erro desconhecido. Tente novamente por favor.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )
          ],
        );
    }
  }
}
