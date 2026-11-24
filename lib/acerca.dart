import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaApp extends StatefulWidget {
  const AcercaApp({super.key});

  @override
  State<AcercaApp> createState() => _AcercaAppState();
}

class _AcercaAppState extends State<AcercaApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de la aplicación'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: barColor()),
        ),
      ),
      body: Container(
        color: Colors.grey.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  'HERRAMIENTAS DE TEXTO',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'La aplicación cuenta con varias herramientas posibles, entre ellas están:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10.0),
              const Text(
                '- Creación, modificación y eliminación de notas almacenadas en la nube con el propósito de no ocupar espacio en el dispositivo.\n\n'
                '- Lector de códigos QR y códigos de barras ya sea por medio de la cámara del teléfono o por imagen de galería.\n\n'
                '- Creación de códigos QR con la opción de almacenar en galería.\n\n'
                '- Traductor de texto disponible para varios idiomas.\n\n'
                '- Reconocimiento de texto ya sea por medio de la cámara del teléfono o por imagen de galería.\n\n'
                '- Reconocimiento de voz a texto con opción de guardar como nota o traducir a otro idioma.\n\n'
                '- Convertir texto a voz con opción de elegir varios acentos de idiomas.\n\n'
                '- Reconocimiento de texto en archivos PDF con opción de traducir o escuchar.\n\n'
                '- Activar o desactivar las animaciones integradas en la aplicación.\n\n'
                '- Activar o desactivar el modo oscuro de la aplicación.\n\n'
                '- Actualizar datos de inicio de sesión.',
                style: TextStyle(fontSize: 14.0),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'En caso de encontrar fallas en la aplicación, por favor envíe sus comentarios al correo electrónico de soporte ($supportEmail).',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.all(const Size.fromWidth(200)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.red),
                  ),
                ),
                onPressed: () {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: supportEmail,
                  );
                  launchUrl(emailLaunchUri);
                },
                child: const Text(
                  'Enviar correo electrónico',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.all(const Size.fromWidth(200)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.green),
                  ),
                ),
                onPressed: () {
                  if (storeUrl.isNotEmpty) {
                    launchUrl(
                      Uri.parse(storeUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Enlace de tienda no configurado',
                    );
                  }
                },
                child: const Text(
                  'Calificar en la tienda',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
