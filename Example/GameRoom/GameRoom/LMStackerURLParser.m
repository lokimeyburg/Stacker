//
//  URLParser.m
//  AlphaTouch
//
//  Created by Loki Meyburg on 2013-12-02.
//  Copyright (c) 2013 Loki Meyburg. All rights reserved.
//


// Example usage
// LMStackerURLParser *parser = [[[LMStackerURLParser alloc] initWithURLString:@"http://blahblahblah.com/serverCall?x=a&y=b&z=c&flash=yes"] autorelease];
// NSString *y = [parser valueForVariable:@"y"];
// NSLog(@"%@", y); //b
// NSString *a = [parser valueForVariable:@"a"];
// NSLog(@"%@", a); //(null)
// NSString *flash = [parser valueForVariable:@"flash"];
// NSLog(@"%@", flash); //yes

#import "LMStackerURLParser.h"

@implementation LMStackerURLParser
@synthesize variables;

- (id) initWithURLString:(NSString *)url{
    self = [super init];
    if (self != nil) {
        NSString *string = url;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempString;
        NSMutableArray *vars = [NSMutableArray new];
        //ignore the beginning of the string and skip to the vars
        [scanner scanUpToString:@"?" intoString:nil];
        while ([scanner scanUpToString:@"&" intoString:&tempString]) {
            [vars addObject:tempString];
        }
        variables = vars;
    }
    return self;
}

- (NSString *)valueForVariable:(NSString *)varName {
    for (NSString *var in variables) {
        if ([var length] > [varName length]+1 && [[var substringWithRange:NSMakeRange(0, [varName length]+1)] isEqualToString:[varName stringByAppendingString:@"="]]) {
            NSString *varValue = [var substringFromIndex:[varName length]+1];

            return varValue;
        }
    }
    return nil;
}

@end
