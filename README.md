# Ewon Flexy to Microsoft Azure IoT Hub via MQTT
===
---

# Table of Contents

-   [Introduction](#Introduction)
-   [Step 1: Prerequisites](#Prerequisites)
-   [Step 2: Create an Azure IoT Hub and collect Azure IoT Hub connectivity parameters](#IoTHub)
-   [Step 3: Set up Ewon Flexy for MQTT communication with Azure IoT Hub](#Flexy)
-   [Next Steps](#NextSteps)

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
1. Log in to the Azure Portal with your account
2. Create a new resource of type “IoT Hub”
3. Create the IoT Hub
4. Choose (or create a new) resource group, name your IoT Hub (REMEMBER THIS!), and check the selection.
5. Finalize and confirm!

Next, go to your IoT Hub

6. Click “IoT Device”
7. Click “New”
8. Create your Device
9. Enter in a device name (e.g. MyFlexy205-SAS, REMEMBER THIS!)
10. Choose whether SAS Token.
11. Click “Save”

Next we're going to COLLECT CONNECTIVITY PARAMETERS

12. Under “Settings”, click “Shared Access Policies”
13. Click “iothubowner”
14. Next to “Connection String - primary key” click the “copy to clipboard” icon and save this string in a safe place. 
  - Your string should look something like: HostName=FlexyStepByStepGuide.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=blahblahblahblahblahblah= 

That’s all we need from Azure! Let’s generate your SAS Token.

15. Open up Device Explorer and paste your Connection String, click Update, then click Generate SAS.
16. The three key pieces of information we need to keep handy are:
  - Device Name (also known as DeviceId)
  - Host Name (also known as IoTHubName)
  - SAS Token (what we just generated in Step 9)


<a name="Flexy"></a>
# Step 3: Set up Ewon Flexy for MQTT communication with Azure IoT Hub
For this section, we are going to follow the recommendations given by Microsoft here: https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-mqtt-support#using-the-mqtt-protocol-directly-as-a-device

1. Load the DigiCert Baltimore PEM certificate on to your Flexy via FTP into the /usr folder
  - If you have questions on this step, please refer to Step 1 in the following knowledge-base article: https://hmsnetworks.blob.core.windows.net/www/docs/librariesprovider10/downloads-monitored/manuals/knowledge-base/kb-0020-00-en-configure-your-ewon-using-ftp.pdf?sfvrsn=32ef56d7_6
2. Log in to your Flexy device and ensure that you have at least one (1) tag created. 
  - If you have questions on this step, please view our eLearning library: https://ewon.biz/e-learning/library/flexy/local-data-acquisition. 
  - Ideally, this tag will change in value so we can see the changes in the final step.
3. Navigate to the BASIC IDE by clicking on Setup -> BASIC IDE
4. Copy the code in [AzureMQTT.bas](https://github.com/vivekmano/flexy205-azure/blob/master/AzureMQTT.bas) into the “Init Section”. Find your connection string from step 7 above and input the following information:
  * DeviceID (what we named our device, I used MyFlexy205-SAS)
  * IoTHubName
  * SASToken
5. Click File -> Save and then run the script (Run -> Run)
  * In the console window you should be able to see PUBLISH. If not, check your steps again.
6. Open Device Explorer, click on the Data tab, and click Monitor

**Congratulations! You are now sharing data with Azure IoT Hub.**
