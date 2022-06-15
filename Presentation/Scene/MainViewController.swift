//
//  MainViewController.swift
//  Presentation
//
//  Created by josh.fn7 on 2022/06/15.
//

import UIKit
import RxSwift
import Domain
import Application

public final class MainViewController : UIViewController, StoryboardIdentifiable {
    
    // MARK: Interface
    
    public func setViewModel(_ viewModel: MainViewModelProtocol) {
        loadViewIfNeeded()
        self.viewModel = viewModel
    }
    
    // MARK: Private
    
    private func observeViewModel() {
        viewModel.state
            .withUnretained(self)
            .subscribe(onNext: { vc, state in vc.todoItems = state.todoItems })
            .disposed(by: scope)
    }
    
    private var viewModel: MainViewModelProtocol! {
        didSet { observeViewModel() }
    }
    private let scope = DisposeBag()
    
    private var todoItems: [TodoItem]! {
        didSet { tableView.reloadData() }
    }
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction private func addAction(_ sender: UIButton) {
        viewModel.userAction(.add)
    }
    
}

extension MainViewController : UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { todoItems.count }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemCell.storyboardID, for: indexPath) as! TodoItemCell
        let item = todoItems[indexPath.item]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userAction(.selectItem(todoItems[indexPath.item].id))
    }
    
}

// MARK: Factory

public extension MainViewController {
    
    static func createInstance() -> MainViewController { UIStoryboard.main.createInstance() }
    
}
