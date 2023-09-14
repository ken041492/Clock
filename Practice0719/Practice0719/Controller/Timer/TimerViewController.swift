//
//  TimerViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/8/29.
//

import UIKit

class TimerViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CancleBTN: UIButton!
    @IBOutlet weak var StartBTN: UIButton!
    @IBOutlet weak var indicateLabel: UILabel!
    
    // MARK: - Variables
    let shapeLayer = CAShapeLayer()
    let displayLink = CADisplayLink()
    var pausedTime: CFTimeInterval = 0
    var judgeCount: Int = 0
    let hours = [Int](0...23)
    let minutes = [Int](0...59)
    let seconds = [Int](0...59)
    var hourCount: Int = 0
    var minuteCount: Int = 0
    var secondCount: Int = 0
    var totalCount: Int = 0
    var judgeClick: Bool = true
    var PickerViewSelected: Bool = false
    var timer: Timer?
    var registerCount: Int = 0
    var catchMessage: String = ""
    var sendMention: String = ""
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TimerTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: TimerTableViewCell.identifier)
        tableView.layer.borderWidth = 0.5
        tableView.layer.cornerRadius = 10.0
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        
        StartBTN.layer.cornerRadius = 40
        StartBTN.clipsToBounds = true
        StartBTN.setTitle("開始", for: .normal)
        StartBTN.backgroundColor = .systemGreen
        StartBTN.tintColor = .green
        StartBTN.alpha = 0.8
        
        CancleBTN.layer.cornerRadius = 40
        CancleBTN.clipsToBounds = true
        CancleBTN.setTitle("取消", for: .normal)
        CancleBTN.tintColor = .white
        
        shapeLayer.isHidden = true

        let center = CGPoint(x: view.bounds.width/2 - 20 , y: view.bounds.height/4 - 20 )
        let radius: CGFloat = view.bounds.width/2 - 30
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi + startAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        view.layer.addSublayer(shapeLayer)

    }
    
    // MARK: - IBAction
    @IBAction func CancleCount(_ sender: Any) {
        
        pickerView.isHidden = false
        hour.isHidden = false
        minute.isHidden = false
        second.isHidden = false
        PickerViewSelected = false
        indicateLabel.isHidden = true
        shapeLayer.isHidden = true
        StartBTN.setTitle("開始", for: .normal)
        StartBTN.backgroundColor = .systemGreen
        StartBTN.tintColor = .green
        judgeClick = true
        // 關閉計時器
        timer?.invalidate()

    }
    
    @IBAction func StartPause(_ sender: Any) {
        
        pickerView.isHidden = true
        hour.isHidden = true
        minute.isHidden = true
        second.isHidden = true
        indicateLabel.isHidden = false
        shapeLayer.isHidden = false

        if judgeClick {
            if !PickerViewSelected && StartBTN.currentTitle == "開始"{
                totalCount = hourCount + minuteCount + secondCount
            }
            if StartBTN.currentTitle == "繼續"{
                resumeAnimation()
//                totalCount -= 1
                startCountdownTimer()

            } else {
                startCountdownTimer()
                startAnimation(totalCount)
            }
//            print("total is \(totalCount)")
            StartBTN.setTitle("暫停", for: .normal)
            StartBTN.backgroundColor = .systemYellow
            StartBTN.tintColor = .orange
            judgeClick = false
            
        } else {
            pauseAnimation()
            timer!.invalidate()
            StartBTN.setTitle("繼續", for: .normal)
            StartBTN.backgroundColor = .systemGreen
            StartBTN.tintColor = .green
            judgeClick = true
            
        }
    }
    
    func startCountdownTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(countDown) , userInfo: nil, repeats: true)
            let second_label =  self.totalCount % 60
            let minute_label = (self.totalCount % 3600)/60
            let hour_label = self.totalCount/3600
            let showHours = hour_label > 9 ? "\(hour_label)" : "0\(hour_label)"
            let showMinutes = minute_label > 9 ? "\(minute_label)" : "0\(minute_label)"
            let showSeconds = second_label > 9 ? "\(second_label)" : "0\(second_label)"
            self.indicateLabel.text = "\(showHours):\(showMinutes):\(showSeconds)"
    }
    
    @objc func countDown() {
        judgeCount += 1
        
        totalCount -= 1
        
        let second_label =  self.totalCount % 60
        let minute_label = (self.totalCount % 3600)/60
        let hour_label = self.totalCount/3600
        let showHours = hour_label > 9 ? "\(hour_label)" : "0\(hour_label)"
        let showMinutes = minute_label > 9 ? "\(minute_label)" : "0\(minute_label)"
        let showSeconds = second_label > 9 ? "\(second_label)" : "0\(second_label)"
        self.indicateLabel.text = "\(showHours):\(showMinutes):\(showSeconds)"
        
        if totalCount == 0 {
            self.pickerView.isHidden = false
            self.hour.isHidden = false
            self.minute.isHidden = false
            self.second.isHidden = false
            self.indicateLabel.isHidden = true
            shapeLayer.isHidden = true

            timer?.invalidate()
            StartBTN.setTitle("開始", for: .normal)
            StartBTN.backgroundColor = .systemGreen
            StartBTN.tintColor = .green
            judgeClick = true
            PickerViewSelected = false
            
            createNoticefication()
        }
        
    }
    func createNoticefication() {
        
        let content = UNMutableNotificationContent()
        content.title = "鬧鐘通知"
        content.body = "該起床了！"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(0.01), repeats: false)
        let request = UNNotificationRequest(identifier: "identifier",
                                            content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("無法建立鬧鐘通知: \(error)")
            }
        }
    }
    
    func startAnimation(_ count: Int) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0 // 设置进度的值，这里是0.8
        animation.duration = CFTimeInterval(count) // 动画持续时间
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "progressAnimation")
    }
    
    func pauseAnimation() {
        
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1
        shapeLayer.timeOffset = 0
        shapeLayer.beginTime = 0
        
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
}
// MARK: - Extension
extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else if component == 1 {
            return minutes.count
        } else if component == 2 {
            return seconds.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if component == 0 {
            return "\(hours[row])"
        } else if component == 1 {
            return "\(minutes[row])"
        } else {
            return "\(seconds[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        PickerViewSelected = true
        if component == 0 {
            hourCount = hours[row] * 3600
        }
        else if component == 1 {
            minuteCount = minutes[row] * 60
        }
        else if component == 2 {
            secondCount = seconds[row]
        }
        else {
            print("")
        }
        registerCount = hourCount + minuteCount + secondCount
        totalCount = registerCount
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier, for: indexPath) as! TimerTableViewCell
        if catchMessage == "" {
            cell.noticeLabel.text = "雷達"
        } else {
            cell.noticeLabel.text = catchMessage
        }
        sendMention = cell.noticeLabel.text!
        cell.addArrowSymbol()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let NoticeVC = NoticeViewController()
        NoticeVC.sendMessage = self
        NoticeVC.reloadTimerTableView = self
        NoticeVC.registerMention = sendMention
        let navigationController = UINavigationController(rootViewController: NoticeVC)
        navigationController.isNavigationBarHidden = false
        self.present(navigationController, animated: true, completion: nil)

    }
    
}

extension TimerViewController {
    func updateProgress(to progress: CGFloat) {
        shapeLayer.strokeEnd = progress
    }
}

extension TimerViewController: SendMessage {
    func sendMessage(Message: String) {
        catchMessage = Message
    }
}

extension TimerViewController: ReloadTableViewDelegate {
    func reloadtableview() {
        tableView.reloadData()
    }
}
// MARK: - Protocol


