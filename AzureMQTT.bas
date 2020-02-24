DeviceId$="flexy205"
IotHubName$ ="FlexyCert"
SASToken$="SharedAccessSignature sr=FlexyCert.azure-devices.net&sig=cgNQkdAdyxNFofwwZZlCPLVCA2D20sRJ8JB88981K74%3D&se=1612470571&skn=iothubowner"
Changepushtime% = 2 // Change Push Time
Fullpushtime% = 20// Full Push Time
configfile$="Azureiot_parameters.txt"// Name of the configuration file
GROUPA% = 1
GROUPB% = 1
GROUPC% = 1
GROUPD% = 1
NB%= GETSYS PRG,"NBTAGS" 
DIM a(NB%,2)

MQTT "Open",DeviceId$,IotHubName$ + ".azure-devices.net"
Mqtt "SetParam","Port","8883"
MQTT "setparam", "log", "1"
MQTT "setparam", "keepalive", "20"
MQTT "setparam", "TLSVERSION", "tlsv1.2"
MQTT "setparam", "PROTOCOLVERSION", "3.1.1"
MQTT "setparam", "cafile","/usr/BaltimoreCyberTrustRoot.pem"
//MQTT "setparam", "CertFile","/usr/"+DeviceId$+".crt"
//MQTT "setparam", "KeyFile","/usr/"+DeviceId$+".key"
Mqtt "SetParam","Username",IotHubName$+ ".azure-devices.net/"+DeviceId$+"/api-version=2018-06-30"
//Mqtt "SetParam","Password","HostName="+IotHubName$+";DeviceID="+DeviceId$+";x509=true"
Mqtt "SetParam","Password",SASToken$
Mqtt "Connect"

ONMQTTSTATUS "GOTO IsConnected"
End
//a = table with 2 columns : one with the negative indice of the tag and the second one with 1 if the values of the tag change or 0 otherwise
IsConnected:
FOR i% = 0 TO NB%-1
k%=i%+1
SETSYS Tag, "load",-i%
a(k%,1)=-i%
a(k%,2) = 0
        GroupA$= GETSYS TAG,"IVGROUPA"
        GroupB$= GETSYS TAG,"IVGROUPB"
        GroupC$= GETSYS TAG,"IVGROUPC"
        GroupD$= GETSYS TAG,"IVGROUPD"
        IF  GroupA$ = "1" And GROUPA%= 1  THEN 
          Onchange -i%, "a("+ STR$ k%+",2)= 1" // 1 si la valeur change
        ENDIF 
        IF GroupB$ = "1" And GROUPB%= 1 THEN
         Onchange -i%, "a("+ STR$ k%+",2)= 1"
        ENDIF
        IF GroupC$ = "1" And GROUPC%= 1 THEN
         Onchange -i%, "a("+ STR$ k%+",2)= 1"
        ENDIF
        IF GroupD$ = "1" And GROUPD%= 1THEN
         Onchange -i%, "a("+ STR$ k%+",2)= 1"
        ENDIF
    Next i% 
    TSET 2,Changepushtime%
    Ontimer 2, "goto MqttPublishChangedValue"
    
    Tset 1,Fullpushtime%
    Ontimer 1,"goto MqttPublishAllValue"   
    
    Goto "MqttPublishAllValue"
END
Function GetTime$()
 $a$ = Time$
 $GetTime$ = $a$(7 To 10) + "-" + $a$(4 To 5) + "-" + $a$(1 To 2) + " " + $a$(12 To 13)+":"+$a$(15 To 16)+":"+$a$(18 To 19)
EndFn
//Publish just the changed tags
MqttPublishChangedValue: 
testtag@ = testtag@+1
counter = 0
json$ =         '{'
FOR r% = 1 TO NB% 
  IF a( r%,2) = 1 THEN
    a(r%,2) = 0
    negIndex% = a(r%,1)
    SETSYS Tag, "LOAD", negIndex%
    name$= GETSYS Tag, "name"
    json$ = json$ + '"' + name$+ '":"'+STR$ GETIO name$ + '",'
    counter= counter+1
  ENDIF
NEXT r%
json$ = json$ +    '"time": "'+@GetTime$()+'"'
json$ = json$ +    '}'
IF counter > 0 THEN
  MQTT "PUBLISH","devices/"+DeviceId$+"/messages/events/",json$, 1, 0
  PRINT "Changes detected -> Publish"
  
ELSE
  PRINT "No change detected!"
ENDIF
END
    
//publish all tags
MqttPublishAllValue:
json$ =         '{'
    FOR i% = 0 TO NB% -1
        SETSYS Tag, "load",-i%
        i$= GETSYS TAG,"Name"
        GroupA$= GETSYS TAG,"IVGROUPA"
        GroupB$= GETSYS TAG,"IVGROUPB"
        GroupC$= GETSYS TAG,"IVGROUPC"
        GroupD$= GETSYS TAG,"IVGROUPD"
        IF  GroupA$ = "1" And GROUPA%= 1  THEN 
        json$ = json$ + '"' + i$+ '":"'+STR$ GETIO i$ + '",'
        ENDIF 
        IF GroupB$ = "1" And GROUPB%= 1 THEN
        json$ = json$ + '"' + i$+ '":"'+STR$ GETIO i$ + '",'
        ENDIF
        IF GroupC$ = "1" And GROUPC%= 1 THEN
        json$ = json$ + '"' + i$+ '":"'+STR$ GETIO i$ + '",'
        ENDIF
        IF GroupD$ = "1" And GROUPD%= 1THEN
        json$ = json$ + '"' + i$+ '":"'+STR$ GETIO i$ + '",'
        ENDIF
    Next i%    
json$ = json$ +    '"time": "'+@GetTime$()+'"'
json$ = json$ +         '}'
    
   STATUS% = MQTT("STATUS")
   
   //Is Connected
   If (STATUS% = 5) Then
     Print "PUBLISH: " + json$ 
     MQTT "PUBLISH","devices/"+DeviceId$+"/messages/events/",json$, 1, 0
   Else
     Print "Not connected"
   Endif
End
