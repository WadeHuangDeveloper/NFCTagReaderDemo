//
//  NFCReaderViewController.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import UIKit
import CoreNFC
import os

class NFCReaderViewController: UIViewController {
    
    private let NFCTagDetailViewControllerIdentifier = "NFCTagDetailViewController"
    private var session: NFCTagReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func read(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        session = NFCTagReaderSession(
            pollingOption: [.iso14443, .iso15693],
            delegate: self,
            queue: DispatchQueue.global())
        session?.alertMessage = "Hold your iPhone near an NFC tag."
        session?.begin()
    }
}

extension NFCReaderViewController: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // If necessary, you may perform additional operations on session start.
        // At this point RF polling is enabled.
        os_log("tagReaderSessionDidBecomeActive")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // If necessary, you may handle the error. Note session is no longer valid.
        // You must create a new session to restart RF polling.
        os_log("tagReaderSession didInvalidateWithError error: %@", error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        os_log("tagReaderSession didDetect tags: %@", tags)
        
        if tags.count > 1 {
            session.invalidate(errorMessage: "More than 1 tags was found. Please present only 1 tag.")
            session.restartPolling()
            return
        }
        
        // Start to connect to NFCTag
        let tag = tags.first!
        session.connect(to: tag) { error in
            if let error = error {
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            // Connect succeeded, then query status
            var ndefTag: NFCNDEFTag
            var identifier: Data
            switch tag {
            case let .miFare(nfcMiFareTag):
                ndefTag = nfcMiFareTag
                identifier = nfcMiFareTag.identifier
            case let .iso15693(nfcISO15693Tag):
                ndefTag = nfcISO15693Tag
                identifier = nfcISO15693Tag.identifier
            case let .iso7816(nfcISO7816Tag):
                ndefTag = nfcISO7816Tag
                identifier = nfcISO7816Tag.identifier
            case let .feliCa(nfcFeliCaTag):
                ndefTag = nfcFeliCaTag
                identifier = nfcFeliCaTag.currentIDm
            @unknown default:
                session.invalidate(errorMessage: "Tag is not valid")
                return
            }
            
            ndefTag.queryNDEFStatus { status, capacity, error in
                if let error = error {
                    self.session?.invalidate(errorMessage: error.localizedDescription)
                    return
                }
                
                if status == .notSupported {
                    self.session?.invalidate(errorMessage: "Tag is not supported.")
                    return
                } else {
                    // Read-only or Read/Write, then start to read NDEF
                    ndefTag.readNDEF { message, error in
                        if let error = error, message == nil {
                            self.session?.invalidate(errorMessage: error.localizedDescription)
                            return
                        }
                        
                        session.alertMessage = "Read succeeded."
                        session.invalidate()
                        
                        // Read succeeded, then pass to MessageDetailViewController
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: self.NFCTagDetailViewControllerIdentifier) as? NFCTagDetailViewController {
                                viewController.setNFCTag(tag)
                                viewController.setStatus(status)
                                viewController.setNDEFMessage(message!)
                                viewController.setSerialNumber(identifier.toShortHexString())
                                
                                self.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
