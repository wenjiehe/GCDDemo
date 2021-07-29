//
//  OperationQueueManager.m
//  GCDDemo
//
//  Created by 贺文杰 on 2021/7/21.
//  Copyright © 2021 贺文杰. All rights reserved.
//

#import "OperationQueueManager.h"

@implementation OperationQueueManager

- (void)operationMainQueue
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{ //主线程中执行
        NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
}

- (void)operation
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
    
    [operationQueue addOperation:operation];
}

- (void)addDependency
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];

    NSBlockOperation *operation5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"5 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];

    NSBlockOperation *operation6 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"6 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];

    NSBlockOperation *operation7 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"7 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];

    NSBlockOperation *operation8 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"8 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];

    
    //相当于异步线程1一定排在2、3后面，其他异步线程是并发的
    [operation1 addDependency:operation2];
    [operation1 addDependency:operation3];
    
    //异步线程2一定排在5后面
    [operation2 addDependency:operation5];
    
    //异步线程6一定排在7后面
    [operation6 addDependency:operation7];
    
    [operationQueue addOperation:operation1];
    [operationQueue addOperation:operation2];
    [operationQueue addOperation:operation3];
    [operationQueue addOperation:operation4];
    [operationQueue addOperation:operation5];
    [operationQueue addOperation:operation6];
    [operationQueue addOperation:operation7];
    [operationQueue addOperation:operation8];
}

- (void)waitOperation
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];

    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4 %s,currentThread = %@ \nend", __FUNCTION__, NSThread.currentThread); //打印当前线程
    }];

    //如果设置waitUntilFinished为YES，那么线程2、3、4（并发）先运行，主线程中的"8888888"会等待2、3、4运行完再执行
    [operationQueue addOperation:operation4];
    [operationQueue addOperations:@[operation2, operation3] waitUntilFinished:YES];
    [operationQueue addOperation:operation1]; //异步调用

    NSLog(@"88888888");
}

@end
