//
//  ViewController.swift
//  ZebraSwiftExample
//
//  Created by Tiago Do Couto on 8/7/19.
//  Copyright © 2019 Couto Code. All rights reserved.
//

import UIKit
import ZebraSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var zebra: ZebraSwift = {
        let zebra = ZebraSwift()
        zebra.delegate = self
        return zebra
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail":
            guard let detailVC = segue.destination as? DetailViewController else { return }
            detailVC.data = sender as? String
        default:
            fatalError()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zebra.scanners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerCell", for: indexPath)
        cell.textLabel?.text = zebra.scanners[indexPath.row].getScannerName()
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        zebra.connect(to: zebra.scanners[indexPath.row])
    }
}

extension ViewController: ZebraDelegate {
    func scanned(data: String) {
        self.performSegue(withIdentifier: "showDetail", sender: data)
    }
    
    func connected(for device: SbtScannerInfo) {
        tableView.reloadData()
    }
    
    func disconnected(for device: Int32) {
        tableView.reloadData()
    }
    
    func scannerListUpdated() {
        tableView.reloadData()
    }
}

