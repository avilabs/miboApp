//
//  ImageCell.m
//  miboApp
//
//  Created by ahmet on 23.05.2014.
//  Copyright (c) 2014 ahmet. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()
@property(nonatomic, weak) IBOutlet UIImageView *imgImageView;
@end

@implementation ImageCell

- (void) setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.imgImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}

@end
