// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by Nofar Noy.

#import "YoloBoundingBox.h"

NS_ASSUME_NONNULL_BEGIN

@implementation YoloBoundingBox

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithRawBoundingBox:(const YoloRawBoundingBox *)rawBoundingBox{
  if ([super init]) {
    _centerX = rawBoundingBox->centerX;
    _centerY = rawBoundingBox->centerY;
    _width = rawBoundingBox->width;
    _height = rawBoundingBox->height;
    _probabilityScale = rawBoundingBox->probabilityScale;
    
    NSMutableArray<NSNumber *> *classes = [[NSMutableArray alloc] initWithCapacity:YOLO_NUMBER_OF_CLASSES];
    for (NSUInteger i = 0; i < YOLO_NUMBER_OF_CLASSES; i++) {
      [classes addObject:[[NSNumber alloc] initWithFloat:rawBoundingBox->probabitlty[i]]];
    }

    _classes = classes;
  }
  return self;
}

#pragma mark -
#pragma mark Public
#pragma mark -

- (float)intersectionWithBox:(YoloBoundingBox *)box {
  float width = [YoloBoundingBox calculateOverlapOfCenterX1:self.centerX
                                                      width1:self.width
                                                    centerX2:box.centerX
                                                      width2:box.width];
  float hight = [YoloBoundingBox calculateOverlapOfCenterX1:self.centerY
                                                     width1:self.height
                                                   centerX2:box.centerY
                                                     width2:box.height];
  if (width < 0 || hight < 0) {
    return 0;
  }
  
  return width * hight;
}

- (float)unionWithBox:(YoloBoundingBox *)box {
  float intersection = [self intersectionWithBox:box];
  return self.width * self.height + box.width * box.height - intersection;
}

- (float)IOUWithBox:(YoloBoundingBox *)box {
  return [self intersectionWithBox:box] / [self unionWithBox:box];
}

// One dimension overlap calculation.
+ (float)calculateOverlapOfCenterX1:(float)centerX1 width1:(float)width1 centerX2:(float)centerX2
                             width2:(float)width2 {
  float left1 = centerX1 - width1 / 2;
  float left2 = centerX2 - width2 / 2;
  float left = left1 > left2 ? left1 : left2;
  float right1 = centerX1 + width1 / 2;
  float right2 = centerX2 + width2 / 2;
  float right = right1 < right2 ? right1 : right2;
  return right - left;
}

@end

#pragma mark -
#pragma mark YoloSingleOutput
#pragma mark -

@implementation YoloSingleOutput

- (instancetype)initWithBoundingBox:(YoloBoundingBox *)boundingBox
                         classLabel:(NSString *)classLabel {
  if (self = [super init]) {
    _boundingBox = boundingBox;
    _classLabel = classLabel;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
