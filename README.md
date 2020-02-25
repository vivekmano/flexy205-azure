# Ewon Flexy to Microsoft Azure IoT Hub via MQTT
-   [Introduction](#Introduction)
-   [Step 1: Prerequisites](#Prerequisites)
-   [Step 2: Create an Azure IoT Hub and collect Azure IoT Hub connectivity parameters](#IoTHub)
-   [Step 3: Set up Ewon Flexy for MQTT communication with Azure IoT Hub](#Flexy)
-   [Appendix A - BASIC script for Flexy](#FlexyScript)

<a name="Introduction"></a>
# Introduction

**About this document**

This document describes how to connect an Ewon Flexy device to Microsoft Azure IoT Hub. This multi-step process includes:
-   Configuring Azure IoT Hub
-   Configuring an Ewon Flexy
-   Testing the MQTT connection with Device Explorer

<a name="Prerequisites"></a>
# Step 1: Prerequisites

You should have the following items ready before beginning the process:

1. Ewon Flexy device, minimum FW 14.0s0
2. Microsoft Azure Portal account: https://azure.microsoft.com/en-us/features/azure-portal/
3. Ewon Flexy device (purchase one here: https://www.ewon.biz/contact/find-distributor)
4. DigiCert Baltimore Certificate: https://github.com/vivekmano/flexy205-azure/blob/master/BaltimoreCyberTrustRoot.pem
5. Microsoft DeviceExplorer: https://github.com/Azure/azure-iot-sdk-csharp/releases/download/2019-1-4/SetupDeviceExplorer.msi

<a name="IoTHub"></a>
# Step 2: Create an Azure IoT Hub and collect Azure IoT Hub connectivity parameters
1. Log in to the Azure Portal with your account, go to IoT Hub
![Go to IoT Hub](https://user-images.githubusercontent.com/11340557/75222829-5fff2b00-57a5-11ea-9dad-6d573debb2c8.png)
2. Create a new resource of type “IoT Hub”
![Add New IoT Hub](https://user-images.githubusercontent.com/11340557/75222919-9f2d7c00-57a5-11ea-92cb-f7e3552e79d5.png)
3. Create the IoT Hub
    1. Choose Free Trial
    2. Assign a Resource Group, or create a new one
    3. Assign your region
    4. Create an IoT Hub name and WRITE IT DOWN!
    5. Click *Review and Create*
    
    ![IoT Hub Options](https://user-images.githubusercontent.com/11340557/75223147-20850e80-57a6-11ea-9d59-41a0917f764b.png)

4. Click "Create" to finalize and confirm!

### Next, go to your IoT Hub

5. Under the "Explorers" sub-section, click on *IoT Device*
![Click IoT Device](https://user-images.githubusercontent.com/11340557/75223455-c6d11400-57a6-11ea-92ab-5cac8f30c26b.png)
6. Click *New*

7. Create your Device and:
    1. Enter in a device name (e.g. MyFlexy205-SAS, REMEMBER THIS!)
    2. Choose "SAS Token"
    3. Click *Save*
    
    ![Create Device](https://user-images.githubusercontent.com/11340557/75223731-6393b180-57a7-11ea-9796-55b44ea58404.png)
8. Your device has been created! 

![Confirmation device created](https://user-images.githubusercontent.com/11340557/75223888-b0778800-57a7-11ea-83de-fa763706ab44.png)

### Next, we're going to collect the Azure IoT connectivity parameters

9. Under “Settings"
    1. Click *Shared Access Policies*
    2. Click *iothubowner*
    3. Copy your “Connection String - primary key” by clicking the *copy to clipboard* icon
    ![Getting the Connection String](https://user-images.githubusercontent.com/11340557/75224303-8a061c80-57a8-11ea-9845-248008071474.png)
    * *Your string should look something like:* `HostName=FlexyStepByStepGuide.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=blahblahblahblahblahblah=`
    
### That’s all we need from Azure! Let’s generate your SAS Token.

10. Open up Device Explorer and paste your Connection String, click *Update*, then click *Generate SAS*.
![Generate SAS Token](https://user-images.githubusercontent.com/11340557/75226028-ed457e00-57ab-11ea-9f7e-dbb8e340a97f.png)

The three key pieces of information we need to keep handy are:
    - Device Name (also known as DeviceId)
    - Host Name (also known as IoTHubName)
    - SAS Token (what we just generated in Device Explorer)

<a name="Flexy"></a>
# Step 3: Set up Ewon Flexy for MQTT communication with Azure IoT Hub
For this section, we are going to follow the recommendations given by Microsoft here: https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-mqtt-support#using-the-mqtt-protocol-directly-as-a-device

1. Load the DigiCert Baltimore PEM certificate on to your Flexy via FTP into the /usr folder
    - If you have questions on this step, please refer to Step 1 in the following knowledge-base article: https://hmsnetworks.blob.core.windows.net/www/docs/librariesprovider10/downloads-monitored/manuals/knowledge-base/kb-0020-00-en-configure-your-ewon-using-ftp.pdf?sfvrsn=32ef56d7_6
2. Log in to your Flexy device and ensure that you have at least one (1) tag created. 
    - If you have questions on this step, please view our eLearning library: https://ewon.biz/e-learning/library/flexy/local-data-acquisition. 
    - Ideally, this tag will change in value so we can see the changes in the final step.
3. Navigate to the BASIC IDE by clicking on Setup -> BASIC IDE and select the *Init Section*
![2020-02-20 20_17_59-Window (Extra Small)](https://user-images.githubusercontent.com/11340557/75225531-19143400-57ab-11ea-9e8f-0e7734b87e59.png)
4. Copy the code below in Appendix A into the *Init Section*. Find your connection string from above and input the following information:
    * DeviceID (what we named our device, I used MyFlexy205-SAS)
    * IoTHubName
    * SASToken
5. Click File -> Save and then run the script (Run -> Run)
    * In the console window you should be able to see PUBLISH. If not, check your steps again.
6. Open Device Explorer, click on the Data tab, and click Monitor

**Congratulations! You are now sharing data with Azure IoT Hub.**

<a name="FlexyScript"></a>
# Appendix A - BASIC Script for Flexy
```BASIC
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
Mqtt "SetParam","Username",IotHubName$+ ".azure-devices.net/"+DeviceId$+"/api-version=2018-06-30"
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
```
