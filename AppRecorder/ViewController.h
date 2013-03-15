//
//  ViewController.h
//  AppRecorder
//
//  Created by Neehar Cherabuddi on 1/23/13.
//  Copyright (c) 2013 Neehar Cherabuddi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRecorder.h"

@interface ViewController : UIViewController
{
    AppRecorder *appRecorder;
    IBOutlet UILabel *labelStatus;
}
@end
