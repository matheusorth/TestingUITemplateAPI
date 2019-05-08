//
//  ViewController.swift
//  TestingUITemplateAPI
//
//  Created by Matheus Orth on 08.05.19.
//  Copyright © 2019 collab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fixedTopView: FixedTopView!
    @IBOutlet weak var contentView: ContentView!
    @IBOutlet weak var fixedBottomView: FixedTopView!
    
    var datasource: ViewControllerDataSource? {
        didSet {
            updateAll()
        }
    }
    
    enum Module {
        case fixedTopView
        case contentView
        case fixedBottomView
    }
    
    func updateAll() {
        datasource?.availableModules().forEach({ self.update(module: $0) })
    }

    func update(module: Module) {
        guard let viewModel = datasource?.viewModel(for: module) else {
            return
        }
        switch module {
        case .fixedTopView:
            fixedTopView.inject(viewModel: viewModel)
        case .contentView:
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            let subView = FixedTopView()
            contentView.addSubview(subView)
            subView.inject(viewModel: viewModel)
        case .fixedBottomView:
            fixedBottomView.inject(viewModel: viewModel)
        }
    }

}

protocol ViewControllerDataSource {
    /// Modules that will be configure in method viewModel(for:)
    ///
    /// - Returns: modules
    func availableModules() -> [ViewController.Module]
    
    /// Everytime a certain ModuleView will be updated, this will be the viewModel for that Module
    ///
    /// - Parameter module: module type to be updated
    /// - Returns: viewModel to update desired module type
    func viewModel(for module: ViewController.Module) -> ViewModeling
}

// MARK: - Basics

protocol ViewModeling {
}

protocol ModuleView: UIView {
    func inject(viewModel: ViewModeling)
}

// MARK: - FixedTopView

class FixedTopView: UIView, ModuleView {

    @IBOutlet private weak var headerView: FixedTopView.HeaderView!
    
    func inject(viewModel: ViewModeling) {
        guard let viewModel = viewModel as? FixedTopViewModeling else {
            return
        }
        headerView?.titleLabel.text = viewModel.title
    }
    
}

protocol FixedTopViewModeling: ViewModeling {
    var title: String { get }
}

class FixedTopViewModel: FixedTopViewModeling {

    var title: String
    
    init(services: String, descriptor: String) {
        self.title = descriptor
    }
}

// MARK: - HeaderView

extension FixedTopView {
    fileprivate class HeaderView: UIView {
        
        @IBOutlet weak var titleLabel: UILabel!
    }
}


// MARK: - Content View

class ContentView: UIView, ModuleView {
    
    private var viewModel: ContentViewModeling?
    
    func inject(viewModel: ViewModeling) {
        self.viewModel = viewModel as? ContentViewModeling
    }
    
}

protocol ContentViewModeling: ViewModeling {
}

class ContentViewModel: ContentViewModeling {
    
    
}
