//
//  NSObject+LINStorage.h
//  Pods
//
//  Created by Ryohei Kameyama on 2015/02/17.
//
//

#import <Foundation/Foundation.h>
#import "LINStorageError.h"

@interface NSObject (LINStorage)

/// Store object to file
- (void)lin_storeToFile:(NSString *)file error:(NSError **)error;

/// Restore object from file
+ (instancetype)lin_restoreFromFile:(NSString *)file error:(NSError **)error;

/**
 
 Store object to file
 onComplete, onError will be called in mainthread
 
 */
- (void)lin_storeToFile:(NSString *)file
             onComplete:(void (^)(void))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 
 Restore object from file
 onComplete, onError will be called in mainthread
 
 */
+ (void)lin_restoreFromFile:(NSString *)file
                 onComplete:(void (^)(id obj))onComplete
                    onError:(void (^)(NSError *error))onError;

@end
