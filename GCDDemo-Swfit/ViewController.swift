//
//  ViewController.swift
//  GCDDemo-Swfit
//
//  Created by 贺文杰 on 2019/7/17.
//  Copyright © 2019 贺文杰. All rights reserved.
//

import UIKit
//import OperationQueueManager

/**
 多线程开发时容易发生的一些问题:
 1.多个线程更新相同的资源:数据竞争
 2.多个线程相互持续等待:死锁
 3.使用太多的线程导致消耗内存
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        createQueue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //主线程中执行
//        operationMainQueue()
        
        //异步线程中执行
//        operation()
        
        //创建队列及异步线程并添加依赖
//        addDependency()
        
        
        waitOperation()
    }
        
    /**
     串行队列和并发队列。都符号FIFO(先进先出)原则
     * 串行队列(Serial Dispatch Queue):
       * 每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）
     * 并发队列(Concurrent Dispatch Queue):
       * 可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）
     */
    func createQueue(){
        
        /**
         串行队列和并行队列
         */
        let serialQueue = OS_dispatch_queue_serial.init(label: "GCDDemo.com.hwj.serial")
        let concurrentQueue = OS_dispatch_queue_concurrent.init(label: "GCDDemo.com.hwj.concurrent")
        
        //主队列
        let mainQueue = DispatchQueue.main
        
        /**
         全局并发队列

         background 用户不可见，比如在后台存储大量数据
         utility 可以执行很长时间，再通知用户结果。比如下载一个文件，给用户下载进度。
         userInteractive 和用户交互相关，比如动画等等优先级最高。比如用户连续拖拽的计算
         userInitiated 需要立刻的结果，比如push一个ViewController之前的数据计算
         `default`
         unspecified
         */
        let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        let global = DispatchQueue.global()
        
        ///同步执行+并发队列
//        syncConCurrent()
        
        ///同步执行+串行队列
//        syncSerial()
        
        ///同步执行+主队列
//        syncMain()
        
        ///异步执行+并发队列
//        asyncConcurrent()
        
        ///异步执行+串行队列
//        asyncSerial()
        
        ///异步执行+主队列
//        asyncMain()
        
        ///线程间通信
//        communication()
        
        ///快速迭代方法
//        apply()
        
        ///队列组
//        notify()
        
        ///延迟执行方法
//        after()
        
        ///挂起和唤醒
//        suspendAndResume()
        
        ///添加和离开
//        groupEnterAndLeave()
        
        ///信号量
        semaphore()
        
        ///多个线程操作同一个变量，线程之间没有同步
//        unSafeSemaphore()
    }

    //MARK: 同步执行+并发队列
    ///
    /// 在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务
    func syncConCurrent(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程

        let concurrentQueue1 = OS_dispatch_queue_concurrent.init(label: "GCDDemo.com.hwj.concurrent1")
        
        concurrentQueue1.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync1--\(i)---\(Thread.current)")
            })
        }
        
        let concurrentQueue2 = OS_dispatch_queue_concurrent.init(label: "GCDDemo.com.hwj.concurrent2")
        concurrentQueue2.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync2--\(i)---\(Thread.current)")
            })
        }

        let concurrentQueue3 = OS_dispatch_queue_concurrent.init(label: "GCDDemo.com.hwj.concurrent3")
        concurrentQueue3.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync3--\(i)---\(Thread.current)")
            })
        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程

    }
    
    //MARK: 同步执行+串行队列
    ///
    /// 不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
    func syncSerial(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程

        let serialQueue1 = OS_dispatch_queue_serial.init(label: "GCDDemo.com.hwj.serial1")
        serialQueue1.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync1--\(i)---\(Thread.current)")
            })
        }
        
        let serialQueue2 = OS_dispatch_queue_serial.init(label: "GCDDemo.com.hwj.serial2")
        serialQueue2.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync2--\(i)---\(Thread.current)")
            })
        }

        let serialQueue3 = OS_dispatch_queue_serial.init(label: "GCDDemo.com.hwj.serial3")
        serialQueue3.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync3--\(i)---\(Thread.current)")
            })
        }

        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    //MARK: 同步执行+主队列
    ///
    /// 互相等待卡住不执行，不会开启新线程，执行完一个任务，再执行下一个任务
    func syncMain(){
        let mainQueue = DispatchQueue.main

        /*
         把syncMain放入主线程的队列中，任务1添加到主队列中，任务1等待主线程处理完syncMain,syncMain等待任务1处理完才能接着执行，这样子的话，就会互相等待，死锁
         */
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        mainQueue.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync1--\(i)---\(Thread.current)")
            })
        }
        
        mainQueue.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync2--\(i)---\(Thread.current)")
            })
        }

        mainQueue.sync {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("sync3--\(i)---\(Thread.current)")
            })
        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    //MARK: 异步执行+并发队列
    ///
    /// 可以开启多个线程，任务交替（同时）执行
    func asyncConcurrent(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let concurrentQueue1 = OS_dispatch_queue_concurrent.init(label: "GCDDemo.com.hwj.concurrent1")
        concurrentQueue1.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async1--\(i)---\(Thread.current)")
            })
        }
        
        let concurrentQueue2 = OS_dispatch_queue_concurrent.init(label: "GCDDemo.com.hwj.concurrent2")
        concurrentQueue2.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async2--\(i)---\(Thread.current)")
            })
        }

        let concurrentQueue3 = OS_dispatch_queue_concurrent.init(label: "GCDDemo.com.hwj.concurrent3")
        concurrentQueue3.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async3--\(i)---\(Thread.current)")
            })
        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    //MARK: 异步执行+串行队列
    ///
    /// 会开启新线程,但是因为任务是串行的，执行完一个任务，再执行下一个任务
    func asyncSerial(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let serialQueue1 = OS_dispatch_queue_serial.init(label: "GCDDemo.com.hwj.serial1")
        serialQueue1.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async1--\(i)---\(Thread.current)")
            })
        }
        
        let serialQueue2 = OS_dispatch_queue_serial.init(label: "GCDDemo.com.hwj.serial2")
        serialQueue2.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async2--\(i)---\(Thread.current)")
            })
        }

        let serialQueue3 = OS_dispatch_queue_serial.init(label: "GCDDemo.com.hwj.serial3")
        serialQueue3.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async3--\(i)---\(Thread.current)")
            })
        }

        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    //MARK: 异步执行+主队列
    ///
    /// 只在主线程中执行任务，执行完一个任务，再执行下一个任务
    func asyncMain(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let mainQueue = DispatchQueue.main
        
        mainQueue.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async1--\(i)---\(Thread.current)")
            })
        }
        
        mainQueue.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async2--\(i)---\(Thread.current)")
            })
        }
        
        mainQueue.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async3--\(i)---\(Thread.current)")
            })
        }

        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }

    //MARK: 线程间通信
    func communication(){
        let mainQueue = DispatchQueue.main
//        let gogal = DispatchQueue.global()
        let concurrentQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        concurrentQueue.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async1--\(i)---\(Thread.current)")
            })
        }
        
        mainQueue.async {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async2--\(i)---\(Thread.current)")
            })
        }
    }
    
    //MARK: 快速迭代方法
    func apply(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程

        //apply的进阶方法,有可能在main线程里面执行，如果想全部为异步线程调用就加一个
        DispatchQueue.global().async {
            DispatchQueue.concurrentPerform(iterations: 10) { (i) in
                print("\(i)---\(Thread.current)")
            }
        }
//        DispatchQueue.concurrentPerform(iterations: 10) { (i) in
//            print("\(i)---\(Thread.current)")
//        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    func notify(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let groupQueue = DispatchGroup.init()
        
        let queue = DispatchQueue.init(label: "GCDDemo.com.hwj")
        
        queue.async(group: groupQueue, execute: DispatchWorkItem.init(block: {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async1--\(i)---\(Thread.current)")
            })
        }))
        
        let date = Date.init()
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        print("\(dateFormatter.string(from: date))")
        
        //阻塞groupQueue线程4秒
        groupQueue.wait(timeout: .now() + .seconds(4))
        
        let date1 = Date.init()
        print("\(dateFormatter.string(from: date1))")

        let lookQueue = DispatchQueue.init(label: "GCDDemo.com.book")
        let date2 = Date.init()
        lookQueue.async(group: groupQueue, execute: DispatchWorkItem.init(block: {
            print("\(dateFormatter.string(from: date2))")
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async2--\(i)---\(Thread.current)")
            })
        }))
        
        //等待groupQueue线程里面的任务执行完毕
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global()
        groupQueue.notify(queue: mainQueue) {
            print("开启一个新的异步线程")
            print("随机测试\(Thread.current)")
            globalQueue.async(execute: {
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("随机测试\(Thread.current)")
            })
        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    //MARK:延时执行方法
    func after(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let date = Date.init()
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        print("\(dateFormatter.string(from: date))")
        
        let mainQueue = DispatchQueue.main
        mainQueue.asyncAfter(deadline: DispatchTime.now() + 3) {
            let date1 = Date.init()
            print("随机测试\(Thread.current)--\(dateFormatter.string(from: date1))")
        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    //MARK:挂起和唤醒
    func suspendAndResume(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        let queue = DispatchQueue.init(label: "gcdDemo.hwj.ceshi")
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        print("\(formatter.string(from: Date.init()))")
        
        ///调用挂起方法后，创建的异步线程就会被挂起，只能挂起还没执行的队列
        //挂起
        queue.suspend()
        queue.async {
            print("正在执行中--\(Thread.current)")
        }
        
        queue.async {
            print("是否唤醒--\(Thread.current)")
        }
        
        let otherQueue = DispatchQueue.init(label: "gcdDemo.hwj.ohter")
        otherQueue.async {
            print("另外一条线程--\(Thread.current)")
        }

        print("\(formatter.string(from: Date.init()))")
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
            print("\(formatter.string(from: Date.init()))")
            //等待3秒后唤醒
            queue.resume()
        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    //MARK:进入和离开
    func groupEnterAndLeave(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let groupQueue = DispatchGroup.init()
        let globalQueue = DispatchQueue.global()
        groupQueue.enter()
        globalQueue.async(group: groupQueue, execute: DispatchWorkItem.init(block: {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async1--\(i)---\(Thread.current)")
            })
            groupQueue.leave()
        }))

        groupQueue.enter()
        globalQueue.async(group: groupQueue, execute: DispatchWorkItem.init(block: {
            (0...2).forEach({ (i) in
                Thread.sleep(forTimeInterval: 2) //模拟耗时操作
                print("async2--\(i)---\(Thread.current)")
            })
            groupQueue.leave()
        }))

        groupQueue.notify(queue: DispatchQueue.main) {
            print("回到主线程\(Thread.current)")
        }
        

        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    var count = 50
    
    //MARK:信号量
    func semaphore(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let semaphoreGCD = DispatchSemaphore.init(value: 1)
        
        let queue1 = OS_dispatch_queue_concurrent.init(label: "gcddemo.hwj.queue1")
        let queue2 = OS_dispatch_queue_concurrent.init(label: "gcddemo.hwj.queue2")

        queue1.async {
            self.safeSemaphore(semaphore: semaphoreGCD)
        }
        
        queue2.async {
            self.safeSemaphore(semaphore: semaphoreGCD)
        }
        
        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }
    
    func safeSemaphore(semaphore : DispatchSemaphore){
        while true {
            //表示信号量-1
            semaphore.wait()
            if count > 0{
                count -= 1
                print("\(count)+\(Thread.current)")
                Thread.sleep(forTimeInterval: 1)
            }else{
                //表示信号量+1
                semaphore.signal()
                break
            }
            semaphore.signal()
        }
    }
    
    //MARK:多个线程操作同一个变量，线程之间没有同步
    func unSafeSemaphore(){
        print("\(#function),currentThread = \(Thread.current) \nbegin") //打印当前线程
        
        let queue1 = OS_dispatch_queue_concurrent.init(label: "gcddemo.hwj.queue1")
        let queue2 = OS_dispatch_queue_concurrent.init(label: "gcddemo.hwj.queue2")

        queue1.async {
            self.unSafe()
        }
        
        queue2.async {
            self.unSafe()
        }

        print("\(#function),currentThread = \(Thread.current) \nend") //打印当前线程
    }

    func unSafe(){
        while true {
            if count > 0{
                count -= 1
                print("\(count)+\(Thread.current)")
                Thread.sleep(forTimeInterval: 1)
            }else{
                break
            }
        }
    }



    
}

