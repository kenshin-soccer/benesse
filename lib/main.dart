import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; 
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Stopwatch _stopwatch = Stopwatch(); // 学習時間計測用のストップウォッチ
  Timer? _timer; // ストップウォッチのタイマー
  int _level = 0; // レベルの初期値
  int _lastLevelIncrementTime = 0; // 最後にレベルが上がった時間
  bool _isRunning = false; // タイマーが動作中かどうか

  Stopwatch _persistentStopwatch = Stopwatch(); // アプリ起動からの経過時間を計測するストップウォッチ
  Timer? _persistentTimer; // 永続タイマーのタイマー
  int _nakamalevelA = 203;
  int _nakamalevelB = 1080;
  int _nakamalevelC = 0;
  int _nakamalevelD = 603;
  int _lastNakamalevelIncrementTimeA = 0;
  int _lastNakamalevelIncrementTimeB = 0;
  int _lastNakamalevelIncrementTimeC = 0;
  int _lastNakamalevelIncrementTimeD = 0;

  final List<String> _quotes = [
    '今日の成果は過去の努力の結果であり、未来はこれからの努力で決まる',
    '真剣だからこそ、ぶつかる壁がある',
    '100点は無理かもしれん。でもMAXなら出せるやろ',
    '人にできて、きみだけにできないことなんてあるもんか',
    '努力は必ず報われる。もし報われない努力があるのならば、それはまだ努力と呼べない',
    'できると思えばできる、できないと思えばできない',
    'つらい道を避けないこと。自分の目指す場所にたどりつくためには進まなければ',
    '学ぶことで才能は開花する。志がなければ、学問の完成はない',
    '入試のプレッシャーに負けない自信。明確な根拠のある自信。それを得るためにはひたすら勉強するしかない',
    '「どうせ無理」は、ラクしたいから',
    '何事も達成するまでは不可能に見えるものである',
    '今を戦えない者に次とか来年とかを言う資格はない',
    '自分の弱さに向き合ってこそ努力は実る',
    '１カ月頑張れるかどうかで人生が変わる',
    '「できなくてもしょうがない」は、終わってから思うことであって、途中にそれを思ったら、絶対に達成できません',
    '才能とは何かと問われれば、「続けることだ」と私は答える。実はこれが最も難しいのです',
    '苦しいから逃げるのでない。逃げるから苦しくなるのだ',
  ];

  String _currentQuote = ''; // 現在表示されている名言

  @override
  void initState() {
    super.initState();
    _persistentStopwatch.start(); // アプリ起動時に永続ストップウォッチを開始
    _persistentTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        int elapsedSeconds = _persistentStopwatch.elapsedMilliseconds ~/ 1000;
        if (elapsedSeconds - _lastNakamalevelIncrementTimeA >= 10) {
          _nakamalevelA++;
          _lastNakamalevelIncrementTimeA = elapsedSeconds;
        }
        if (elapsedSeconds - _lastNakamalevelIncrementTimeB >= 10) {
          _nakamalevelB++;
          _lastNakamalevelIncrementTimeB = elapsedSeconds;
        }
        if (elapsedSeconds - _lastNakamalevelIncrementTimeC >= 10) {
          _nakamalevelC++;
          _lastNakamalevelIncrementTimeC = elapsedSeconds;
        }
        if (elapsedSeconds - _lastNakamalevelIncrementTimeD >= 10) {
          _nakamalevelD++;
          _lastNakamalevelIncrementTimeD = elapsedSeconds;
        }
        // 10分ごとに名言を更新
        if (elapsedSeconds % 20 == 0) {
          _updateQuote();
        }
      });
    });
    // 初期表示の名言を設定
    _updateQuote();
  }

  // ランダムな名言を更新する関数
  void _updateQuote() {
    final random = Random();
    setState(() {
      _currentQuote = _quotes[random.nextInt(_quotes.length)];
    });
  }

  // 学習タイマーを開始する関数
  void _startTimer() {
    if (!_stopwatch.isRunning) {
      setState(() {
        _stopwatch.start();
        _isRunning = true;
      });
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        setState(() {
          int elapsedSeconds = _stopwatch.elapsedMilliseconds ~/ 1000;
          if (elapsedSeconds - _lastLevelIncrementTime >= 10) {
            _level++;
            _lastLevelIncrementTime = elapsedSeconds;
          }
        });
      });
    }
  }

  // 学習タイマーを停止する関数
  void _stopTimer() {
    if (_stopwatch.isRunning) {
      setState(() {
        _stopwatch.stop();
        _isRunning = false;
      });
      _timer?.cancel();
    }
  }

  // 時間を分:秒の形式にフォーマットする関数
  String _formatTime(int milliseconds) {
    int totalSeconds = milliseconds ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String formattedTime =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  // 初期値を持つ永続タイマーの時間をフォーマットする関数
  String _formatPersistentTime(int milliseconds, {String initial = '00:00'}) {
    int totalSeconds = milliseconds ~/ 1000;
    int initialMinutes = int.parse(initial.split(':')[0]);
    int initialSeconds = int.parse(initial.split(':')[1]);
    int totalInitialSeconds = initialMinutes * 60 + initialSeconds;

    int displaySeconds = totalSeconds + totalInitialSeconds;
    int displayMinutes = displaySeconds ~/ 60;
    displaySeconds = displaySeconds % 60;

    return "${displayMinutes.toString().padLeft(2, '0')}:${displaySeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _persistentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String persistentTime = _formatTime(_persistentStopwatch.elapsedMilliseconds);

    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // ホームアイコンが押されたときの処理をここに記述
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      // メニューアイコンが押されたときの処理をここに記述
                    },
                  ),
                  SizedBox(width: 10),
                  Text('夏季模試対策'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj8xP2FGiCtrON7YRbPZJ6fl5dH3IL4fKipjy1SV36iZ1-V2eOBcF2-fAc-fFfS9hy2l3BIhPPRX4vLbiRmYt0VcPwl-mWzNeWYkj3ZmlkvGEa_GoZqRv8sUJVu5HkojUZcyslTwHV-nV9J/s800/scool_room_kyoushitsu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.green[900]!, 
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.brown, 
                      width: 3.0,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    _currentQuote, // ランダムな名言を表示
                    style: GoogleFonts.notoSans(
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white, 
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                width: double.infinity,
                height: 180, 
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(5.0),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '勉強中',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  _formatPersistentTime(_persistentStopwatch.elapsedMilliseconds, initial: '18:10'),
                                  style: TextStyle(fontSize: 22.0), // フォントサイズを少し小さく
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Lv, $_nakamalevelA',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'こうき',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Image.network(
                              'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgPEnaTjO3Bhl_nUapYh7CYQCGcvNFv0KIDbWOPhdQSg-Cz4zh1nHBfxVoTwt-sN2NdeV6sRggpFUgwxWxhILZnT0Dc2N2d3eBz-urwwzpPwdYkfN29HqzmaTAN9DCVdXWbhrz7h870_SYf/s1600/fantasy_game_character_slime.png',
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(5.0),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '勉強中',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  _formatPersistentTime(_persistentStopwatch.elapsedMilliseconds, initial: '70:50'),
                                  style: TextStyle(fontSize: 22.0), // フォントサイズを少し小さく
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Lv, $_nakamalevelB',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'ゆーや',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Image.network(
                              'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi0o_QLRn_a_aLXyTv-CYBrpSROZdf8mQVLY8lnBpVCKu-Axae10-P8BFYmLUcc0Artkp27IOgSTe9R2Cuy-VA4DQ4KlroQWDfAnkb_hXi-wyJo9R1F-FuSp3e-O1Ayqkh5He8Qy-3TJ05q/s800/character_egypt_anubis.png',
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(5.0),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '休憩中',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '63:20',
                                  style: TextStyle(fontSize: 22.0), // フォントサイズを少し小さく
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Lv, 380',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'あつや',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Image.network(
                              'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgfOQsYhH4Ia6C9dMDw0b3Yac25x345PGStFSEdssYMlD8onRTqqMOZNNeg-eRmAud1WYJDlsLMmwYhXmFAmHZvAreW1l61XMBIR22EEhrGbKoLls8z4nHgCQfyZeqkOQzCUjYqPYRXAf21/s800/fantasy_konton.png',
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(5.0),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '勉強中',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  _formatPersistentTime(_persistentStopwatch.elapsedMilliseconds, initial: '43:40'),
                                  style: TextStyle(fontSize: 22.0), // フォントサイズを少し小さく
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Lv, $_nakamalevelD',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'そうま',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Image.network(
                              'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjVEf41Ky9hL_GEoqkKm8GOSLR_WtTSjhOoTFAIqvD4tt0YwdtiLXznZOalZSsW5KIitKZaFvAI4Cpv9Mhkx8z_iTzRG7IAeveAeVk44HwXlGkryrkPYdl2dwnsYERhedIqRAfTe4LyZ5DU/s800/kaiju.png',
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _isRunning ? Colors.green[200] : Colors.blue[200],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _isRunning ? "勉強中" : "休憩中",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 5), 
                          Text(
                            _formatTime(_stopwatch.elapsedMilliseconds),
                            style: TextStyle(fontSize: 32.0),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Lv,${_level} けんしん",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    Image.network(
                      'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg48GxlSXF_4b4XZmtOALPhe3mD5iREyN-Ks6Q2hdviWeDHOcG_AUOS3nn2i-E9g5jD1_7-2o9PZF5MUQEanceM7b07viAr9M6h4C7jDqGhKdF0LzHzn2IBS_A2Fvpv605wIRf9ohIPiv-HStNDjk8JdN2hU-0GTI-OsjRraMo1HnGkTALf6v7qBbHufj04/s776/pose_galpeace_schoolgirl.png',
                      width: MediaQuery.of(context).size.width * 0.4, 
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.8, 
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: Text('Start'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _stopTimer,
                    child: Text('Stop'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
