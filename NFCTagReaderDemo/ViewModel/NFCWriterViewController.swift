//
//  NFCWriterViewController.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import UIKit
import CoreNFC
import os
import CryptoSwift

class NFCWriterViewController: UIViewController {

    private let NFCNDEFPayloadTypeDetailViewControllerIdentifier = "NFCNDEFPayloadTypeDetailViewController"
    private let NFCTagDetailRecordDescriptionTableViewCellIdentifier = "NFCTagDetailRecordDescriptionTableViewCell"
    private var records: [NFCNDEFPayload] = []
    private var session: NFCTagReaderSession?
    
    @IBOutlet weak var recordTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func initializeUI() {
        recordTableView.dataSource = self
        recordTableView.delegate = self
        recordTableView.rowHeight = 80
    }
    
    @IBAction func addRecord(_ sender: Any) {
    }
    
    @IBAction func write(_ sender: Any) {
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
    
    func insertRecord(_ record: NFCNDEFPayload) {
        self.records.insert(record, at: 0)
        DispatchQueue.main.async {
            self.recordTableView.reloadData()
        }
    }
}

extension NFCWriterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NFCTagDetailRecordDescriptionTableViewCellIdentifier) as? NFCTagDetailRecordDescriptionTableViewCell {
            cell.setRecord(records[indexPath.row], at: indexPath.row)
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: NFCNDEFPayloadTypeDetailViewControllerIdentifier) as? NFCNDEFPayloadTypeDetailViewController {
            let payloadType = records[indexPath.row].type.toString() == NFCNDEFPayloadType.T.description ? NFCNDEFPayloadType.T : NFCNDEFPayloadType.U
            let text = records[indexPath.row].payload.toString()
            viewController.setPayloadTypeDetail(payloadType, text: text)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            records.remove(at: index)
            recordTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension NFCWriterViewController: NFCTagReaderSessionDelegate {
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
        
        // Start to connect to tag
        let tag = tags.first!
        session.connect(to: tag) { error in
            if let error = error {
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            // Connect succeeded, then query status
            var ndefTag: NFCNDEFTag
            switch tag {
            case let .miFare(nfcMiFareTag): ndefTag = nfcMiFareTag
            case let .iso15693(nfcISO15693Tag): ndefTag = nfcISO15693Tag
            case let .iso7816(nfcISO7816Tag): ndefTag = nfcISO7816Tag
            case let .feliCa(nfcFeliCaTag): ndefTag = nfcFeliCaTag
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
                } else if status == .readOnly {
                    self.session?.invalidate(errorMessage: "Tag is read-only.")
                    return
                } else {
                    // Writable, then start to write NDEF
                    
                    // Create a NFCNDEFMessage
                    let message = NFCNDEFMessage(records: self.records)
                    
                    if message.length > capacity {
                        session.invalidate(errorMessage: "Tag capacity is too small. Minimum size requirement is \(message.length) bytes.")
                        return
                    }
                    
                    ndefTag.writeNDEF(message) { error in
                        if let error = error {
                            session.invalidate(errorMessage: error.localizedDescription)
                            return
                        }
                        
                        // Write succeeded
                        session.alertMessage = "Write NDEFMessage succeeded"
                        session.invalidate()
                    }
                }
            }
        }
    }
}
