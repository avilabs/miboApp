//
//  TimeLapseViewController.m
//  miboApp
//
//  Created by ahmet on 25.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import "TimeLapseViewController.h"
#import "TimeLapseCamera.h"
@interface TimeLapseViewController ()
@property (nonatomic, strong) TimeLapseCamera *camera;

@property (weak, nonatomic) IBOutlet UILabel *photoDelayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPicturesLabel;
@property (weak, nonatomic) IBOutlet UILabel *playbackTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *compressionLabel;


@property (weak, nonatomic) IBOutlet UISlider *photoDelaySlider;
@property (weak, nonatomic) IBOutlet UISlider *totalTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider *compressionSlider;

@property (nonatomic, strong) NSString *currentFolderName;
@end

@implementation TimeLapseViewController

//===========================
// View Controller Lifecycle
//===========================
- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.camera = [[TimeLapseCamera alloc] init];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateLabels];
}

//===========================
// Target-Action Methods
//===========================
//Called whenever the value on the photoDelaySlider is changed.
- (IBAction)photoDelaySlider:(id)sender {
    self.camera.photoFrequency = (NSInteger)self.photoDelaySlider.value;
    [self updateLabels];
}


//Called whenever the value on the totalTimeSlider is changed.
- (IBAction)totalTimeSlider:(id)sender {
    self.camera.totalTime = ((NSInteger)self.totalTimeSlider.value) * 5;
    [self updateLabels];
}

//Called whenever the value on compressionSlider is changed.
- (IBAction)compressionSlider:(id)sender {
    self.camera.compression = self.compressionSlider.value;
    [self updateLabels];
}


//===========================
// Helper Methods
//===========================
/*Recalculates all of the parameters required to complete the time lapse, and updates
 *their values that are currently on screen.*/
- (void) updateLabels {
    //Photo Frequency
    NSString *timeLabelText = [NSString stringWithFormat:@"%d sec", self.camera.photoFrequency];
    [self.photoDelayTimeLabel setText:timeLabelText];
    
    //Total Time
    [self.totalTimeLabel setText: [self.camera totalTimeString]];
    
    //Total Photos
    [self.totalPicturesLabel setText:[NSString stringWithFormat:@"%d", self.camera.totalPhotos]];
    
    //Playback Time
    [self.playbackTimeLabel setText:[self.camera playbackTimeString]];
    
    //Compression
    [self.compressionLabel setText:[NSString stringWithFormat:@"%f", self.camera.compression]];
}


- (IBAction)openCamera:(id)sender {
    self.currentFolderName = [self getDateStringFromDate:[NSDate date]];
    NSString *newFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", self.currentFolderName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:newFolderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:newFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    self.camera.delegate = self;
    [self.camera openCamera];
}


- (NSString *) getDateStringFromDate:(NSDate *)date {
    //Get the current date as an NSDate and NSString objects. Date will be stored with no locale.
    NSDate *saveDate = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0]]; //Avoids potential conflicts when changing time zones.
    return [dateFormatter stringFromDate:saveDate];
}


//================================
// UIImagePickerControllerDelegate
//================================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //Save the photo to the disk in another thread
    dispatch_queue_t saveQ = dispatch_queue_create("Save Queue", NULL);
    dispatch_async(saveQ, ^{
        //Get the path that the image will be saved at
        NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.jpg", self.currentFolderName, [NSString stringWithFormat:@"%d", self.camera.takenPhotos]]];
        
        //Conver the image to a JPEG and save it to a file
        NSData *imageData = UIImageJPEGRepresentation(image, self.camera.compression);
        [imageData writeToFile:imagePath atomically:YES];
    });
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
