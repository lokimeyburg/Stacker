//
//  LMStackerCustomAction.h
//  Whistler
//
//  Created by Loki Meyburg on 2014-05-08.
//  Copyright (c) 2014 Loki Meyburg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMStackerCustomAction : NSObject

// Properties
@property NSObject *target;
@property NSObject *actionParameters;
@property SEL targetAction;

// Methods
- (void) addTarget:(NSObject*)targetOfAction action:(SEL)actionToPerform;
- (void) addTarget:(NSObject*)targetOfAction action:(SEL)actionToPerform withParameter:(NSObject*)params;
- (void) performAction;


@end