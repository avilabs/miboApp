//
//  PhotoViewController.h
//  miboApp
//
//  Created by ahmet on 27.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/ios.h>

@interface PhotoViewController : UIViewController<CvPhotoCameraDelegate,UIGestureRecognizerDelegate>
{
    CvPhotoCamera* photoCamera;
    UIImageView* resultView;
   
}

@property (nonatomic, strong) CvPhotoCamera* photoCamera;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* takePhotoButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* startCaptureButton;

-(IBAction)takePhotoButtonPressed:(id)sender;
-(IBAction)startCaptureButtonPressed:(id)sender;
- (IBAction)pinchDetected:(UIPinchGestureRecognizer *)sender;
- (UIImage*)applyEffect:(UIImage*)image;

@end
