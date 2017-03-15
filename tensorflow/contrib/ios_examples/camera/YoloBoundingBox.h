// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by Nofar Noy.

#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define YOLO_NUMBER_OF_CLASSES 80

/// Yolo bounding box.
struct YoloRawBoundingBox {
  float centerX;
  float centerY;
  float width;
  float height;
  float probabilityScale;
  float probabitlty[YOLO_NUMBER_OF_CLASSES];
};

/// Immutable object for wrapping \c YoloRawBoundingBox.
@interface YoloBoundingBox : NSObject

/// Instantiates with \c rawBoundingBox.
- (instancetype)initWithRawBoundingBox:(const YoloRawBoundingBox *)rawBoundingBox
    NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// Returns the intersection of \c box with this instance.
- (float)intersectionWithBox:(YoloBoundingBox *)box;

/// Returns the union of \c box with this instance.
- (float)unionWithBox:(YoloBoundingBox *)box;

/// Returns the IOU of \c box with this instance.
- (float)IOUWithBox:(YoloBoundingBox *)box;

/// Box center x.
@property (readonly, nonatomic) float centerX;

/// Box center y.
@property (readonly, nonatomic) float centerY;

/// Box width.
@property (readonly, nonatomic) float width;

/// Box height.
@property (readonly, nonatomic) float height;

/// Box probability scale.
@property (readonly, nonatomic) float probabilityScale;

/// Class confidence probabilities above threshold.
@property (strong, nonatomic) NSMutableArray<NSNumber *> *classes;

@end

/// Immutable object that represents YOLO net single output.
@interface YoloSingleOutput : NSObject

/// Instantiates with \c boundingBox and \c classLabel.
- (instancetype)initWithBoundingBox:(YoloBoundingBox *)boundingBox
                         classLabel:(NSString *)classLabel;

/// YOLO bounding box.
@property (readonly, nonatomic) YoloBoundingBox *boundingBox;

/// Result class label.
@property (readonly, nonatomic) NSString *classLabel;

@end

NS_ASSUME_NONNULL_END
