//
//  LINViewController.m
//  LINStorage
//
//  Created by ryohey on 02/17/2015.
//  Copyright (c) 2014 ryohey. All rights reserved.
//

#import "LINViewController.h"
#import <NSObject+LINStorage.h>

@interface LINViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LINViewController

- (NSString *)imagePath {
    return [NSString stringWithFormat:@"%@test.png", NSTemporaryDirectory()];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downloadAndSave];
    
    _imageView.image = [UIImage lin_restoreFromFile:[self imagePath] error:nil];
}

- (void)downloadAndSave {
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.shields.io/travis/ryohey/LINStorage.png?style=flat"]];
    UIImage *image = [UIImage imageWithData:imgData];
    [image lin_storeToFile:[self imagePath] error:nil];
}

@end
