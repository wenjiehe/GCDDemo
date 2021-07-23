//
//  OperationQueueManager.swift
//  GCDDemo-Swfit
//
//  Created by 贺文杰 on 2021/7/23.
//  Copyright © 2021 贺文杰. All rights reserved.
//

import Foundation

/**

 */

//主线程中执行
func operationMainQueue() -> Void {
    OperationQueue.main.addOperation {
        print("async---\(Thread.current)")
    }
}

//异步线程中执行
func operation() -> Void {
    let operationQueue = OperationQueue.init()

    let operation = BlockOperation.init {
        print("async---\(Thread.current)")
    }

    operationQueue.addOperation(operation)
}

//创建队列及异步线程并添加依赖
func addDependency() -> Void {
    let operationQueue = OperationQueue.init()

    let operation1 = BlockOperation.init {
        print("1 async---\(Thread.current)")
    }
    
    let operation2 = BlockOperation.init {
        print("2 async---\(Thread.current)")
    }

    let operation3 = BlockOperation.init {
        print("3 async---\(Thread.current)")
    }

    let operation4 = BlockOperation.init {
        print("4 async---\(Thread.current)")
    }

    let operation5 = BlockOperation.init {
        print("5 async---\(Thread.current)")
    }

    let operation6 = BlockOperation.init {
        print("6 async---\(Thread.current)")
    }

    let operation7 = BlockOperation.init {
        print("7 async---\(Thread.current)")
    }

    let operation8 = BlockOperation.init {
        print("8 async---\(Thread.current)")
    }

    //相当于异步线程1一定排在2、3后面，其他异步线程是并发的
    operation1.addDependency(operation2)
    operation1.addDependency(operation3)
    
    //异步线程2一定排在5后面
    operation2.addDependency(operation5)
    
    //异步线程6一定排在7后面
    operation6.addDependency(operation7)

    operationQueue.addOperation(operation1)
    operationQueue.addOperation(operation2)
    operationQueue.addOperation(operation3)
    operationQueue.addOperation(operation4)
    operationQueue.addOperation(operation5)
    operationQueue.addOperation(operation6)
    operationQueue.addOperation(operation7)
    operationQueue.addOperation(operation8)
    
}
