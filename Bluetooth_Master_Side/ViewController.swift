//
//  ViewController.swift
//  Bluetooth_Master_Side
//
//  Created by Sebastian Kazakov on 4/1/23.
//

import UIKit
import SwiftUI
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate {
    
    
    //@IBOutlet weak var ConnectButton: UIButton!
    
    @IBOutlet weak var DeviceNameLabel: UILabel!
    
    @IBOutlet weak var DiscoveredDevices: UIButton!
    
    @IBOutlet weak var InputFeild: UITextField!
    
    @IBOutlet weak var SendDataButton: UIButton!
    
    private var centralManager: CBCentralManager!
    var peripherals = [CBPeripheral]()
    var connectedPeripheral: CBPeripheral?
    var emptyString = ""
    var ConnectedCurrentPeripheral: CBPeripheral!
    var ConnectedCurrentCharacteristic: CBCharacteristic!
    var dataAdaptor = Data()
    var stringAdaptor = "hello!"
    var device1: UIAction!
    var device2: UIAction!
    var device3: UIAction!
    var device4: UIAction!
    var device5: UIAction!
    var device6: UIAction!
    var device7: UIAction!
    var device1Name: String!
    var device2Name: String!
    var device3Name: String!
    var device4Name: String!
    var device5Name: String!
    var device6Name: String!
    var device7Name: String!
    var device1Peripheral: CBPeripheral?
    var device2Peripheral: CBPeripheral?
    var device3Peripheral: CBPeripheral?
    var device4Peripheral: CBPeripheral?
    var device5Peripheral: CBPeripheral?
    var device6Peripheral: CBPeripheral?
    var device7Peripheral: CBPeripheral?
    var device1Characteristics: CBCharacteristic?
    var device2Characteristics: CBCharacteristic?
    var device3Characteristics: CBCharacteristic?
    var device4Characteristics: CBCharacteristic?
    var device5Characteristics: CBCharacteristic?
    var device6Characteristics: CBCharacteristic?
    var device7Characteristics: CBCharacteristic?
    
    
    var publicMenuClosure = {(action: UIAction) in }
    var priorityNumber: Int!
    var selectedNumber: Int!
    var defaultString: String!
    var timer = Timer()
    var isConnectedAndReady: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        
        priorityNumber = 1
        
        let menuClosure = {(action: UIAction) in
                   
            self.update(name: action.title)
           }
        
        publicMenuClosure = menuClosure
        
        device1 = UIAction(title: "Discovered Device(s):", handler: publicMenuClosure)
        device2 = UIAction(title: "", handler: publicMenuClosure)
        device3 = UIAction(title: "", handler: publicMenuClosure)
        device4 = UIAction(title: "", handler: publicMenuClosure)
        device5 = UIAction(title: "", handler: publicMenuClosure)
        device6 = UIAction(title: "", handler: publicMenuClosure)
        device7 = UIAction(title: "", handler: publicMenuClosure)
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        dataAdaptor = Data(stringAdaptor.utf8)
        
        
           DiscoveredDevices.menu = UIMenu(children: [
                 device1, device2, device3, device4, device5, device6, device7
               ])
        DiscoveredDevices.showsMenuAsPrimaryAction = true
        DiscoveredDevices.changesSelectionAsPrimaryAction = true
        
        defaultString = "helloBoiAintNobodyGonnaGuessThisRandomA*sString"
        
        SendDataButton.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(readIncomingSerial), userInfo: nil, repeats: true)
        
    }
    
    @objc func readIncomingSerial(){
        if SendDataButton.isEnabled == true{
            if isConnectedAndReady == true{
                if ConnectedCurrentCharacteristic.uuid.uuidString == "FFE1"{
                    //            var parameter = NSInteger(1)
                    //            let data = NSData(bytes: &parameter, length: 1)
                    ConnectedCurrentPeripheral.readValue(for: ConnectedCurrentCharacteristic)
                }
            }
        }
    }
    
    func update(name:String) {
        if name == "\(device7Name ?? emptyString)"{
            connectToDevice(peripheral: device7Peripheral!)
            connectedPeripheral = device7Peripheral
            print("connecting to device 6")
            selectedNumber = 7
            SendDataButton.isEnabled = true
        }
        if name == "\(device6Name ?? emptyString)"{
            connectToDevice(peripheral: device6Peripheral!)
            connectedPeripheral = device6Peripheral
            print("connecting to device 5")
            selectedNumber = 6
            SendDataButton.isEnabled = true
        }
        if name == "\(device5Name ?? emptyString)"{
            connectToDevice(peripheral: device5Peripheral!)
            connectedPeripheral = device5Peripheral
            print("connecting to device 4")
            selectedNumber = 5
            SendDataButton.isEnabled = true
        }
        if name == "\(device4Name ?? emptyString)"{
            connectToDevice(peripheral: device4Peripheral!)
            connectedPeripheral = device4Peripheral
            print("connecting to device 3")
            selectedNumber = 4
            SendDataButton.isEnabled = true
        }
        if name == "\(device3Name ?? emptyString)"{
            connectToDevice(peripheral: device3Peripheral!)
            connectedPeripheral = device3Peripheral
            print("connecting to device 2")
            selectedNumber = 3
            SendDataButton.isEnabled = true
        }
        if name == "\(device2Name ?? emptyString)"{
            connectToDevice(peripheral: device2Peripheral!)
            connectedPeripheral = device2Peripheral
            print("connecting to device 1")
            selectedNumber = 2
            SendDataButton.isEnabled = true
        }
        if name == "Discovered Device(s):" {
            print("Nothing to see here, keep searching")
            SendDataButton.isEnabled = false
        }else{
            print("check yo damn spelling bro")
        }
   }
    
    @objc func removeKeyboard(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func beginScan(){
       // let device = CBUUID(string: "DAB7ADE9-64D5-13C3-A1BE-B275FF5F3E8B")
        let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(value: false)]
        centralManager.scanForPeripherals(withServices: nil, options: options)
        print("radar: ON!")
    }
    
    func discoverCharacteristics(peripheral: CBPeripheral){
        guard let services = peripheral.services else{
            return
        }
        for service in services{
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func DiscoverServices(peripheral: CBPeripheral){
        peripheral.discoverServices(nil)
    }
    
    func connectToDevice(peripheral: CBPeripheral){
        centralManager.connect(peripheral, options: nil)
    }
    
    func subscribeToNotifications(peripheral: CBPeripheral, characteristic: CBCharacteristic){
        peripheral.setNotifyValue(true, for: characteristic)
    }
    
    
    func write(command: String, characteristic: CBCharacteristic){
        if ConnectedCurrentCharacteristic.uuid.uuidString == "FFE1"{
//            var parameter = NSInteger(1)
//            let data = NSData(bytes: &parameter, length: 1)
         
            let stringBoi = command
            let dataToSend: Data = stringBoi.data(using: String.Encoding.utf8)!
            
            ConnectedCurrentPeripheral.writeValue(dataToSend, for: ConnectedCurrentCharacteristic, type: .withResponse)
            print("\(dataToSend) ----------------------------------- dis is da one")
        }else{
            
            let stringBoi = command
            let dataToSend: Data = stringBoi.data(using: String.Encoding.utf8)!
            
            ConnectedCurrentPeripheral.writeValue(dataToSend, for: ConnectedCurrentCharacteristic, type: .withResponse)
            print("\(dataToSend) ----------------------------------- dis is da one")
            
        }
    }
    
   
    
    
    func discoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic){
        peripheral.discoverDescriptors(for: characteristic)
    }
    
    func disconnectFromDevice(peripheral: CBPeripheral){
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    
    
    

    @IBAction func Disconnect(_ sender: Any) {
        HapticsManager.shared.beginVibration(type: .error)
        disconnectFromDevice(peripheral: device1Peripheral ?? connectedPeripheral!)
        disconnectFromDevice(peripheral: device2Peripheral ?? connectedPeripheral!)
        disconnectFromDevice(peripheral: device3Peripheral ?? connectedPeripheral!)
        disconnectFromDevice(peripheral: device4Peripheral ?? connectedPeripheral!)
        disconnectFromDevice(peripheral: device5Peripheral ?? connectedPeripheral!)
        disconnectFromDevice(peripheral: device6Peripheral ?? connectedPeripheral!)
        disconnectFromDevice(peripheral: device7Peripheral ?? connectedPeripheral!)
    }
    
    /*@IBAction func Connect(_ sender: Any) {
        HapticsManager.shared.beginVibration(type: .success)
        connectToDevice(peripheral: connectedPeripheral!)
    }*/
    
    @IBAction func SendData(_ sender: Any) {
        HapticsManager.shared.beginVibration(type: .warning)
        let inputText = InputFeild.text!
        write(command: inputText, characteristic: ConnectedCurrentCharacteristic)
        print(ConnectedCurrentCharacteristic ?? emptyString)
        print("sent!")
        InputFeild.text = emptyString
       
    }
    
 
    
}



extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state{
        case .poweredOn:
            print("on")
            beginScan()
            print("scanning")
        case .poweredOff:
            print("off")
        case .unauthorized:
            print("not allowed")
        case .unknown:
            print("no idea")
        case .resetting:
            print("reset")
        case .unsupported:
            print("no suport")
        default:
            break
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral)
        connectedPeripheral = peripheral
        print(peripheral.name ?? emptyString)
        print(peripheral.identifier.uuidString)
        switch priorityNumber{
        case 6:
            if peripheral.name != device7Name && peripheral.name != device2Name && peripheral.name != device3Name && peripheral.name != device4Name && peripheral.name != device5Name && peripheral.name != device6Name && peripheral.name != device1Name{
                if peripheral.name != ""{
                    device7 = UIAction(title: peripheral.name ?? emptyString, handler: publicMenuClosure)
                    DiscoveredDevices.menu = UIMenu(children: [
                        device1, device2, device3, device4, device5, device6, device7
                    ])
                    device7Peripheral = peripheral
                    device7Name = peripheral.name
                    
                    priorityNumber = 1
                }
            }else{
                print("copycat!")
            }
        case 5:
            if peripheral.name != device7Name && peripheral.name != device2Name && peripheral.name != device3Name && peripheral.name != device4Name && peripheral.name != device5Name && peripheral.name != device6Name && peripheral.name != device1Name{
                if peripheral.name != ""{
                    device6 = UIAction(title: peripheral.name ?? emptyString, handler: publicMenuClosure)
                    DiscoveredDevices.menu = UIMenu(children: [
                        device1, device2, device3, device4, device5, device6, device7
                    ])
                    device6Peripheral = peripheral
                    device6Name = peripheral.name
                    priorityNumber = 6
                }
            }else{
                print("copycat!")
            }
        case 4:
            if peripheral.name != device7Name && peripheral.name != device2Name && peripheral.name != device3Name && peripheral.name != device4Name && peripheral.name != device5Name && peripheral.name != device6Name && peripheral.name != device1Name{
                if peripheral.name != ""{
                    device5 = UIAction(title: peripheral.name ?? emptyString, handler: publicMenuClosure)
                    DiscoveredDevices.menu = UIMenu(children: [
                        device1, device2, device3, device4, device5, device6, device7
                    ])
                    device5Peripheral = peripheral
                    device5Name = peripheral.name
                    priorityNumber = 5
                }
            }else{
                print("copycat!")
            }
        case 3:
            if peripheral.name != device7Name && peripheral.name != device2Name && peripheral.name != device3Name && peripheral.name != device4Name && peripheral.name != device5Name && peripheral.name != device6Name && peripheral.name != device1Name{
                if peripheral.name != ""{
                    device4 = UIAction(title: peripheral.name ?? emptyString, handler: publicMenuClosure)
                    DiscoveredDevices.menu = UIMenu(children: [
                        device1, device2, device3, device4, device5, device6, device7
                    ])
                    device4Peripheral = peripheral
                    device4Name = peripheral.name
                    priorityNumber = 4
                }
            }else{
                print("copycat!")
            }
        case 2:
            if peripheral.name != device7Name && peripheral.name != device2Name && peripheral.name != device3Name && peripheral.name != device4Name && peripheral.name != device5Name && peripheral.name != device6Name && peripheral.name != device1Name{
                if peripheral.name != ""{
                    device3 = UIAction(title: peripheral.name ?? emptyString, handler: publicMenuClosure)
                    DiscoveredDevices.menu = UIMenu(children: [
                        device1, device2, device3, device4, device5, device6, device7
                    ])
                    device3Name = peripheral.name
                    device3Peripheral = peripheral
                    priorityNumber = 3
                }
            }else{
                print("copycat!")
            }
        case 1:
            if peripheral.name != device7Name && peripheral.name != device2Name && peripheral.name != device3Name && peripheral.name != device4Name && peripheral.name != device5Name && peripheral.name != device6Name && peripheral.name != device1Name{
                if peripheral.name != ""{
                    device2 = UIAction(title: peripheral.name ?? emptyString, handler: publicMenuClosure)
                    DiscoveredDevices.menu = UIMenu(children: [
                        device1, device2, device3, device4, device5, device6, device7
                    ])
                    device2Name = peripheral.name
                    device2Peripheral = peripheral
                    priorityNumber = 2
                }
            }else{
                print("copycat!")
            }
        default:
            break
        
        }
        //print(connectedPeripheral!)
        //DiscoveredLabel.text = "Discovered Device: \(peripheral.name ?? emptyString)"
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("let's go!!!")
        peripheral.delegate = self
        connectedPeripheral = peripheral
        DeviceNameLabel.text = "Connected Device: \(peripheral.name ?? emptyString)"
        DiscoverServices(peripheral: peripheral)
     
        SendDataButton.isEnabled = true
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
      
        guard let descriptors = characteristic.descriptors else{return}
        print(descriptors)
        if let userDescriptionDescriptor = descriptors.first(where: {
           // print("\($0.uuid.uuidString) --------------------------------------------")
            return $0.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString
            
        }) {
            peripheral.readValue(for: userDescriptionDescriptor)
        }
        
        subscribeToNotifications(peripheral: peripheral, characteristic: characteristic)
        print("descriptors discovered!")
        isConnectedAndReady = true
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if descriptor.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString,
           let userDescription = descriptor.value as? String{
            print("Characteristic \(descriptor.characteristic?.uuid.uuidString ?? emptyString) is also known as \(userDescription)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else{
            return
        }
        print(services)
        discoverCharacteristics(peripheral: peripheral)
        print("service discovered")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else{
            return
        }
        discoverDescriptors(peripheral: peripheral, characteristic: characteristics.first!)
        ConnectedCurrentPeripheral = peripheral
        ConnectedCurrentCharacteristic = characteristics.first!
        
//        if characteristics.first!.uuid.uuidString == "FFE1"{
//            var parameter = NSInteger(1)
//            let data = NSData(bytes: &parameter, length: 1)
//            peripheral.writeValue(data as Data, for: characteristics.first!, type: .withResponse)
//        }
        isConnectedAndReady = true
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //let dataToRead: Data = (characteristic.value?.description.data(using: String.Encoding.utf8))!
        //let dataToRead = String(decoding: characteristic.value!, as: UTF8.self)
        
        guard let data = characteristic.value else {
            return
        }
        guard let oneByte = data.first else{
            return
        }
        
        let adaptor = oneByte
        
        print("\(oneByte) -----------> Read string from \(peripheral)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
            print("you actually suck, no subscribe")
            print(error)
        }else{
            print("#subscribed boi")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
            print("God Motherfuzzin Damnit!!!")
            print(error)
        }else{
            print("Yay!!!")
        }
    }

    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DeviceNameLabel.text = "Connected Device: \(emptyString)"
        print("disconnected")
        SendDataButton.isEnabled = false
        isConnectedAndReady = false
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect")
        SendDataButton.isEnabled = false
        isConnectedAndReady = false
    }
    
}
