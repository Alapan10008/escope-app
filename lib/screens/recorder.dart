import 'dart:async';
import 'package:escope/screens/sound_recoder.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class RecorderScreen extends StatefulWidget {
  String new_filename="";
  String new_name="";
  String new_age="";


  RecorderScreen({
    Key?key,
    required this.new_filename, required  this.new_name, required this.new_age
  }):super(key:key);

  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}


class _RecorderScreenState extends State<RecorderScreen> {

  bool _isRecording = false;
  // ignore: cancel_subscriptions
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  double? maxDB;
  double? meanDB;
  List<_ChartData> chartData = <_ChartData>[];
  // ChartSeriesController? _chartSeriesController;
  late int previousMillis;


  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!this._isRecording) this._isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

    chartData.add(
      _ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 1000)
            .toDouble(),
      ),
    );
  }

  void onError(Object e) {
    print(e.toString());
    _isRecording = false;
  }

  void start() async {
    previousMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    try {
      _noiseSubscription!.cancel();
      _noiseSubscription = null;

      setState(() => this._isRecording = false);
    } catch (e) {
      print('stopRecorder error: $e');
    }
    previousMillis = 0;
    chartData.clear();
  }

  void copyValue(
      bool theme,
      ) {
    Clipboard.setData(
      ClipboardData(
          text: 'It\'s about ${maxDB!.toStringAsFixed(1)}dB loudness'),
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 2500),
          content: Row(
            children: [
              Icon(
                Icons.check,
                size: 14,
                color: theme ? Colors.white70 : Colors.black,
              ),
              SizedBox(width: 10),
              Text('Copied')
            ],
          ),
        ),
      );
    });
  }

  final recorder =SoundRecorder();
  double? frequency;
  String? note;
  int? octave;
  bool? isRecording;

  @override
  void initState(){
    super.initState();
    recorder.init();
    _noiseMeter = NoiseMeter(onError);
  }
  @override
  void dispose(){
    super.dispose();
    recorder.dispose();
  }
  Duration duration=Duration();

  int minutes=00;
  int seconds =00;

  Timer? timer;
  void reset() =>setState(() =>duration=Duration());
  void startTimer({bool resets=true}){
    if(!mounted)return;
    if(resets){
      reset();
    }
    timer=Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds>58) setState(()=>{minutes++,seconds=0,});
      else {setState(()=>seconds++);}

    },);
  }
  void stopTimer({bool resets=true}){
    if(!mounted)return;
    if(resets){
      reset();
    }
    setState(() => timer?.cancel());

  }

  @override
  Widget build(BuildContext context) {
    if (chartData.length >= 25) {
      chartData.removeAt(0);
    }

    final isRecording= recorder.isRecording;
    // final icon= isRecording ?Icons.stop :Icons.mic;
    final icon= isRecording ?Icons.stop:Icons.mic;
    // final text=isRecording?minutes.toString().padLeft(2, '0')+':'+seconds.toString().padLeft(2, '0'):'START';
    final text=isRecording?minutes.toString().padLeft(2, '0')+':'+seconds.toString().padLeft(2, '0'):'START';


    return Scaffold(
      extendBodyBehindAppBar: true,

        body:
        Container(
          margin: EdgeInsets.fromLTRB(5, 80, 5, 10),
          alignment: Alignment.topCenter,
        child: Column(
        children: [
        // Expanded(
        // flex: 2,
        // child:
        // Text(
        // maxDB != null ? maxDB!.toStringAsFixed(2) : 'Press start',
        // style: GoogleFonts.exo2(fontSize: 76),),
        //
        // ),
        Text(
        meanDB != null
         ? 'Mean: ${meanDB!.toStringAsFixed(2)}'
        : 'Awaiting data',
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Expanded(
          child: SfCartesianChart(
          series: <LineSeries<_ChartData, double>>[
          LineSeries<_ChartData, double>(
          dataSource: chartData,
          xAxisName: 'Time',
          yAxisName: 'dB',
          name: 'dB values over time',
          xValueMapper: (_ChartData value, _) => value.frames,
          yValueMapper: (_ChartData value, _) => value.maxDB,
          animationDuration: 0),
          ],
          ),
          ),
        ),
          SizedBox(
          height: 68,
          ),
          ],
          ),
          ),


      floatingActionButton:
      Container(
        margin: EdgeInsets.fromLTRB(30, 10, 10, 10),
        child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

                Container(

                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: FloatingActionButton.extended(
                    backgroundColor: Color.fromARGB(255, 245, 197, 190),
                    foregroundColor: Colors.white,
                    label: Text(_isRecording ? 'Stop' : 'Tuning'),
                    onPressed: _isRecording ? stop : start,
                    icon: !_isRecording ? Icon(Icons.circle) : null,
                  ),
                ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding:  EdgeInsets.fromLTRB(10, 10, 10, 10),

                child: FloatingActionButton.extended(
                backgroundColor: Color.fromARGB(255, 245, 197, 190),
                foregroundColor: Colors.white,
                icon: Icon(icon),
                label:
                  Text(text), onPressed: () async {
                setState((){
                  _isRecording ? stop : start;
                  recorder.new_filename=widget.new_filename;
                  recorder.new_name=widget.new_name;
                  recorder.new_age=widget.new_age;
                });
                  await recorder.toggleRecording();
                  final theRecording =recorder.isRecording;

                   if(theRecording){
                    startTimer();
                  }
                  else {
                    stopTimer();
                  }
        },
        ),
              ),
            ],
          ),
      ),

    );

  }


}

class _ChartData {
  final double? maxDB;
  final double? meanDB;
  final double frames;

  _ChartData(this.maxDB, this.meanDB, this.frames);
}