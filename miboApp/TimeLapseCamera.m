//
//  TimeLapseCamera.h
//  miboApp
//
//  Created by ahmet on 23.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import "TimeLapseCamera.h"
#import "OverlayView.h"

@interface TimeLapseCamera()

@property (nonatomic, readwrite) NSInteger totalPhotos;
@property (nonatomic, readwrite) NSInteger playbackTime;
@property (nonatomic, readwrite) NSInteger takenPhotos;
@property (nonatomic, readwrite) NSInteger timeRemaning;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) OverlayView *overlayView;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic, strong) NSMutableArray *capturedImages;

@end

@implementation TimeLapseCamera

- (TimeLapseCamera *) init {
    self = [super init];
    
    if (self) {
        self.photoFrequency = 1;
        self.totalTime = 5;
        self.compression = 1;
    }
    
    return self;
}

//========================
// Getters and Setters
//========================
- (void) setPhotoFrequency:(NSInteger)photoFrequency {
    _photoFrequency = photoFrequency;
    [self recalculateDerivedProperties];
}

- (void) setTotalTime:(NSInteger)totalTime {
    _totalTime = totalTime;
    [self recalculateDerivedProperties];
}

- (void) setCompression:(float)compression {
    _compression = compression;
    [self recalculateDerivedProperties];
}

- (NSString *) totalTimeString {
    return [self formattedMinutes: self.totalTime];
}

- (NSString *)playbackTimeString {
    return [self formattedSeconds: self.playbackTime];
}

- (NSString *)timeRemainingString {
    return [self formattedMinutes: self.timeRemaning];
}


//========================
// Public Methods
//========================
- (void) openCamera {
    UIImagePickerController *imagePickerControler = [[UIImagePickerController alloc] init];
    imagePickerControler.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerControler.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerControler.showsCameraControls = NO;
    imagePickerControler.delegate = self.delegate;
    
    self.overlayView = [[OverlayView alloc] initWithFrame:imagePickerControler.cameraOverlayView.frame];
    self.overlayView.owner = self;
    
    imagePickerControler.cameraOverlayView = self.overlayView;
    
    self.imagePickerController = imagePickerControler;
    [self.delegate presentViewController:self.imagePickerController animated:YES completion:nil];
}


- (void) startPhotoTaking {
    //Start the timer
    self.cameraTimer = [NSTimer scheduledTimerWithTimeInterval:self.photoFrequency target:self selector:@selector(takePhoto) userInfo:nil repeats:YES];
}


- (void) stopPhotoTaking {
    [self.cameraTimer invalidate];
    self.takenPhotos = 0;
    
    [self.delegate dismissViewControllerAnimated:YES completion:NULL];
}


//========================
// Helper Methods
//========================
- (void) recalculateDerivedProperties {
    self.totalPhotos = (self.totalTime * 60) / self.photoFrequency;
    self.playbackTime = (self.totalPhotos / 25);
    self.timeRemaning = self.totalTime;
}


- (NSString *) formattedMinutes:(NSInteger)minutes {
    NSString *output = @"";
    
    if (minutes / 60) {
        output = [NSString stringWithFormat:@"%d hrs ", (NSInteger)(minutes / 60)];
    }
    
    if (minutes % 60) {
        output = [output stringByAppendingString:[NSString stringWithFormat:@"%d min", minutes % 60]];
    }
    
    return output;
}


- (NSString *)formattedSeconds:(NSInteger)seconds {
    NSString *output = @"";
    
    if (seconds / 60) {
        output = [NSString stringWithFormat:@"%d min ", (NSInteger)(seconds / 60)];
    }
    
    if (seconds % 60) {
        output = [output stringByAppendingString:[NSString stringWithFormat:@"%d sec", seconds % 60]];
    }
    
    return output;
}


- (void) updateOverlayLabels {
    //Remaining Photos
    NSString *remainingPhotos = [NSString stringWithFormat:@"%d", self.totalPhotos - self.takenPhotos];
    [self.overlayView.takenPhotosLabel setText:remainingPhotos];
    
    //Percent
    NSInteger percentage = ((self.takenPhotos * 100) / self.totalPhotos);
    NSString *percentString = [NSString stringWithFormat:@"%d%%", percentage];
    [self.overlayView.percentageProgressLabel setText:percentString];
    
    //Time Remaining
    NSInteger timeRemaining = self.totalTime - ((self.takenPhotos * self.photoFrequency) / 60);
    [self.overlayView.timeRemainingLabel setText:[self formattedMinutes:timeRemaining]];
}


- (void) takePhoto {
    if (self.takenPhotos <= self.totalPhotos) {
        [self.imagePickerController takePicture];
        self.takenPhotos++;
        [self updateOverlayLabels];
    } else {
        [self stopPhotoTaking];
    }
}

@end
