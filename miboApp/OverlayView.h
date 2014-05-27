//
//  OverlayView.h
//  miboApp
//
//  Created by ahmet on 23.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLapseCamera.h"

@interface OverlayView : UIView

@property (nonatomic, strong) TimeLapseCamera *owner;

@property (nonatomic, strong) UILabel *takenPhotosLabel;
@property (nonatomic, strong) UILabel *percentageProgressLabel;
@property (nonatomic, strong) UILabel *timeRemainingLabel;

@property (nonatomic, strong) UIButton *startButton;



@end
