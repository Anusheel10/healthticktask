import 'package:flutter/material.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter_switch/flutter_switch.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {

  int _timeRemaining = 10; // Initial time in seconds
  late Timer _timer;
  bool paused=false;
  AssetsAudioPlayer assetsAudioPlayer=AssetsAudioPlayer();


  bool isSwitched=true;

  void musicPlay()
  {
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/audios/countdown_tick.mp3"),
      autoStart: true,
      showNotification: true,
    );
  }
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      if(paused)
        {
          _timer.cancel();
        }
      else if (_timeRemaining == 0 && state<3) {
        //timer.cancel();
        setState(() {
          _timeRemaining=10;
          state++;
          _timer.cancel();
          paused=false;
        });
        // Timer has finished. You can perform some action here.
      }else if(_timeRemaining==0 && state==3)
      {
        setState(() {
          _timer.cancel();
        });
      }
      else {
        setState(() {
          if(_timeRemaining<=5 && isSwitched)
            {
              musicPlay();
            }
          _timeRemaining--;
        });
      }
    });
  }
  bool started=false;

  int state=0;


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:const Color(0xff012243),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 6,backgroundColor:state==1?Colors.white: Colors.grey.withOpacity(.5),),
                      SizedBox(width: 5,),
                      CircleAvatar(radius: 6,backgroundColor:state==2?Colors.white: Colors.grey.withOpacity(.5),),
                      SizedBox(width: 5,),
                      CircleAvatar(radius: 6,backgroundColor:state==3?Colors.white: Colors.grey.withOpacity(.5),),
                    ],
                  ),
                  Text(state==0?"Time to eat mindfully":state==1?"Nom nom ;)":state==2?"Break Time":"Finish your meal",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 26),),
                  Text(state==0?"It's simple: eat slowly for ten minutes ,rest for five, then finish your meal":state==1?"You have 10 minutes to eat before the pause.Focus on eating slowly":state==2?"Take a five minute break to check in on your level of fullness":"You can eat until you feel full",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 20),)
                ],
              )),
          Expanded(
            flex: 5,
            child: Container(
              height: height * .6,
              width: width,
              padding: EdgeInsets.symmetric(
                  horizontal: width * .1, vertical: height * .04),
              child: Stack(
                children: [
                  Container(
                    height: height * .4,
                    width: width,

                    decoration: const BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * .1, vertical: height * .04),
                    child: CircularProgressIndicator(

                      backgroundColor: Colors.yellow,
                      color: Colors.green,
                      value:
                      _timeRemaining / 10, // Calculate the progress based on remaining time
                      strokeWidth: 10, // Adjust the thickness of the circle
                    ),
                  ),
                  Center(
                      child: Container(
                          height: height * .2,
                          width: width * .5,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "00:${_timeRemaining.toString()}",
                                style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w700),
                              ),
                              const Text(
                                "minutes remaining",
                                style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w600),
                              ),
                            ],
                          )))
                ],
              ),
            ),
          ),
          started?Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width*.1,vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          
                          child: Column(
                            children: [
                              FlutterSwitch(
                                value: isSwitched,
                                height: 25,
                                width: 50,
                                activeColor: Colors.green,
                                onToggle: (check){

                                  setState(() {
                                    isSwitched=!isSwitched;
                                  });
                                }, ),
                              Text("Sound on",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        )),
                    SizedBox(height: 10,),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              paused=!paused;
                              startTimer();
                            });
                          },
                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.tealAccent.withOpacity(.8),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child:  Center(
                              child: Text(paused?"RESUME":_timeRemaining==10?"StART":"PAUSE",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20),),
                            ),
                          ),
                        )),
                    const SizedBox(height: 10,),
                    Expanded(
                        flex: 1,
                        child: Container(

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Colors.grey,width: 4)
                          ),
                          child: const Center(
                            child: Text("LET'S STOP I'M FULL NOW",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 20),),
                          ),
                        ))
                  ],
                ),
              )):Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(

                  child: Column(
                    children: [
                      FlutterSwitch(
                        value: isSwitched,
                        height: 25,
                        width: 50,
                        activeColor: Colors.green,
                        onToggle: (check){

                          setState(() {
                            isSwitched=!isSwitched;
                          });
                        }, ),
                      Text("Sound on",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      started=!started;
                      state++;
                      startTimer();
                    });

                  },
                  child: Container(
                    height: 80,
                    width: width*.9,
                    decoration: BoxDecoration(
                        color: Colors.tealAccent.withOpacity(.8),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Center(
                      child: Text("START",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20),),
                    ),
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
