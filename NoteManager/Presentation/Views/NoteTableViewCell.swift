//
//  NoteTableViewCell.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let ID = "NoteTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let creationDateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let creationDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let creationMonthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(creationDateView)
        creationDateView.addSubview(creationDayLabel)
        creationDateView.addSubview(creationMonthLabel)
        
        NSLayoutConstraint.activate([
            creationDateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            creationDateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creationDateView.widthAnchor.constraint(equalToConstant: 60),
            creationDateView.heightAnchor.constraint(equalToConstant: 40),
            
            creationDayLabel.topAnchor.constraint(equalTo: creationDateView.topAnchor, constant: 4),
            creationDayLabel.centerXAnchor.constraint(equalTo: creationDateView.centerXAnchor),
            
            creationMonthLabel.bottomAnchor.constraint(equalTo: creationDateView.bottomAnchor, constant: -4),
            creationMonthLabel.centerXAnchor.constraint(equalTo: creationDateView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: creationDateView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with note: NoteModel) {
        titleLabel.text = note.title
        contentLabel.text = note.content
        
        let (day, month, year) = note.creationDate.getDateComponents()
        creationDayLabel.text = "\(day)"
        creationMonthLabel.text = "\(month) \(year)"
    }
}
