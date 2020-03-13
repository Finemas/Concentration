//
//  LoggingViewController.swift
//  Concentration
//
//  Created by Jan Provazník on 13/03/2020.
//  Copyright © 2020 Jan Provazník. All rights reserved.
//

import UIKit

class LoggingViewController: UIViewController {

    private struct LogGlobals {
        var prefix = ""
        var instanceCounts = [String: Int]()
        var lastLogTime = Date()
        var indentationInterval: TimeInterval = 1
        var indentationString = "--"
    }
    
    private static var logGlobals = LogGlobals()
    
    private static func logPrefix(fro loggingName: String) -> String {
        if logGlobals.lastLogTime.timeIntervalSinceNow < -logGlobals.indentationInterval {
            logGlobals.prefix += logGlobals.indentationString
            print()
        }
        
        logGlobals.lastLogTime = Date()
        return logGlobals.prefix + loggingName
    }
    
    private static func bumpInstanceCount(for loggingName: String) -> Int {
        logGlobals.instanceCounts[loggingName] = (logGlobals.instanceCounts[loggingName] ?? 0) + 1
        return logGlobals.instanceCounts[loggingName]!
    }
    
    private var instanceCount: Int!
    
    var vcLoggingName: String {
        return String(describing: type(of: self))
    }
    
    private func logVCL(_ message: String) {
        if instanceCount == nil {
            instanceCount = LoggingViewController.bumpInstanceCount(for: vcLoggingName)
        }
        
        print("\(LoggingViewController.logPrefix(fro: vcLoggingName))(\(instanceCount!)) \(message)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        logVCL("init(coder:) - created via InterfaceBuilder")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logVCL("init(nibName:bundle:) - create in code")
    }
    
    deinit {
        logVCL("left the heap")
    }
    
    override func awakeFromNib() {
        logVCL("awakeFromNib()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logVCL("viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logVCL("viewWillAppear(animated = \(animated)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logVCL("viewDidAppear(animated = \(animated)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         logVCL("viewWillDisappear(animated = \(animated)")
     }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         logVCL("viewDidDisappear(animated = \(animated)")
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logVCL("didReceiveMemoryWarning()")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL("viewWillLayoutSubviews()")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL("viewDidLayoutSubviews()")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        logVCL("viewWillTransition(to: \(size), with: \(coordinator))")
        
        coordinator.animate(alongsideTransition: { context in
            self.logVCL("begin animate(alongsideTransition:completion:)")
        }, completion: { context in
            self.logVCL("end animate(alongsideTransition:completion)")
        })
    }
}
