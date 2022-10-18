//
//  RootHelperConfiguration.swift
//  
//
//  Created by Serena on 17/10/2022
//


import Foundation

public protocol RootHelperConfiguration {
    typealias ActionHandler = ((FSOperation) throws -> Void)
    
    var action: ActionHandler { get set }
    var useRootHelper: Bool { get }
}
