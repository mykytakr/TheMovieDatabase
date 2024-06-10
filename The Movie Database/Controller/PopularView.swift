//
//  PopularView.swift
//  The Movie Database
//
//  Created by Vova Kolomyltsev on 23.05.2024.
//


import UIKit
import SnapKit

class PopularView: UIView {

    let tableView: UITableView = {
        let obj =  UITableView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = .black
        obj.estimatedRowHeight = 250
        return obj
    }()
    
    let searchController: UISearchController = {
        
        let obj = UISearchController()
        obj.obscuresBackgroundDuringPresentation = false
        obj.searchBar.placeholder = "Search Movies or Series"
        obj.searchBar.barStyle = .black
        obj.searchBar.tintColor = .white
        
        if let textFieldInsideSearchBar = obj.searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .white
            textFieldInsideSearchBar.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        }
        
        return obj
        
    }()

    let segmentedControl:  UISegmentedControl = {
       let obj = UISegmentedControl(items: ["Movies", "Series"])
        obj.selectedSegmentTintColor = UIColor(white: 04, alpha: 1.0)
        obj.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        obj.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        obj.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        return obj
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(segmentedControl)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
