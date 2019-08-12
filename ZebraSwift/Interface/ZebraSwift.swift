//
//  ZebraSwift.swift
//  ZebraSwift
//
//  Created by Tiago Do Couto on 8/7/19.
//  Copyright © 2019 Couto Code. All rights reserved.
//

import Foundation

public protocol ZebraDelegate {
    func scannerListUpdated()
    func connected(for device: SbtScannerInfo)
    func disconnected(for device: Int32)
    func scanned(data: String)
}

public class ZebraSwift: NSObject {
    
    var api: ISbtSdkApi
    var list: NSMutableArray?
    
    public var scanner: SbtScannerInfo?
    public var delegate: ZebraDelegate?
    
    public var scanners: [SbtScannerInfo] {
        didSet {
            delegate?.scannerListUpdated()
        }
    }
    
    public override init() {
        api = SbtSdkFactory.createSbtSdkApiInstance()
        scanners = []
        super.init()
        
        api.sbtSetDelegate(self)
        api.sbtEnableAvailableScannersDetection(true)

        api.sbtSubsribe(forEvents: Int32(SBT_EVENT_BARCODE) | Int32(SBT_EVENT_SCANNER_APPEARANCE) | Int32(SBT_EVENT_SCANNER_DISAPPEARANCE) | Int32(SBT_EVENT_SESSION_ESTABLISHMENT) | Int32(SBT_EVENT_SESSION_TERMINATION) | Int32(SBT_EVENT_RAW_DATA))
        
        api.sbtSetOperationalMode(Int32(SBT_OPMODE_BTLE))
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+3) {
            self.api.sbtGetActiveScannersList(&self.list)
        }
    }
    
    public func connect(to device: SbtScannerInfo) {
        if device.isActive() {
            api.sbtTerminateCommunicationSession(device.getScannerID())
        }
        api.sbtEnableAutomaticSessionReestablishment(true, forScanner: device.getScannerID())
        api.sbtEstablishCommunicationSession(device.getScannerID())
    }
}

extension ZebraSwift: ISbtSdkApiDelegate {
    public func sbtEventScannerAppeared(_ availableScanner: SbtScannerInfo!) {
        scanners.append(availableScanner)
    }
    
    public func sbtEventScannerDisappeared(_ scannerID: Int32) {
        if let index = scanners.firstIndex(where: { $0.getScannerID() == scannerID }), index >= 0 {
            scanners.remove(at: index)
        }
    }
    
    public func sbtEventCommunicationSessionEstablished(_ activeScanner: SbtScannerInfo!) {
        delegate?.connected(for: activeScanner)
    }
    
    public func sbtEventCommunicationSessionTerminated(_ scannerID: Int32) {
        delegate?.disconnected(for: scannerID)
    }
    
    public func sbtEventBarcode(_ barcodeData: String!, barcodeType: Int32, fromScanner scannerID: Int32) {
        delegate?.scanned(data: barcodeData)
    }
    
    public func sbtEventBarcodeData(_ barcodeData: Data!, barcodeType: Int32, fromScanner scannerID: Int32) {
        print("-------------------------------------------")

    }
    
    public func sbtEventFirmwareUpdate(_ fwUpdateEventObj: FirmwareUpdateEvent!) {}
    
    public func sbtEventImage(_ imageData: Data!, fromScanner scannerID: Int32) {}
    
    public func sbtEventVideo(_ videoFrame: Data!, fromScanner scannerID: Int32) {}
}

