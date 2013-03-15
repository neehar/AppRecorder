//
//  AppRecorder.h
//  AppRecorder
//
//  Created by Neehar Reddy on 3/15/13.
//  Copyright (c) 2013 Mansi Gandhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface AppRecorder : NSObject
{
    NSMutableArray *arrImages;
    NSTimer *timer;
}
- (void) start;
- (void) stop;
@end
