//
//  ContentView.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/11.
//

import UIKit

class FirstContentView: UIView {

    var viewModel: FirstContentViewModel
    
    var tableView = UITableView()
    
    var reuseIdentifier = "VideoCell"
    
    init(viewModel: FirstContentViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FirstContentView: Presentable {
    func initViewHierarchy() {
        
        self.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
    }
    
    func configureView() {
        
    }
    
    func bind() {
        tableView.register(VideoCell.self, forCellReuseIdentifier: reuseIdentifier)
        // TODO: uitableview automatic height

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        tableView.contentInsetAdjustmentBehavior = .never
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        
        
        viewModel.propergateData = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.propergateDeleteRowEvent = { [weak self] indexPathRow in
            guard let self = self else { return }
            let indexPath = IndexPath.init(row: indexPathRow, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
}

extension FirstContentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension FirstContentView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "지우기") { [weak self] action, view, completionHandler in
            
            // TODO: viewModel
            guard let self = self else { return }
            self.viewModel.didReceiveDeleteVideoEvent(indexPath.row)
            completionHandler(true)
            
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "다른액션") { action, view, completionHandler in
            // TODO: viewModel
            completionHandler(true)
        }
        action.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? VideoCell else { fatalError() }
        
        let viewModel = viewModel.dataSource[indexPath.row]
        cell.configureCell(viewModel: viewModel)
        return cell
    }
    
    //사실 여긴 페이지네이션에 필요 없을듯 한데...
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    //여긴 페이지네이션에 필요하고...
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        if indexPathRow == viewModel.dataSource.count - 1 {
            
            viewModel.didReceiveViewMoreEvent()
        }
    }
}
