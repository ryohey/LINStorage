//
//  LINStorageError.h
//  Pods
//
//  Created by Ryohei Kameyama on 2015/02/17.
//
//

#import <Foundation/Foundation.h>

extern NSString *const LINStorageErrorDomain;

typedef NS_ENUM(NSUInteger, LINStorageErrorCode) {
    LINStorageErrorInvalid = 0,
    LINStorageErrorArchiveObjectFailed,
    LINStorageErrorUnarchiveObjectFailed,
    LINStorageErrorRestoreDifferentClass,
};
