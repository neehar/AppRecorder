//
//  AppRecorder.m
//  AppRecorder
//
//  Created by Neehar Reddy on 3/15/13.
//  Copyright (c) 2013 Mansi Gandhi. All rights reserved.
//

#import "AppRecorder.h"

@interface AppRecorder ()
- (void) createMovie;
- (void) writeImagesAsMovie:(NSArray *)array toPath:(NSString*)path;
- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image;
@end

NSInteger sort(id a, id b, void *reverse) {
    return [a compare:b options:NSNumericSearch];
}

@implementation AppRecorder

- (id) init
{
    self = [super init];
    if (self) {
        arrImages = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void) dealloc
{
    [arrImages release];
    
    [super dealloc];
}

#pragma mark Public Methods

- (void) start
{
    if (!timer) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(nextFrame) userInfo:nil repeats:YES] retain];
    }
}

- (void) stop
{
    if (timer) {
        [timer invalidate];
        [timer release]; timer = nil;
        
        [self createMovie];
    }
}

#pragma mark Custom Methods
- (void) createMovie
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documents = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent:@""];
    [manager removeItemAtPath:[documents stringByAppendingPathComponent:@"movie.mov"] error:nil];
    [self writeImagesAsMovie:arrImages toPath:[documents stringByAppendingPathComponent:@"movie.mov"]];
    [pool release];
}

- (void) writeImagesAsMovie:(NSArray *)array toPath:(NSString*)path
{
    NSLog(@"Path - %@",path);
    NSError *error = nil;
    UIImage *first = [array objectAtIndex:0];
    CGSize imageSize = first.size;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
                                  [NSURL fileURLWithPath:path] fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:imageSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:imageSize.height], AVVideoHeightKey,
                                   nil];
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoSettings];
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                     sourcePixelBufferAttributes:nil];
    
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    
    //convert uiimage to CGImage.
    int frameCount = 0;
    NSUInteger fps = 24;
    
    NSLog(@"**************************************************");
    for(UIImage *img in array)
    {
        buffer = [self pixelBufferFromCGImage:[img CGImage]];
        
        BOOL append_ok = NO;
        int j = 0;
        while (!append_ok && j < 30) {
            if (adaptor.assetWriterInput.readyForMoreMediaData)  {
                //print out status:
                NSLog(@"Processing video frame (%d,%d)",frameCount,[array count]);
                
                CMTime frameTime = CMTimeMake(frameCount,(int32_t) fps);
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                if(!append_ok){
                    NSError *error = videoWriter.error;
                    if(error!=nil) {
                        NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
                    }
                }
            }
            else {
                printf("adaptor not ready %d, %d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok) {
            printf("error appending image %d times %d\n, with error.", frameCount, j);
        }
        frameCount++;
    }
    NSLog(@"**************************************************");
    
    //Finish the session:
    [videoWriterInput markAsFinished];
    [videoWriter finishWriting];
    NSLog(@"Movie created successfully");
    
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVPixelBufferCreate(kCFAllocatorDefault, CGImageGetWidth(image),
                        CGImageGetHeight(image), kCVPixelFormatType_32ARGB, (CFDictionaryRef) options,
                        &pxbuffer);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, CGImageGetWidth(image),
                                                 CGImageGetHeight(image), 8, 4*CGImageGetWidth(image), rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (UIImage*)getScreenshot
{
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width * [[window layer] anchorPoint].x, -[window bounds].size.height * [[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) nextFrame
{
    [arrImages addObject:[self getScreenshot]];
}

#pragma mark Video
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"Error saving to PhotoAlbum");
    }
    else {
        NSLog(@"Saved to PhotoAlbum");
    }
}

@end
