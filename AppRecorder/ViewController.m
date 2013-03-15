//
//  ViewController.m
//  AppRecorder
//
//  Created by Neehar Cherabuddi on 1/23/13.
//  Copyright (c) 2013 Neehar Cherabuddi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction) buttStartClicked:(id)sender;
- (IBAction) buttStopClicked:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appRecorder = [[AppRecorder alloc] init];
}

- (void) dealloc
{
    [appRecorder release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Actions
- (IBAction) buttStartClicked:(id)sender
{
    [appRecorder start];
    labelStatus.text = @"Recording started. Play with controls & hit stop.";
}

- (IBAction) buttStopClicked:(id)sender
{
    labelStatus.text = @"Saving";
    [appRecorder stop];
    labelStatus.text = @"Recording saved to the Photo Album on your iPhone";
}

@end
