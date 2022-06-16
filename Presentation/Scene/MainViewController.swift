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
import Common

public final class MainViewController : UIViewController, StoryboardIdentifiable {
    
    // MARK: Interface
    
    public func setViewModel(_ viewModel: MainViewModelProtocol) {
        loadViewIfNeeded()
        self.viewModel = viewModel
    }
    
    // MARK: Private
    
    private var viewModel: MainViewModelProtocol! {
        didSet { observeViewModel() }
    }
    private let scope = DisposeBag()
    
    private var mode: MainMode! {
        didSet {
            editButton.title = mode == .browse ? "편집" : "완료"
            addButton.isVisible = mode == .browse
            tableView.reloadData()
        }
    }
    private var selectedItemIDs: Set<String>? {
        didSet {
            updateDeleteButton()
            tableView.reloadData()
        }
    }
    private var todoItems: [TodoItem]! {
        didSet { tableView.reloadData() }
    }
    
    @IBOutlet private weak var editButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    @IBAction private func editAction(_ sender: UIBarButtonItem) {
        viewModel.userAction(.toggleMode)
    }
    
    @IBAction private func addAction(_ sender: UIButton) {
        viewModel.userAction(.add)
    }
    
    @IBAction private func deleteAction(_ sender: UIButton) {
        viewModel.userAction(.deleteItems)
    }
    
}

extension MainViewController : UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { todoItems?.count ?? 0 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemCell.storyboardID, for: indexPath) as! TodoItemCell
        let item = todoItems[indexPath.item]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.imageView?.image = assign {
            guard let selectedItemIDs = selectedItemIDs else { return nil }
            return selectedItemIDs.contains(item.id)
                ? UIImage(systemName: "checkmark.circle.fill")
                : UIImage(systemName: "circle")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userAction(.selectItem(todoItems[indexPath.item].id))
    }
    
}

private extension MainViewController {
    
    func observeViewModel() {
        viewModel.state.map(\.mode)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { vc, mode in vc.mode = mode })
            .disposed(by: scope)
        
        viewModel.state.map(\.todoItems)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { vc, todoItems in vc.todoItems = todoItems })
            .disposed(by: scope)
        
        viewModel.state.map(\.selectedItemIDs)
            .distinctUntilChanged()
            .map { $0.map(Set.init) }
            .withUnretained(self)
            .do(onNext: { vc, selectedItemIDs in
                assert(Set(vc.todoItems.map(\.id)).isSuperset(of: selectedItemIDs ?? []))
            })
            .subscribe(onNext: { vc, selectedItemIDs in
                vc.selectedItemIDs = selectedItemIDs
            })
            .disposed(by: scope)
    }
    
    func updateDeleteButton() {
        deleteButton.isVisible = selectedItemIDs != nil
        deleteButton.isEnabled = selectedItemIDs.map(\.isNotEmpty) ?? false
    }
    
}

// MARK: Factory

public extension MainViewController {
    
    static func createInstance() -> MainViewController { UIStoryboard.main.createInstance() }
    
}
