//
//  ZebraSwift.swift
//  ZebraSwift
//
//  Created by Tiago Do Couto on 8/7/19.
//  Copyright © 2019 Couto Code. All rights reserved.
//

import Foundation

public class ZebraSwift: NSObject, ISbtSdkApiDelegate {
    
    var api: ISbtSdkApi
    var scanner: SbtScannerInfo
    public override init() {
        api = SbtSdkFactory.createSbtSdkApiInstance()
        scanner = SbtScannerInfo()
        super.init()
        
        scanner.getAutoCommunicationSessionReestablishment()
        scanner.getScannerID()
        
        api.sbtSetDelegate(self)
        api.sbtEnableAvailableScannersDetection(true)
        api.sbtSubsribe(forEvents: Int32(SBT_EVENT_BARCODE | SBT_EVENT_SCANNER_APPEARANCE | SBT_EVENT_SESSION_ESTABLISHMENT))
        api.sbtSetOperationalMode(Int32(SBT_OPMODE_ALL))
        
        var list: AutoreleasingUnsafeMutablePointer<NSMutableArray?>!
        api.sbtGetActiveScannersList(list)
        print(list)
    }
    
    public func sbtEventScannerAppeared(_ availableScanner: SbtScannerInfo!) {
        print(availableScanner)
    }
    
    public func sbtEventScannerDisappeared(_ scannerID: Int32) {
        print("HELLp")
    }
    
    public func sbtEventCommunicationSessionEstablished(_ activeScanner: SbtScannerInfo!) {
        print("HELLp")
    }
    
    public func sbtEventCommunicationSessionTerminated(_ scannerID: Int32) {
        print("HELLp")
    }
    
    public func sbtEventBarcode(_ barcodeData: String!, barcodeType: Int32, fromScanner scannerID: Int32) {
        print("HI")
        print(barcodeData)
    }
    
    public func sbtEventBarcodeData(_ barcodeData: Data!, barcodeType: Int32, fromScanner scannerID: Int32) {
        print("HI")
        print(barcodeData)
    }
    
    public func sbtEventFirmwareUpdate(_ fwUpdateEventObj: FirmwareUpdateEvent!) {
        print("HELLp")
    }
    
    public func sbtEventImage(_ imageData: Data!, fromScanner scannerID: Int32) {
        print("HELLp")
    }
    
    public func sbtEventVideo(_ videoFrame: Data!, fromScanner scannerID: Int32) {
        print("HELLp")
    }
}

