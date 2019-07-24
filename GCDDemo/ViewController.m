//
//  ViewController.m
//  GCDDemo
//
//  Created by 贺文杰 on 2019/7/17.
//  Copyright © 2019 贺文杰. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property(nonatomic)NSInteger count;

@property(nonatomic)dispatch_source_t timer;

@property(nonatomic,copy)NSString *str;

@end

@implementation ViewController

/**
 多线程开发时容易发生的一些问题:
 1.多个线程更新相同的资源:数据竞争
 2.多个线程相互持续等待:死锁
 3.使用太多的线程导致消耗内存
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createQueue];
}

/**
 串行队列和并发队列。都符号FIFO(先进先出)原则
 1.串行队列(Serial Dispatch Queue):
    1.1 每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）
 2.并发队列(Concurrent Dispatch Queue):
    2.1 可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）
 */
- (void)createQueue
{
    /*
     第一个参数表示队列的唯一标识符，用于DEBUG,可为空,名称推荐使用应用bundleID逆序全程域名
     第二个参数用来识别是串行队列还是并发队列, DISPATCH_QUEUE_SERIAL,串行队列  DISPATCH_QUEUE_CONCURRENT,并发队列
     串行队列和并行队列的优先级，与默认优先级的globalQueue一样
     */
    dispatch_queue_t serialQueue = dispatch_queue_create("GCDDemo.com.hwj.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("GCDDemo.com.hwj.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    ///获取主队列，主队列是特殊的串行队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    /*
        全局并发队列
        第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT
        第二个参数暂时没用，用0即可
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /*
        第一个参数 需要改变优先级的队列
        第二个参数 目标队列
     */
    dispatch_set_target_queue(serialQueue, globalQueue);
    
    ///同步执行任务创建方法
    /*
        同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，知道队列里面的任务完成之后再继续执行。
        只能在当前线程中执行任务，不具备开启新线程的能力。
     */
    dispatch_sync(serialQueue, ^{
        //这里放同步执行任务代码
    });
    
    ///异步执行任务创建方法
    /*
        异步添加任务到指定的队列中，它不会做任务等待，可以继续执行任务。
        可以在新的线程中执行任务，具备开启新线程的能力。
     */
    dispatch_async(concurrentQueue, ^{
        //这里放异步执行任务代码
    });
    
    /*
     6种排列组合
     1.同步执行+并发队列
     2.同步执行+串行队列
     3.同步执行+主队列
     4.异步执行+并发队列
     5.异步执行+串行队列
     6.异步执行+主队列
     
     区别              并发队列                    串行队列                                主队列
     同步(sync)     没有开启新线程，串行执行任务    没有开启新线程，串行执行任务       主线程调用：死锁卡住不执行其他线程调用：没有开启新线程，串行执行任务
     异步(async)    有开启新线程，并发执行任务      有开启新线程(1条)，串行执行任务      没有开启新线程，串行执行任务

     */
    
    ///同步执行+并发队列
//    [self syncConCurrent];
    
    ///同步执行+串行队列
//    [self syncSerial];
    
    ///同步执行+主队列
//    [self syncMain];
    
    ///异步执行+并发队列
//    [self asyncConcurrent];
    
    ///异步执行+串行队列
//    [self asyncSerial];
    
    ///异步执行+主队列
//    [self asyncMain];
    
    ///其他线程调用, 同步执行+主队列,不会产生死锁
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    ///线程间通信
//    [self communication];
    
    ///删栏方法
//    [self barrier];
    
    ///延时执行方法
//    [self after];
    
    ///只执行一次
//    [self once];
    
    ///快速迭代方法
//    [self apply];
    
    ///队列组
//    [self groupNotify];
    
    ///暂停当前线程
//    [self groupWait];
    
    ///进入和离开
    [self groupEnterAndLeave];
    
    ///信号量
//    [self semaphore];
    
    ///线程安全,类似抢票机制
//    [self semaphoreSafe];
    
    ///线程不安全
//    [self semaphoreUnsafe];
    
    ///定时器
//    [self gcdTimer];
    
}

#pragma mark 同步执行+并发队列
///
/// 在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务
- (void)syncConCurrent
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("GCDDemo.com.hwj.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_sync(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync2--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_sync(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync3--%ld---%@", i, NSThread.currentThread);
        }
    });
    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 同步执行+串行队列
///
/// 不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
- (void)syncSerial
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程

    dispatch_queue_t serialQueue = dispatch_queue_create("GCDDemo.com.hwj.serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(serialQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_sync(serialQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync2--%ld---%@", i, NSThread.currentThread);
        }
    });

    dispatch_sync(serialQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync3--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 同步执行+主队列
///
/// 互相等待卡住不执行，不会开启新线程，执行完一个任务，再执行下一个任务
- (void)syncMain
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    /*
        把syncMain放入主线程的队列中，任务1添加到主队列中，任务1等待主线程处理完syncMain,syncMain等待任务1处理完才能接着执行，这样子的话，就会互相等待，死锁
     */

    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_sync(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync1--%ld---%@", i, NSThread.currentThread);
        }
    });

    dispatch_sync(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync2--%ld---%@", i, NSThread.currentThread);
        }
    });

    dispatch_sync(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"sync3--%ld---%@", i, NSThread.currentThread);
        }
    });

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 异步执行+并发队列
///
/// 可以开启多个线程，任务交替（同时）执行
- (void)asyncConcurrent
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    dispatch_queue_t concurrentQueue = dispatch_queue_create("GCDDemo.com.hwj.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 4; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
    });

    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async3--%ld---%@", i, NSThread.currentThread);
        }
    });

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 异步执行+串行队列
///
/// 会开启新线程,但是因为任务是串行的，执行完一个任务，再执行下一个任务
- (void)asyncSerial
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    dispatch_queue_t serialQueue = dispatch_queue_create("GCDDemo.com.hwj.serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_async(serialQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_async(serialQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async3--%ld---%@", i, NSThread.currentThread);
        }
    });

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 异步执行+主队列
///
/// 只在主线程中执行任务，执行完一个任务，再执行下一个任务
- (void)asyncMain
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程

    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_async(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_async(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async3--%ld---%@", i, NSThread.currentThread);
        }
    });

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 线程间通信
- (void)communication
{
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    dispatch_async(globalQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async0--%ld---%@", i, NSThread.currentThread);
        }
        
        dispatch_async(mainQueue, ^{
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async0---%@", NSThread.currentThread);
        });
    });
}

#pragma mark 删栏方法
///
/// 会等待前边加入到异步或同步队列里的任务执行完，再执行删栏方法里面的任务，然后再执行后边等待的任务
- (void)barrier
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程

    //barrier blocks提交到使用DISPATCH_QUEUE_CONCURRENT创建的并行queue时，才会表现的如同预期
    dispatch_queue_t concurrentQueue = dispatch_queue_create("GCDDemo.com.hwj.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
    });

    dispatch_barrier_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"barrier--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async3--%ld---%@", i, NSThread.currentThread);
        }
    });

    dispatch_async(concurrentQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async4--%ld---%@", i, NSThread.currentThread);
        }
    });

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 延时执行方法
- (void)after
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //2秒后异步追加代码到主线程中，并开始执行
        NSLog(@"---%@", NSThread.currentThread);
    });
    
    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 只执行一次
- (void)once
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //代码只执行一次,默认线程安全
        NSLog(@"---%@", NSThread.currentThread);
    });
    
    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 快速迭代方法
/// 如果快速迭代方法在串行队列中，那么就和for循环一样，按顺序执行，dispatch_apply会等待任务全部执行完
- (void)apply
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_apply(5, globalQueue, ^(size_t index) {
        NSLog(@"--%ld---%@", index, NSThread.currentThread);
    });
    
    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 队列组
/*
 场景:分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务
 */
- (void)groupNotify
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"--%ld---%@", i, NSThread.currentThread);
        }
    });

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 暂停当前线程
- (void)groupWait
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async1--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    //等待上面的任务全部完成后，会继续往下执行（会阻塞当前线程)
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 进入和离开
/// dispatch_group_enter 标志着一个任务追加到了group,执行一次，相当于group中未执行完毕任务数+1
/// dispatch_group_leave 标志着一个任务离开了group,执行一次，相当于group中未执行完毕任务数-1
- (void)groupEnterAndLeave
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //追加任务
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async1--%ld---%@", i, NSThread.currentThread);
        }
        //执行完离开
        dispatch_group_leave(group);
    });
    
    //追加任务
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
        //执行完离开
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"--%ld---%@", i, NSThread.currentThread);
        }
    });
    
    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 信号量
///dispatch_semaphore 使用计数来完成这个功能，计数小于0时等待，不可通过，计数为0或大于0时，计数减1且不等待，可通过
///dispatch_semaphore_signal 发送一个信号，让信号总量加1
///dispatch_semaphore_wait 可以使总信号量减1，信号总量小于0时就会一直等待(阻塞所在线程)，否则就可以正常执行
///实际开发应用场景 ：
///1.保持线程同步，将异步执行任务转换为同步执行任务
///2.保证线程安全，为线程加锁
- (void)semaphore
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    //执行顺序 1,信号总量为0
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block NSInteger number = 0;
    //执行顺序 3
    dispatch_async(globalQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; //模拟耗时操作
            NSLog(@"async2--%ld---%@", i, NSThread.currentThread);
        }
        number = 50;
        
        //执行顺序 4,信号总量为0
        dispatch_semaphore_signal(semaphore); //信号总量加1
    });
    
    NSLog(@"number = %ld", number);

    //执行顺序 2,信号总量为-1
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //等待，并使总信号量减1
    NSLog(@"number = %ld", number);

    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

#pragma mark 线程安全
///保证线程安全，为线程加锁
- (void)semaphoreSafe
{
    _count = 50;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_queue_t serialQueue1 = dispatch_queue_create("GCDDemo.com.hwj.serial1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("GCDDemo.com.hwj.serial2", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self) weakSelf = self;
    dispatch_async(serialQueue1, ^{
        [weakSelf safe:semaphore];
    });
    
    dispatch_async(serialQueue2, ^{
        [weakSelf safe:semaphore];
    });

}

- (void)safe:(dispatch_semaphore_t)semaphore
{
    while (1) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (_count > 0) {
            _count--;
            NSLog(@"count = %ld, currentThread = %@ \n", _count, NSThread.currentThread); //打印当前线程
            [NSThread sleepForTimeInterval:1];
        }else{
            NSLog(@"已结束");
            dispatch_semaphore_signal(semaphore);
            break;
        }
        dispatch_semaphore_signal(semaphore);
    }
}

#pragma mark 线程不安全
///多个线程操作同一个变量，线程之间没有同步
- (void)semaphoreUnsafe
{
    _count = 50;
    
    dispatch_queue_t serialQueue1 = dispatch_queue_create("GCDDemo.com.hwj.serial1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("GCDDemo.com.hwj.serial2", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self) weakSelf = self;
    dispatch_async(serialQueue1, ^{
        [weakSelf notSafe];
    });
    
    dispatch_async(serialQueue2, ^{
        [weakSelf notSafe];
    });
}

- (void)notSafe
{
    while (1) {
        if (_count > 0) {
            _count--;
            NSLog(@"count = %ld, currentThread = %@ \n", _count, NSThread.currentThread); //打印当前线程
            [NSThread sleepForTimeInterval:1];
        }else{
            NSLog(@"已结束");
            break;
        }
    }
}

#pragma mark 定时器
- (void)gcdTimer
{
    NSLog(@"%s,currentThread = %@ \nbegin", __FUNCTION__, NSThread.currentThread); //打印当前线程
    
    //需要将dispatch_source_t设置为成员变量，不然会立即释放
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 3 * NSEC_PER_SEC, 5 * NSEC_PER_SEC);
    __block dispatch_source_t tempTimer = _timer;
    __block NSInteger index = 0;
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"好起来了");
        index++;
        
        if (index == 3) {
            //取消定时器
//            dispatch_source_cancel(tempTimer);
            
            //暂停定时器
            dispatch_suspend(tempTimer);
        }

    });
    //启动定时器
    dispatch_resume(_timer);
    
    NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
}

@end
