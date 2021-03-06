//
//  CommonTableViewController.swift
//  getir
//
//  Created by omer kantar on 17.02.2018.
//  Copyright © 2018 cool. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let pendingRequest = Notification.Name("pendingRequest")
}

class CommonTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var type: CommonTableViewType = .pack
    
    var cellVMs: [CommonCellViewModel]?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTableView()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(CommonTableViewController.pendingRequest), name: Notification.Name.pendingRequest, object: nil)
    }
    
    // MARK: - Build
    func buildTableView() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: self.type.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.type.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshingData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    
    // MARK: -
    
    @objc func refreshingData() {
        self.refreshControl.beginRefreshing()
    }
    
    
    // MARK: - Pending Request
    @objc func pendingRequest() {
        self.tabBarController?.selectedIndex = 2
        if let nc = self.tabBarController?.viewControllers?[2] as? UINavigationController {
            if let vc = nc.viewControllers.first as? StateViewController {
                vc.loadData()
            }
        }
    }
}




// MARK: - UITableViewDataSource
extension CommonTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = cellVMs {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.type.cellIdentifier, for: indexPath) as! CommonTableViewCell
        if let vm = cellVMs?[indexPath.row] {
            cell.build(viewModel: vm)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CommonTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch self.type {
        case .pack, .travel:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectRequestVC") as! SelectRequestViewController
            vc.target = self.type == .pack ? .getMyTravels : .getMyPacks
            vc.selectedActivity = self.cellVMs?[indexPath.row].activityModel
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}

// MARK: - Enum
enum CommonTableViewType {
    case pack
    case travel
    
    var cellIdentifier: String {
        switch self {
        case .pack:
            return String(describing: PackTableViewCell.self)
        case .travel:
            return String(describing: TravelTableViewCell.self)
        }
    }
    
}
