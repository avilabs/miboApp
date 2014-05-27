//
//  PhotoViewController.m
//  miboApp
//
//  Created by ahmet on 27.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import "PhotoViewController.h"
#import "opencv2/highgui/ios.h"
@interface PhotoViewController ()

@end

@implementation PhotoViewController
@synthesize imageView;
@synthesize toolbar;
@synthesize photoCamera;
@synthesize takePhotoButton;
@synthesize startCaptureButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize camera
    photoCamera = [[CvPhotoCamera alloc]
                   initWithParentView:imageView];
    photoCamera.delegate = self;
    photoCamera.defaultAVCaptureDevicePosition =
    AVCaptureDevicePositionFront;
    photoCamera.defaultAVCaptureSessionPreset =
    AVCaptureSessionPresetPhoto;
    photoCamera.defaultAVCaptureVideoOrientation =
    AVCaptureVideoOrientationPortrait;
    
    // Load images
   // UIImage* resImage = [UIImage imageNamed:@"scratches.png"];
   // UIImageToMat(resImage, params.scratches);
    
    //resImage = [UIImage imageNamed:@"fuzzy_border.png"];
    //UIImageToMat(resImage, params.fuzzyBorder);
    
    [takePhotoButton setEnabled:NO];
}
- (IBAction)pinchDetected:(UIGestureRecognizer *)sender {
    
    CGFloat scale =
    [(UIPinchGestureRecognizer *)sender scale];
    CGFloat velocity =
    [(UIPinchGestureRecognizer *)sender velocity];
    
    NSString *resultString = [[NSString alloc] initWithFormat:
                              @"Pinch - scale = %f, velocity = %f",
                              scale, velocity];
   NSLog(@"asd");
}
- (NSInteger)supportedInterfaceOrientations
{
    // Only portrait orientation
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)takePhotoButtonPressed:(id)sender;
{
    [photoCamera takePicture];
}

-(IBAction)startCaptureButtonPressed:(id)sender;
{
    [photoCamera start];
    [self.view addSubview:imageView];
    [takePhotoButton setEnabled:YES];
    [startCaptureButton setEnabled:NO];
}

- (UIImage*)applyEffect:(UIImage*)image;
{
  //  cv::Mat frame;
    //UIImageToMat(image, frame);
    
  //  params.frameSize = frame.size();
  //  RetroFilter retroFilter(params);
    
    //cv::Mat finalFrame;
    //retroFilter.applyToPhoto(frame, finalFrame);
    
   // UIImage* result = MatToUIImage(finalFrame);
    //return [UIImage imageWithCGImage:[result CGImage] scale:1.0 orientation:UIImageOrientationLeftMirrored];
}

- (void)photoCamera:(CvPhotoCamera*)camera
      capturedImage:(UIImage *)image;
{
    [camera stop];
    resultView = [[UIImageView alloc]
                  initWithFrame:imageView.bounds];
    
   // UIImage* result = [self applyEffect:image];
    
    [resultView setImage:image];
    [self.view addSubview:resultView];
    
    [takePhotoButton setEnabled:NO];
    [startCaptureButton setEnabled:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)photoCameraCancel:(CvPhotoCamera*)camera;
{
}

- (void)viewDidDisappear:(BOOL)animated
{
    [photoCamera stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    photoCamera.delegate = nil;
}
@end
