//
//  TimerTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/1.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    static let identifier = "TimerTableViewCell"
    
    var arrowImageView: UIImageView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        // 添加 ">" 符號的 ImageView
        arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = .black
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(arrowImageView)
        
        // 設置約束
        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func addArrowSymbol() {
        if arrowImageView == nil {
            arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrowImageView?.tintColor = .black
            arrowImageView?.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(arrowImageView!)

            // 設置約束
            NSLayoutConstraint.activate([
                arrowImageView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
