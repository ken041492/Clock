//
//  MainTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var Period: UILabel!
    @IBOutlet weak var ClockTime: UILabel!
    @IBOutlet weak var NoticeBell: UISwitch!
    @IBOutlet weak var indicateWeek: UILabel!
    static let identified = "MainTableViewCell"
    
    var arrowImageView: UIImageView!
    var isAnimated = false
    var delegate: AlarmTableViewCellDelegate?
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupSubviews()
    }
    
//    @IBAction func createNotification(_ sender: UISwitch) {
//        sender.addTarget(self, action: #selector(MainViewController.changeSwitch(_:)), for: .valueChanged)
//    }
    
    func addArrowSymbol() {
        if arrowImageView == nil {
            arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrowImageView?.tintColor = .black
            arrowImageView?.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(arrowImageView!)

            // 設置約束
            NSLayoutConstraint.activate([
                arrowImageView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
                arrowImageView!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }

    func removeArrowSymbol() {
        arrowImageView?.removeFromSuperview()
        arrowImageView = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NoticeBell.isOn = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animateRightCell() {
        UIView.animate(withDuration: 0.2, animations: {
            // 在這裡設置您想要的動畫效果
            // 例如，將cell的內容向右偏移一段距離
            self.transform = CGAffineTransform(translationX: 10, y: 0)
        }) { (_) in
            // 動畫完成後的處理
            // 這裡可以加入一些額外的動作或邏輯
        }
    }
    
    func animateLeftCell() {
        UIView.animate(withDuration: 0.2, animations: {
            // 在這裡設置您想要的動畫效果
            // 例如，將cell的內容向右偏移一段距離
//            self.transform = CGAffineTransform(translationX: -30, y: 0)
            self.transform = .identity
        }) { (_) in
            // 動畫完成後的處理
            // 這裡可以加入一些額外的動作或邏輯
        }
    }
}


protocol AlarmTableViewCellDelegate: AnyObject {
    func switchValueChanged(isOn: Bool, in cell: UITableViewCell)
}
