//
//  NFCNDEFPayloadTypeViewController.swift
//  NFCTagReaderDemo
//
//  Created by WadeGigatms on 2024/1/26.
//

import UIKit

class NFCNDEFPayloadTypeViewController: UIViewController {

    private let NFCNDEFPayloadTypeDetailViewControllerIdentifier = "NFCNDEFPayloadTypeDetailViewController"
    private let NFCNDEFPayloadTypeTableViewCellIdentifier = "NFCNDEFPayloadTypeTableViewCell"
    private let payloadTypes = [NFCNDEFPayloadType.T, NFCNDEFPayloadType.U]
    
    @IBOutlet weak var payloadTypeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    private func initializeUI() {
        payloadTypeTableView.dataSource = self
        payloadTypeTableView.delegate = self
        payloadTypeTableView.rowHeight = 45
    }
}

extension NFCNDEFPayloadTypeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payloadTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NFCNDEFPayloadTypeTableViewCellIdentifier) as? NFCNDEFPayloadTypeTableViewCell {
            cell.titleLabel.text = payloadTypes[indexPath.row].description == "T" ? "Text" : "URI"
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let payloadType = index == 0 ? NFCNDEFPayloadType.T : NFCNDEFPayloadType.U
        if let viewController = storyboard?.instantiateViewController(withIdentifier: NFCNDEFPayloadTypeDetailViewControllerIdentifier) as? NFCNDEFPayloadTypeDetailViewController {
            viewController.setPayloadTypeDetail(payloadType, text: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
