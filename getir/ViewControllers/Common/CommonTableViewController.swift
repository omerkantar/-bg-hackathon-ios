//
//  CommonTableViewController.swift
//  getir
//
//  Created by omer kantar on 17.02.2018.
//  Copyright © 2018 cool. All rights reserved.
//

import UIKit



class CommonTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var type: CommonTableViewType = .pack
    
    var cellVMs: [CommonCellViewModel]?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTableView()
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
        refreshControl.frame.origin.y = -20
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: -
}




// MARK: - UITableViewDataSource
extension CommonTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = cellVMs {
            return list.count
        }
        return 10
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
        
    }
}

// MARK: - Enum
enum CommonTableViewType {
    case pack
    case travel
    case state
    
    var cellIdentifier: String {
        switch self {
        case .pack:
            return String(describing: PackTableViewCell.self)
        case .state:
            return String(describing: StateTableViewCell.self)
        case .travel:
            return String(describing: TravelTableViewCell.self)
        }
    }
    
}
