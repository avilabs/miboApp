//
//  CameraViewController.m
//  miboApp
//
//  Created by ahmet on 24.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import "CameraViewController.h"
#import <mach/mach_time.h>
@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize imageView;
@synthesize startCaptureButton;
@synthesize toolbar;
@synthesize videoCamera;
@synthesize lockFocusButton;
@synthesize lockExposureButton;
@synthesize lockBalanceButton;
@synthesize rotationButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    videoCamera = [[CvVideoCamera alloc]
                   initWithParentView:imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition =
    AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset =
    AVCaptureSessionPreset640x480;
    videoCamera.defaultAVCaptureVideoOrientation =
    AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.recordVideo = YES;
    isCapturing = NO;
    
    [lockFocusButton setEnabled:NO];
    [lockExposureButton setEnabled:NO];
    [lockBalanceButton setEnabled:NO];
    
    isFocusLocked = NO;
    isExposureLocked = NO;
    isBalanceLocked = NO;
}

- (NSInteger)supportedInterfaceOrientations
{
    // Only portrait orientation
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)startCaptureButtonPressed:(id)sender
{
    [videoCamera start];
    isCapturing = YES;
    
    [lockFocusButton setEnabled:YES];
    [lockExposureButton setEnabled:YES];
    [lockBalanceButton setEnabled:YES];
}

-(IBAction)stopCaptureButtonPressed:(id)sender
{
    [videoCamera stop];
    isCapturing = NO;
    
    [lockFocusButton setEnabled:NO];
    [lockExposureButton setEnabled:NO];
    [lockBalanceButton setEnabled:NO];
   
    NSString* relativePath = [videoCamera.videoFileURL
                              relativePath];
    UISaveVideoAtPathToSavedPhotosAlbum(relativePath, nil, NULL,
                                        NULL);
    //Alert window
    UIAlertView *alert = [UIAlertView alloc];
    alert = [alert initWithTitle:@"Status"
                         message:@"Saved to the Gallery!"
                        delegate:nil
               cancelButtonTitle:@"Continue"
               otherButtonTitles:nil];
    [alert show];
    isCapturing = FALSE;
}
-(IBAction)takePhoto:(id)sender
{

}
- (IBAction)actionLockFocus:(id)sender
{
    if (isFocusLocked)
    {
        [self.videoCamera unlockFocus];
        [lockFocusButton setTitle:@"Lock focus"];
        isFocusLocked = NO;
    }
    else
    {
        [self.videoCamera lockFocus];
        [lockFocusButton setTitle:@"Unlock focus"];
        isFocusLocked = YES;
    }
}

- (IBAction)actionLockExposure:(id)sender
{
    if (isExposureLocked)
    {
        [self.videoCamera unlockExposure];
        [lockExposureButton setTitle:@"Lock exposure"];
        isExposureLocked = NO;
    }
    else
    {
        [self.videoCamera lockExposure];
        [lockExposureButton setTitle:@"Unlock exposure"];
        isExposureLocked = YES;
    }
}

- (IBAction)actionLockBalance:(id)sender
{
    if (isBalanceLocked)
    {
        [self.videoCamera unlockBalance];
        [lockBalanceButton setTitle:@"Lock balance"];
        isBalanceLocked = NO;
    }
    else
    {
        [self.videoCamera lockBalance];
        [lockBalanceButton setTitle:@"Unlock balance"];
        isBalanceLocked = YES;
    }
}


- (IBAction)rotationButtonPressed:(id)sender
{
    videoCamera.rotateVideo = !videoCamera.rotateVideo;
}
- (IBAction)pinchDetected:(UIGestureRecognizer *)sender {
    
    CGFloat scale =
    [(UIPinchGestureRecognizer *)sender scale];
    CGFloat velocity =
    [(UIPinchGestureRecognizer *)sender velocity];
    
    NSString *resultString = [[NSString alloc] initWithFormat:
                              @"Pinch - scale = %f, velocity = %f",
                              scale, velocity];
 NSLog(resultString);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)processImage:(cv::Mat&)image
{
    // Do some OpenCV processing with the image
}
static double machTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /
    (double)timebase.denom / 1e9;
}
// Macros for time measurements
#if 1
#define TS(name) int64 t_##name = cv::getTickCount()
#define TE(name) printf("TIMER_" #name ": %.2fms\n", \
1000.*((cv::getTickCount() - t_##name) / cv::getTickFrequency()))
#else
#define TS(name)
#define TE(name)
#endif
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isCapturing)
    {
        [videoCamera stop];
    }
}
static void resizeLock_(cv::Mat &img, int rows, int cols){
    cv::Size newSize;
    newSize.width = cols;
    newSize.height = rows;
    cv::resize(img, img, newSize,0, 0, CV_INTER_AREA);
}

static void zoom(cv::Mat &img, int ratio){
    cv::Size originalSize = img.size();
    resizeLock_(img,img.rows*ratio,img.cols*ratio);
    double c = ((double)ratio -1)/(double)2;
    img(cv::Rect(cvRound(originalSize.width*c),cvRound(originalSize.height*c),originalSize.width,originalSize.height)).copyTo(img);
}
- (void)dealloc
{
    videoCamera.delegate = nil;
}

@end
