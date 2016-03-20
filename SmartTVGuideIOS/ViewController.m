//
//  ViewController.m
//  SmartTVGuideIOS
//
//  Created by Thomas Kekeisen on 20/03/16.
//  Copyright © 2016 Socialbit GmbH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        startPanX = lastX;
        startPanY = lastY;
    }
    else
    {
        currentPanX = translation.x;
        currentPanY = translation.y;
        
        lastX = startPanX + currentPanX;
        lastY = startPanY + currentPanY;
        
    }
    
    
    NSLog(@"Pan gesture: %.2f/%.2f", lastX, lastY);
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        startScale = recognizer.scale;
    }
    else
    {
        
        lastScale = startScale + recognizer.scale;
        
    }
    
     NSLog(@"Pinch gesture: %.2f", lastScale);
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    // NSLog(@"Rotation gesture: %@", recognizer);
    
    CGFloat recognizerRotation = [recognizer rotation];
    lastRotation += recognizerRotation;
    
    // SIOParameterArray *test = @[ @{ @"r": [NSNumber numberWithFloat:lastRotation] } ];
    
    // [socketIO emit:@"beard_set_rotation" args:test];
}

- (void)initGestureRecognizers
{
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
    
    pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    
    
    
    rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotationGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:rotationGestureRecognizer];
    
    
}

- (void)initSocket
{
   
    [SIOSocket socketWithHost:@"http://3b4fbd96.ngrok.com?query=test" response:^(SIOSocket *socket)
    {
        socketIO = socket;
        
        NSLog(@"Socket created: %@", socketIO);
        
        socketIO.onConnect = ^ () {
            NSLog(@"connected");
        };
        
        socketIO.onDisconnect = ^ () {
            NSLog(@"disconnected");
        };
        
        socketIO.onError = ^(NSDictionary* error) {
            NSLog(@"%@", error);
        };

        
        
        [socketIO emit:@"beard_show"];
    }];
}

- (void)initVariables
{
    lastRotation = 0.0f;
    lastScale    = 1.0f;
    lastX        = 300.f;
    lastY        = 120.f;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)timerTick
{
    float lastXInPercent = lastX / self.view.frame.size.width * 100.0f;
    float lastYInPercent = lastY / self.view.frame.size.height * 100.0f;
    
    SIOParameterArray *data = @[ @{
                                     @"r": [NSNumber numberWithFloat:lastRotation],
                                     @"z": [NSNumber numberWithFloat:lastScale],
                                     @"x": [NSNumber numberWithFloat:lastX],
                                     @"y": [NSNumber numberWithFloat:lastY]
                                     } ];
    
    [socketIO emit:@"beard_update" args:data];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Initializing");

    [self initGestureRecognizers];
    [self initSocket];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end