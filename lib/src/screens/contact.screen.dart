import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:ventas_app/src/providers/user_provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactState();
}

class _ContactState extends State<ContactScreen> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController text = TextEditingController();

  void pressCall(String tel) {
    launchUrlString("tel://$tel");
  }

  sendEmail() async {
    if (validForm()) {
      String htmlEmail =
          "<h1>SE RECIBIO UN COMENTARIO DESDE EL SISTEMA DE ANUNCIOS EMPRESARIALES CON LA SIGUIENTE INFORMACÓN DE CONTACTO</h1>";
      htmlEmail += "<p>NOMBRE: ${name.text}</p>";
      htmlEmail += "<p>CORREO CONTACTO:  ${email.text}</p>";
      htmlEmail += "<p>MENSAJE: ${text.text}</p>";
      htmlEmail +=
          "<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged</p>";

      final smtpServer = SmtpServer('smtp.zoho.com',
          port: 587, username: 'hola@mexicof3.com', password: '2EBHKpbcqh9.');

      final message = Message()
        ..from = const Address('hola@mexicof3.com', 'Flutter app')
        ..recipients.add(email.text)
        ..subject = 'Flutter app!'
        ..html = htmlEmail;

      try {
        await send(message, smtpServer);
        _messangerKey.currentState!.showSnackBar(SnackBar(
          content: const Text('Correo enviado!!'),
          backgroundColor: Colors.green.shade300,
        ));
        name.text = "";
        email.text = "";
        text.text = "";
      } catch (e) {
        _messangerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Error enviar correo: $e'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    } else {
      String errorMessage = validMessage();
      _messangerKey.currentState!.showSnackBar(SnackBar(
        content: Text('Completar todos los datos, $errorMessage'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  bool validForm() {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email.text) &&
        text.text.isNotEmpty &&
        text.text.length <= 100 &&
        name.text.isNotEmpty &&
        name.text.length <= 50;
  }

  String validMessage() {
    String message = "";
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.text)) message += "Correo invalido ";

    if (text.text.isEmpty || text.text.length > 100) {
      message += "Mensaje invalido ";
    }

    if (name.text.isEmpty || name.text.length > 50) {
      message += "Nombre invalido ";
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Contacto"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Text(providerUser.name),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 23.0, bottom: 23.0),
                      child: SizedBox(
                        height: 150,
                        child: Image(
                            image: AssetImage('assets/images/user.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.phone, size: 20),
                            ),
                            TextSpan(
                                text: "Llamar",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    color: const Color.fromARGB(255, 192, 192, 192),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {pressCall("9371282874")},
                          child: const Column(children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Text(
                                "Teléfono",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0, left: 30),
                              child: Text(
                                "+52 9371282874",
                                style: TextStyle(
                                    fontSize: 13,
                                    backgroundColor: Colors.blueGrey,
                                    color: Colors.white),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.mail, size: 20),
                            ),
                            TextSpan(
                                text: " Correo",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nombre (*)"),
                      TextField(
                        controller: name,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Correo Contacto (*)"),
                      TextField(
                        controller: email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Texto Correo (*)"),
                      TextField(
                        controller: text,
                        maxLength: 100,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EasyButton(
                          idleStateWidget: const Text(
                            'Enviar Correo',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          loadingStateWidget: const CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                          useWidthAnimation: true,
                          useEqualLoadingStateWidgetDimension: true,
                          width: 150.0,
                          height: 40.0,
                          borderRadius: 4.0,
                          contentGap: 6.0,
                          buttonColor: Colors.blueAccent,
                          onPressed: (sendEmail),
                        ),
                      ]),
                ),
              ]),
            )));
  }
}
