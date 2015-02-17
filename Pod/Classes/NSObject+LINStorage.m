//
//  NSObject+LINStorage.m
//  Pods
//
//  Created by Ryohei Kameyama on 2015/02/17.
//
//

#import "NSObject+LINStorage.h"

@implementation NSObject (LINStorage)

- (void)lin_storeToFile:(NSString *)file error:(NSError **)error {
    NSAssert([self conformsToProtocol:@protocol(NSCoding)], @"Object must implement NSCoding");
    
    BOOL success = [NSFileManager.defaultManager createDirectoryAtPath:[file stringByDeletingLastPathComponent]
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:error];
    
    if (!success) {
        if (!*error) {
            *error = [NSError errorWithDomain:LINStorageErrorDomain
                                         code:LINStorageErrorArchiveObjectFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Failed to createDirectoryAtPath:withIntermediateDirectories:attributeserror:"}];
        }
        
        return;
    }
    
    if (![NSKeyedArchiver archiveRootObject:self toFile:file]) {
        
        *error = [NSError errorWithDomain:LINStorageErrorDomain
                                     code:LINStorageErrorArchiveObjectFailed
                                 userInfo:@{NSLocalizedDescriptionKey: @"Failed to archiveRootObject:toFile"}];
    };
}

+ (instancetype)lin_restoreFromFile:(NSString *)file error:(NSError **)error {
    NSAssert([self conformsToProtocol:@protocol(NSCoding)], @"Object must implement NSCoding");
    
    id obj = nil;
    
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        
    } @catch (NSException *e) {
        *error = [NSError errorWithDomain:LINStorageErrorDomain
                                     code:LINStorageErrorUnarchiveObjectFailed
                                 userInfo:@{NSLocalizedDescriptionKey: e.description}];
    }
    
    if (![obj isKindOfClass:self]) {
        *error = [NSError errorWithDomain:LINStorageErrorDomain
                                     code:LINStorageErrorRestoreDifferentClass
                                 userInfo:@{NSLocalizedDescriptionKey: @"Restored object is not self class"}];
    }
    
    return obj;
}

#pragma mark - Blocks


- (void)lin_storeToFile:(NSString *)file
             onComplete:(void (^)(void))onComplete
                onError:(void (^)(NSError *error))onError {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        [self lin_storeToFile:file error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                if (onError) {
                    onError(error);
                }
            } else {
                if (onComplete) {
                    onComplete();
                }
            }
        });
    });
}

+ (void)lin_restoreFromFile:(NSString *)file
                 onComplete:(void (^)(id obj))onComplete
                    onError:(void (^)(NSError *error))onError {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        id obj = [self lin_restoreFromFile:file error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                if (onError) {
                    onError(error);
                }
            } else {
                if (onComplete) {
                    onComplete(obj);
                }
            }
        });
    });
}

@end
