//
//  WorldClockViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/8/28.
//

import UIKit


class WorldClockViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    var rightBarButton_add: UIBarButtonItem?

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        tableView.register(UINib(nibName: "WorldTableViewCell", bundle: nil), forCellReuseIdentifier: WorldTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigation() {
        
        rightBarButton_add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(jumpToBViewController))
        
        rightBarButton_add?.tintColor = UIColor.orange
        
        navigationItem.rightBarButtonItem = rightBarButton_add
        navigationController!.navigationBar.prefersLargeTitles = true
        title = "世界時鐘"
        additionalSafeAreaInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)

    }
    
    // MARK: - IBAction
    @objc func jumpToBViewController() {
        
        let CityVC = ChooseCityViewController()
        let navigationController = UINavigationController(rootViewController: CityVC)
        navigationController.isNavigationBarHidden = false
        present(navigationController, animated: true, completion: nil)
    }
}
// MARK: - Extension
extension WorldClockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorldTableViewCell.identifier, for: indexPath) as! WorldTableViewCell
        cell.AreaLabel.text = "下太子區"
        cell.TimeGap.text = "今天 -12小時"
        cell.TimeLabel.text = "上午9:11"
        return cell
    }
}
// MARK: - Protocol


