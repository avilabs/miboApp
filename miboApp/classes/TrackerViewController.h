//
//  TrackerViewController.h
//  miboApp
//
//  Created by ahmet on 25.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/ios.h>

@interface TrackerViewController : UIViewController<CvVideoCameraDelegate,UIGestureRecognizerDelegate>
{
    CvVideoCamera* videoCamera;
    BOOL isCapturing;
    
    BOOL isFocusLocked, isExposureLocked, isBalanceLocked;
}

@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* startCaptureButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* stopCaptureButton;

@property (nonatomic, weak) IBOutlet
UIBarButtonItem* lockFocusButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* lockExposureButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* lockBalanceButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* rotationButton;

-(IBAction)startCaptureButtonPressed:(id)sender;
-(IBAction)stopCaptureButtonPressed:(id)sender;

- (IBAction)actionLockFocus:(id)sender;
- (IBAction)actionLockExposure:(id)sender;
- (IBAction)actionLockBalance:(id)sender;
- (IBAction)pinchDetected:(UIPinchGestureRecognizer *)sender;
- (IBAction)rotationButtonPressed:(id)sender;
- (IBAction)takePhoto:(id)sender;
@end
