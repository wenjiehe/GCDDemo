//
//  OperationQueueManager.h
//  GCDDemo
//
//  Created by 贺文杰 on 2021/7/21.
//  Copyright © 2021 贺文杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OperationQueueManager : NSObject

//主线程中执行回调
- (void)operationMainQueue;

//创建队列及异步线程并添加依赖
- (void)addDependency;

//异步线程
- (void)operation;

//阻塞线程
- (void)waitOperation;

@end

NS_ASSUME_NONNULL_END
