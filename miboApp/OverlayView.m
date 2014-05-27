//
//  OverlayView.h
//  miboApp
//
//  Created by ahmet on 23.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import "OverlayView.h"

@interface OverlayView()

@property BOOL isRunning;

@end

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isRunning = FALSE;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        backgroundView.alpha = 0.3;
        backgroundView.backgroundColor = [UIColor blackColor];
        
        //takenPhotosLabel
        self.takenPhotosLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 60, 30)];
        self.takenPhotosLabel.backgroundColor = [UIColor blackColor];
        self.takenPhotosLabel.textAlignment = NSTextAlignmentCenter;
        self.takenPhotosLabel.textColor = [UIColor whiteColor];
        self.takenPhotosLabel.text = @"0";
        
        //precentageProgressLabel
        self.percentageProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 50, 30)];
        self.percentageProgressLabel.backgroundColor = [UIColor blackColor];
        self.percentageProgressLabel.textAlignment = NSTextAlignmentCenter;
        self.percentageProgressLabel.textColor = [UIColor whiteColor];
        self.percentageProgressLabel.text = @"00%";
        
        //timeRemainingLabel
        self.timeRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 20, 100, 30)];
        self.timeRemainingLabel.backgroundColor = [UIColor blackColor];
        self.timeRemainingLabel.textAlignment = NSTextAlignmentCenter;
        self.timeRemainingLabel.textColor = [UIColor whiteColor];
        self.timeRemainingLabel.text = @"00hr 00min";
        
        //startButton
        self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(235, 20, 70, 30)];
        self.startButton.backgroundColor = [UIColor blackColor];
        self.startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.startButton.titleLabel.textColor = [UIColor whiteColor];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        
        [self.startButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        [backgroundView addSubview:self.takenPhotosLabel];
        [backgroundView addSubview:self.percentageProgressLabel];
        [backgroundView addSubview:self.timeRemainingLabel];
        [backgroundView addSubview:self.startButton];
        
        
        [self addSubview:backgroundView];
    }
    
    return self;
}

- (void) buttonPressed {
    if (self.isRunning) {
        [self.owner stopPhotoTaking];
    } else {
        [self.owner startPhotoTaking];
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.isRunning = true;
    }
}

@end
