import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersupabase/acerca.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/pages_auth/no_internet.dart';
import 'package:fluttersupabase/pages_no_auth/home_no_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    theme = false;
    animationState = true;
  });

  tearDown(() {
    theme = false;
    animationState = true;
  });

  group('Configuración y utilidades de red', () {
    test('las credenciales por defecto no contienen secretos ni PII personal', () {
      expect(supabaseUrl, isEmpty);
      expect(supabaseAnonKey, isEmpty);
      expect(supportEmail, equals('soporte@ejemplo.com'));
      expect(supportEmail.contains('daniel'), isFalse);
      expect(storeUrl, isEmpty);
      expect(
        loginRedirectUrl,
        equals('com.herramientasdetexto.app://login-callback/'),
      );
      expect(
        resetRedirectUrl,
        equals('com.herramientasdetexto.app://reset-callback/'),
      );
    });

    test('hasInternetConnection detecta tipos de red válidos', () {
      expect(hasInternetConnection([ConnectivityResult.wifi]), isTrue);
      expect(hasInternetConnection([ConnectivityResult.ethernet]), isTrue);
      expect(hasInternetConnection([ConnectivityResult.mobile]), isTrue);
      expect(
        hasInternetConnection([ConnectivityResult.none]),
        isFalse,
      );
      expect(
        hasInternetConnection([ConnectivityResult.bluetooth]),
        isFalse,
      );
      expect(hasInternetConnection([]), isFalse);
    });

    test('isNetworkError clasifica excepciones de red y de aplicación', () {
      expect(
        isNetworkError(const SocketException('Failed host lookup')),
        isTrue,
      );
      expect(
        isNetworkError(Exception('ClientException: Connection refused')),
        isTrue,
      );
      expect(
        isNetworkError(Exception('Invalid login credentials')),
        isFalse,
      );
    });
  });

  group('Selectores de tema y colores', () {
    test('retorna colores correctos en modo claro y oscuro', () {
      theme = false;
      expect(menuBackgroundColor(), equals(Colors.green));
      expect(colorContainer(), equals(Colors.white));
      expect(barColor(), isA<LinearGradient>());
      expect(barColorScreen(), isA<LinearGradient>());

      theme = true;
      expect(menuBackgroundColor(), equals(Colors.grey.shade900));
      expect(colorContainer(), equals(Colors.grey.shade300));
      expect(barColor(), isA<LinearGradient>());
      expect(barColorScreen(), isA<LinearGradient>());
    });
  });

  group('Renderizado de pantallas sin sesión requerida', () {
    testWidgets('AcercaApp renderiza información de soporte sin PII personal',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: AcercaApp(),
        ),
      );

      expect(find.text('HERRAMIENTAS DE TEXTO'), findsOneWidget);
      expect(find.text('Enviar correo electrónico'), findsOneWidget);
      expect(find.text('Calificar en la tienda'), findsOneWidget);
      expect(find.textContaining('soporte@ejemplo.com'), findsOneWidget);
      expect(find.textContaining('danielixo99'), findsNothing);
    });

    testWidgets('UserNoAuth muestra las herramientas disponibles y restringidas',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: UserNoAuth(),
        ),
      );

      expect(find.text('Menu principal'), findsOneWidget);
      expect(find.text('LISTA DE NOTAS'), findsOneWidget);
      expect(find.text('TRADUCTOR DE TEXTO'), findsOneWidget);
      expect(find.text('TEXTO EN IMAGEN'), findsOneWidget);
      expect(find.text('ABRIR PDF'), findsOneWidget);
      expect(find.text('ACERCA DE LA APLICACIÓN'), findsOneWidget);
    });

    testWidgets('NoInternet muestra la vista de reconexión y modo sin internet',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => const NoInternet(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Sin conexión'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
      expect(
        find.text('Usar sin internet\n(Se limitarán ciertas funciones)'),
        findsOneWidget,
      );
    });
  });

  group('Integridad de activos gráficos y animaciones Lottie', () {
    const lottieAssets = [
      'images/lottie/arrowdown.zip',
      'images/lottie/delete.zip',
      'images/lottie/empty.zip',
      'images/lottie/hello.zip',
      'images/lottie/imagetext.zip',
      'images/lottie/logo.zip',
      'images/lottie/microphone.zip',
      'images/lottie/nointernet.zip',
      'images/lottie/notes.zip',
      'images/lottie/pdf.zip',
      'images/lottie/qr.zip',
      'images/lottie/question.zip',
      'images/lottie/recording.zip',
      'images/lottie/searching.zip',
      'images/lottie/speaker.zip',
      'images/lottie/translate.zip',
      'images/lottie/update.zip',
    ];

    const imageAssets = [
      'images/camera.png',
      'images/capturetext.png',
      'images/createQR.png',
      'images/galleryPicture.png',
      'images/logov5.png',
      'images/notes.png',
      'images/pdf.png',
      'images/qr.png',
      'images/recording.png',
      'images/scanPhone.png',
      'images/speaker.png',
      'images/stop.png',
      'images/sweep.png',
      'images/translate.png',
    ];

    test('todos los archivos Lottie ZIP se decodifican correctamente', () async {
      for (final assetPath in lottieAssets) {
        final data = await rootBundle.load(assetPath);
        final composition = await LottieComposition.fromByteData(data);
        expect(
          composition.duration,
          greaterThan(Duration.zero),
          reason: '$assetPath debe tener una duración positiva',
        );
      }
    });

    test('todos los iconos PNG referenciados existen y no están vacíos',
        () async {
      for (final assetPath in imageAssets) {
        final data = await rootBundle.load(assetPath);
        expect(
          data.lengthInBytes,
          greaterThan(0),
          reason: '$assetPath no debe estar vacío',
        );
      }
    });
  });
}
