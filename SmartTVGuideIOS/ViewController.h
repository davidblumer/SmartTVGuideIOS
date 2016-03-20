//
//  ViewController.h
//  SmartTVGuideIOS
//
//  Created by Thomas Kekeisen on 20/03/16.
//  Copyright © 2016 Socialbit GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SIOSocket/SIOSocket.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
{
    @private
        CGFloat                     currentPanX;
        CGFloat                     currentPanY;
        CGFloat                     startPanX;
        CGFloat                     startPanY;
        CGFloat                     lastScale;
        CGFloat                     startScale;
        CGFloat                     lastRotation;
        CGFloat                     lastX;
        CGFloat                     lastY;
        UIPanGestureRecognizer      *panGestureRecognizer;
        UIPinchGestureRecognizer    *pinchGestureRecognizer;
        UIRotationGestureRecognizer *rotationGestureRecognizer;
        SIOSocket                   *socketIO;
        NSTimer                     *updateTimer;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer;
- (void)initGestureRecognizers;
- (void)initSocket;
- (void)initVariables;
- (void)timerTick;

@end