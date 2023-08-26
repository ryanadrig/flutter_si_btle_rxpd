import 'package:flutter/material.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'btle.dart';
import 'errorDialog.dart';

Size ss = Size(0,0);


Future<void> requestPermission(Permission permission) async {
  final status = await permission.request();
  if (status == PermissionStatus.denied){
    print("[SI BLE] location permission still denied");
  }
  if (status == PermissionStatus.granted){
    print("[SI BLE] location permission granted");
  }

}

handleLocationPermissionDenied()async {
  print("[SI BLE] request location always");
  requestPermission(Permission.locationAlways);
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  bool bluetoothDisabled = false;
  @override
  void initState() {

    ble.statusStream.listen((status){
      print("[SI BLE] blue status stream status event ~ " + status.toString());
    });


    super.initState();
  }

  scanForBLE_Device(){
    ble.scanForDevices(
        requireLocationServicesEnabled: false,
        withServices: [],
        scanMode: ScanMode.lowLatency).listen((device) {
    }, onError: (dynamic e, StackTrace s) {
      print("[SI BLE] Error Scanning ~ " + e.toString());
      if (e.message.toString().contains("Bluetooth disabled (code 1)")){
        print("found bluetooth disabled ");
        setState(() {
          bluetoothDisabled = true;
        });
          showErrorDialog(context,ss, "Bluetooth Disabled \n Please enable in settings" );
      }
      else{
        // showErrorDialog(context, ss, e.message.toString());
        handleLocationPermissionDenied();
      }
    });
  }

  connectToBLE_Device(
      String foundDeviceId, Uuid serviceId, List<Uuid> serviceChars  ){
    ble.connectToDevice(
      id: foundDeviceId,
      servicesWithCharacteristicsToDiscover: {serviceId: serviceChars},
      connectionTimeout: const Duration(seconds: 2),
    ).listen((connectionState) {
      print("[SI BLE] connection statue update ~ " + connectionState.toString());
    }, onError: (Object error) {
      print("[SI BLE] connection error ~ " + error.toString());
    });

    // flutterReactiveBle.connectToAdvertisingDevice(
    //   id: foundDeviceId,
    //   withServices: [serviceUuid],
    //   prescanDuration: const Duration(seconds: 5),
    //   servicesWithCharacteristicsToDiscover: {serviceId: [char1, char2]},
    //   connectionTimeout: const Duration(seconds:  2),
    // ).listen((connectionState) {
    //   // Handle connection state updates
    // }, onError: (dynamic error) {
    //   // Handle a possible error
    // });
  }

  readCharachteristic(Uuid serviceUuid, Uuid characteristicUuid, String foundDeviceId) async {
    final characteristic = QualifiedCharacteristic(serviceId: serviceUuid,
        characteristicId: characteristicUuid, deviceId: foundDeviceId);
    final response = await ble.readCharacteristic(characteristic);
  }

  writeCharachteristic(Uuid characteristicUuid, Uuid serviceUuid, String foundDeviceId)async{
    final characteristic = QualifiedCharacteristic(serviceId: serviceUuid,
        characteristicId: characteristicUuid, deviceId: foundDeviceId);
    await ble.writeCharacteristicWithResponse(characteristic, value: [0x00]);

    // final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
    // flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic, value: [0x00]);
  }


  @override
  Widget build(BuildContext context) {
    ss = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           OutlinedButton(
             onPressed: (){
               scanForBLE_Device();
             },
             child: Text("Scan"),
           )
          ],
        ),
      ),
    );
  }
}