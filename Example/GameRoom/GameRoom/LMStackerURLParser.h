//
//  URLParser.h
//  AlphaTouch
//
//  Created by Loki Meyburg on 2013-12-02.
//  Copyright (c) 2013 Loki Meyburg. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface LMStackerURLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end