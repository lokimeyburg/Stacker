//
//  LMRGBParser.h
//  AlphaTouch
//
//  Created by Loki Meyburg on 2013-12-05.
//  Copyright (c) 2013 Loki Meyburg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMRGBParser : NSObject

- (UIColor*)colorWithHexString:(NSString*)hex;

@end
