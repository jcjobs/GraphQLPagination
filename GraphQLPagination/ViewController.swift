//
//  ViewController.swift
//  GraphQLPagination
//
//  Created by Juan Carlos Perez Delgadillo on 14/09/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let spinner = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()

    private let launchListVM: LaunchListVMProtocol = LaunchListVM(pageSize: 5)
    private var launches = [LaunchListByQuery.Data.Launch.Launch]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        loadData()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        spinner.hidesWhenStopped = true
        tableView.backgroundView = spinner
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

    }
    
    @objc private func refreshData(_ sender: Any) {
        launches.removeAll()
        loadData()
    }
    
    func loadData(for lastCursor: String = "") {
        spinner.startAnimating()
        launchListVM.getAll(for: lastCursor) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                debugPrint(graphQLResult)
                
                self?.launches.append(contentsOf: graphQLResult.launches.compactMap({ $0 }) )
                
                if graphQLResult.hasMore {
                    self?.loadData(for: graphQLResult.cursor)
                } else{
                    debugPrint("No more data... total items: \(self?.launches.count ?? 0)")
                    self?.tableView.reloadData()
                    self?.spinner.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }

            case .failure(let error):
                debugPrint(error)
                self?.launches.removeAll()
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let launch = launches[indexPath.row]
        cell.textLabel?.text = launch.site
        cell.detailTextLabel?.text = launch.mission?.name
        return cell
    }
}
