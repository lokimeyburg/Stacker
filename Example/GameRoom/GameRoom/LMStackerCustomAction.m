//
//  LMStackerCustomAction.m
//  Whistler
//
//  Created by Loki Meyburg on 2014-05-08.
//  Copyright (c) 2014 Loki Meyburg. All rights reserved.
//

#import "LMStackerCustomAction.h"

@implementation LMStackerCustomAction

- (void) addTarget:(NSObject*)targetOfAction action:(SEL)actionToPerform
{
    self.target = targetOfAction;
    self.targetAction = actionToPerform;
}

- (void) addTarget:(NSObject*)targetOfAction action:(SEL)actionToPerform withParameter:(NSObject*)params
{
    self.target = targetOfAction;
    self.targetAction = actionToPerform;
    self.actionParameters = params;
}


- (void) performAction
{
    //
    // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    //
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if(self.actionParameters != NULL) {
        [self.target performSelector:self.targetAction withObject:self.actionParameters];
    } else {
        [self.target performSelector:self.targetAction];
    }
    #pragma clang diagnostic pop
    
}



@end