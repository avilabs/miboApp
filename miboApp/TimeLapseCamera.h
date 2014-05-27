//
//  TimeLapseCamera.h
//  miboApp
//
//  Created by ahmet on 23.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeLapseViewController.h"

@interface TimeLapseCamera : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> *delegate;

@property (nonatomic) NSInteger photoFrequency;
@property (nonatomic) NSInteger totalTime;
@property (nonatomic) float compression;

@property (nonatomic, readonly) NSInteger totalPhotos;
@property (nonatomic, readonly) NSInteger playbackTime;
@property (nonatomic, readonly) NSInteger takenPhotos;
@property (nonatomic, readonly) NSInteger timeRemaning;

@property (nonatomic, readonly) NSString *totalTimeString;
@property (nonatomic, readonly) NSString *playbackTimeString;
@property (nonatomic, readonly) NSString *timeRemainingString;

- (void) openCamera;
- (void) startPhotoTaking;
- (void) stopPhotoTaking;

@end
