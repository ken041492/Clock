//
//  ChooseCityViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/4.
//

import UIKit

class ChooseCityViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var rightBarButton_cancle: UIBarButtonItem?
    var EditingText: String = ""
    let timeZones = TimeZone.knownTimeZoneIdentifiers
    var Zh_TimeZones: [String] = []
    var selectArea: String = ""
    var sendCityToDelegate: SendCityToDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar = CustomNavigationBar()

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
        
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: CityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let textField = UITextField(frame: CGRect(x: 0, y: 0,
                                                  width: (self.navigationController?.navigationBar.frame.size.width)!,
                                                  height: 30))
        textField.borderStyle = .roundedRect
        textField.placeholder = "搜尋"
//        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.addAction(UIAction(handler: {action in self.textfieldTextChanged(text: textField.text!)}), for: .editingChanged)
//        textField.frame.origin.y = 100
        navigationItem.titleView = textField

    }
    
    func setupNavigation() {
        title = "選擇城市"
        
        rightBarButton_cancle = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancle))
        rightBarButton_cancle?.tintColor = .orange
        navigationItem.rightBarButtonItem = rightBarButton_cancle
    }
    
    // MARK: - IBAction
    @objc func cancle() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textfieldTextChanged(text: String) {
        print(text)
    }
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if let newText = textField.text {
//            let reg = newText
//            EditingText = reg
//        }
//
//    }
    
    func City_EngToZh() {
        let locale = Locale(identifier: "zh_Hant")
        // 定义要过滤的关键词
        let keywords = ["時間", "標準"]
        // 遍历所有时区标识符，并获取它们的中文名称
        for timeZoneIdentifier in timeZones {
            if let timeZone = TimeZone(identifier: timeZoneIdentifier) {
                if let localizedName = timeZone.localizedName(for: .standard, locale: locale) {
                    print("\(timeZoneIdentifier): \(localizedName)")
                    
                    var filteredTimeZone = localizedName
                    for keyword in keywords {
                        filteredTimeZone = filteredTimeZone.replacingOccurrences(of: keyword, with: "").trimmingCharacters(in: .whitespaces)
                    }
//                    print(filteredTimeZone)
                    Zh_TimeZones.append(filteredTimeZone)
                }
            }
        }
    }
    
    func timeGap(to identifier: String) -> Int{
        let taiwanTimeZone = TimeZone(identifier: "Asia/Taipei")
            // 获取其他时区（以美国纽约为例）
        if let newYorkTimeZone = TimeZone(identifier: identifier) {
            // 计算台湾时区与纽约时区之间的时差（以秒为单位）
            let timeDifferenceInSeconds = newYorkTimeZone.secondsFromGMT() - taiwanTimeZone!.secondsFromGMT()

            // 将时差转换为小时
            let timeDifferenceInHours = Double(timeDifferenceInSeconds) / 3600.0

            // 打印时差
            return Int(timeDifferenceInHours)
        }
        return 0
    }
}
// MARK: - Extension
extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        cell.CityLabel.text = timeZones[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectArea = timeZones[indexPath.row]
        
        print("TimeGap is \(timeGap(to: selectArea)) ")
        
//        sendCityToDelegate?.sendCity(selectArea: <#T##String#>)
        dismiss(animated: true, completion: nil)
    }
    
    
}
// MARK: - Protocol

protocol SendCityToDelegate {
    func sendCity(selectArea: String)
}

