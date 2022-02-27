import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CallCode{

  getAvator(CallType callType){
    switch(callType){
      case CallType.outgoing:
        return CircleAvatar(maxRadius: 20,backgroundColor: Colors.green,child: Icon(Icons.call_made,color: Colors.white,),);
      case CallType.missed:
        return CircleAvatar(maxRadius: 20,backgroundColor: Colors.red,child: Icon(Icons.call_missed,color: Colors.white,));
      default:
        return CircleAvatar(maxRadius: 20,backgroundColor: Colors.indigo,child: Icon(Icons.call_received,color: Colors.white,));
    }
  }

  calltypes(CallType callType){
    switch(callType){
      case CallType.outgoing:
        return 'outgoing';
      case CallType.missed:
        return 'missed';
      default:
        return 'incoming';
    }
  }

  Future<Iterable<CallLogEntry>> getCallLogs(){
    return CallLog.get();
  }

  String formatdate(DateTime dt){
  return DateFormat('d-MMM-y hh:mm:ss a').format(dt);
  }

  getTitle(CallLogEntry entry){
    if(entry.name == null){
      return Text(entry.number,style: TextStyle(fontWeight: FontWeight.w500),);
    }
    if(entry.name.isEmpty){
      return Text(entry.number,style: TextStyle(fontWeight: FontWeight.w500),);
    }else{
      return Text(entry.name,style: TextStyle(fontWeight: FontWeight.w500),);
    }
  }

  getName(CallLogEntry entry){
    if(entry.name == null){
      return entry.number;
    }
    if(entry.name.isEmpty){
      return entry.number;
    }else{
      return entry.name;
    }
  }

  String getTime(int duration){
    Duration d = Duration(seconds: duration);
    String formattedDuration = "";
    if(d.inHours > 0){
      formattedDuration += d.inHours.toString() +"h ";
    }
    if(d.inMinutes > 0){
      formattedDuration += d.inMinutes.toString() +"m ";
    }
    if(d.inSeconds > 0){
      formattedDuration += d.inSeconds.toString() + "s";
    }
    if(formattedDuration.isEmpty)
      return "0s";
      return formattedDuration;
  }

  String printDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final hoursString = '$hours'.padLeft(2, '0');
    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$hoursString:$minutesString:$secondsString';
  }
}