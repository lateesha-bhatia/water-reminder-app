import 'dart:async';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:gif_view/gif_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(500, 500),
    center: false,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAsFrameless();
    await windowManager.setHasShadow(false);
    await windowManager.setAlignment(Alignment.bottomRight);
    await windowManager.setAlwaysOnTop(true);
  });

  runApp(const WaterReminderApp());
}

class WaterReminderApp extends StatelessWidget {
  const WaterReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FloatingCharacter(),
    );
  }
}

class FloatingCharacter extends StatefulWidget {
  const FloatingCharacter({super.key});

  @override
  State<FloatingCharacter> createState() => _FloatingCharacterState();
}

class _FloatingCharacterState extends State<FloatingCharacter> {
  bool _isOutro = false;
  Timer? _backgroundTimer;
  Timer? _anim1StopTimer;

  late GifController _introController;
  late GifController _outroController;

  @override
  void initState() {
    super.initState();
    _introController = GifController();
    _outroController = GifController();

    // Safely start the sequence here, without precaching
    _startIntroSequence();
  }

  void _startIntroSequence() async {
    setState(() {
      _isOutro = false;
    });

    await windowManager.show();
    await windowManager.focus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _introController.play(initialFrame: 0);

      _anim1StopTimer?.cancel();
      _anim1StopTimer = Timer(const Duration(seconds: 9), () {
        _introController.pause();
      });
    });
  }

  void _triggerOutroAndSchedule(int minutesToWait) {
    _anim1StopTimer?.cancel();

    setState(() {
      _isOutro = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _outroController.play(initialFrame: 0);
    });

    Future.delayed(const Duration(seconds: 8), () async {
      await windowManager.hide();

      _backgroundTimer?.cancel();
      _backgroundTimer = Timer(Duration(minutes: minutesToWait), () {
        _startIntroSequence();
      });
    });
  }

  @override
  void dispose() {
    _backgroundTimer?.cancel();
    _anim1StopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 500,
            height: 300,
            child:
                _isOutro
                    ? GifView.asset(
                      'assets/anim2.gif',
                      controller: _outroController,
                      loop: false,
                      fit: BoxFit.contain,
                    )
                    : GifView.asset(
                      'assets/anim1.gif',
                      controller: _introController,
                      loop: false,
                      fit: BoxFit.contain,
                    ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 20.0,
              right: 70.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _triggerOutroAndSchedule(60),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      Set<WidgetState> states,
                    ) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.blue;
                      }
                      return Colors.blueGrey.shade600;
                    }),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                  child: const Text(
                    "I Drank Water!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _triggerOutroAndSchedule(5),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Snooze",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    GestureDetector(
                      onTap: () => _triggerOutroAndSchedule(5),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "5",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: () => _triggerOutroAndSchedule(10),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "10",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
