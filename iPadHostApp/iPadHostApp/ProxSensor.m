//
//  ProxSensor.m
//  iPadHostApp
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 Nikos Mouchtaris. All rights reserved.
//
#import "ProxSensor.h"



@implementation ProxSensor : NSObject

- (void) someMethod {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateMonitor:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}


- (void)sensorStateMonitor:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user.");
        self.close = true;
    }
    
    else
    {
        NSLog(@"Device is not closer to user.");
        self.close = false;
    }
}

@end
