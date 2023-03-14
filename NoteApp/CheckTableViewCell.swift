//
//  CheckTableViewCell.swift
//  NoteApp
//
//  Created by Severus Snape on 4.03.2023.
//

import UIKit

class CheckTableViewCell: UITableViewCell {

    var checkboxImageView: UIImageView!

       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupCheckbox()
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       private func setupCheckbox() {
           checkboxImageView = UIImageView(image: UIImage(named: "checkbox"))
           contentView.addSubview(checkboxImageView)

           // checkbox'ı hücrenin sol tarafına yerleştirin
           checkboxImageView.frame = CGRect(x: 10, y: contentView.center.y - 15, width: 30, height: 30)
       }

       // seçildiğinde checkbox'ın durumunu değiştirmek için bir işlev
       func setChecked(_ checked: Bool) {
           checkboxImageView.isHighlighted = checked
       }
    
}
