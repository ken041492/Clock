//
//  StopWatchViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/8/29.
//

import UIKit
class StopWatchViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var stopWatchTime: UILabel!
    @IBOutlet weak var startLapButton: UIButton!
    @IBOutlet weak var clickLapButton: UIButton!
    @IBOutlet weak var stopWatchLapView: UITableView!
    
    // MARK: - Variables
    var startStatus = true
    var canLapStatus = false
    var millSeconds = 0
    var timer = Timer()
    var stopWatches = [String]()
    var showTimeString = ""
    var calcuMilSec = 0
    var calcuSec = 0
    var calcuMin = 0
    var calcuHour = 0
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopWatchLapView.delegate = self
        stopWatchLapView.dataSource = self
        stopWatchLapView.register(UINib(nibName: "StopWatchCell", bundle: nil), forCellReuseIdentifier: StopWatchCell.identifier)
        setupUI()
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
        clickLapButton.isEnabled = false
        clickLapButton.setTitleColor(.lightGray, for: .normal)
        
        
        startLapButton.layer.cornerRadius = 40
        startLapButton.clipsToBounds = true
        startLapButton.setTitle("開始", for: .normal)
        startLapButton.backgroundColor = .systemGreen
        startLapButton.tintColor = .green
        startLapButton.alpha = 0.8
        
        clickLapButton.layer.cornerRadius = 40
        clickLapButton.clipsToBounds = true
        clickLapButton.setTitle("取消", for: .normal)
        clickLapButton.backgroundColor = .systemGray
        clickLapButton.tintColor = .white
    }
    
    // MARK: - IBAction
    @IBAction func startStopWatch(_ sender: Any) {
    
        if startStatus{
            startStatus = false
            canLapStatus = true
            
            startLapButton.setTitle("停止" ,for: .normal)
            startLapButton.setTitleColor(.red, for: .normal)
            startLapButton.backgroundColor = .systemRed
            
            clickLapButton.setTitle("分圈" ,for: .normal)
            clickLapButton.setTitleColor(.white, for: .normal)
            clickLapButton.isEnabled = true
            
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        }else{
            startStatus = true
            canLapStatus = false
            startLapButton.setTitle("開始" ,for: .normal)
            startLapButton.backgroundColor = .systemGreen
            startLapButton.setTitleColor(.green, for: .normal)
            
            clickLapButton.setTitle("重製" ,for: .normal)
            timer.invalidate()
           }
        
    }
    
    @IBAction func lapStopWatch(_ sender: UIButton) {
        
        if canLapStatus{
            stopWatches.insert(stopWatchTime.text!,at: 0)
            stopWatchLapView.reloadData()
        }else{
            stopWatches.removeAll()
            stopWatchLapView.reloadData()
            millSeconds = 0
            calcuMilSec = 0
            calcuSec = 0
            calcuMin = 0
            calcuHour = 0
            stopWatchTime.text = "00:00.00"
            startStatus = true
            canLapStatus = false
            clickLapButton.setTitle("分圈" ,for: .normal)
            clickLapButton.setTitleColor(.white, for: .normal)
        }
    }

    @objc func countDown(){
        
        millSeconds += 1
        
        calcuHour = millSeconds/360000
        calcuMin =  millSeconds/6000
        calcuSec = (millSeconds/100)%60
        calcuMilSec = millSeconds%100
        
        let showHour = calcuHour>9 ? "\(calcuHour)":"0\(calcuHour)"
        let showMin =  calcuMin>9 ? "\(calcuMin)" : "0\(calcuMin)"
        let showSec = calcuSec>9 ? "\(calcuSec)":"0\(calcuSec)"
        let showMilSec = calcuMilSec>9 ?"\(calcuMilSec)":"0\(calcuMilSec)"
        showTimeString = calcuMin>59 ? "\(showHour):\(showMin):\(showSec).\(showMilSec)": "\(showMin):\(showSec).\(showMilSec)"
        stopWatchTime.text = showTimeString
    }
}
// MARK: - Extension
extension StopWatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stopWatches.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StopWatchCell.identifier, for: indexPath) as? StopWatchCell
        
        cell?.lapLabel.text = "第\( stopWatches.count-indexPath.row)圈"
        cell?.timerResultLabel.text = "\(stopWatches[indexPath.row])"
       
        return cell!
        
   }
}
// MARK: - Protocol




