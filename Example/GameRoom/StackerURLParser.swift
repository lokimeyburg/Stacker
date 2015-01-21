//
//  StackerURLParser.swift
//  GameRoom
//
//  Created by Loki Meyburg on 2015-01-20.
//  Copyright (c) 2015 Loki Meyburg. All rights reserved.
//

import Foundation

class StackerURLParser {
    
    var variables:[NSString] = [];
    
    convenience init(url: String) {
        self.init();
        var scanner = NSScanner(string: url);
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "&?");
        var tempString : NSString?
        var vars:[NSString] = [];
        //ignore the beginning of the string and skip to the vars
        scanner.scanUpToString("?", intoString: nil);
        while(scanner.scanUpToString("&", intoString: &tempString)){
            vars.append(tempString!);
        }
        variables = vars;
    }
    
    func valueForVariable(varName: NSString) -> NSString? {
        for variable in variables {
            if (variable.length > varName.length+1 && variable.substringWithRange(NSMakeRange(0, varName.length+1)) == varName.stringByAppendingString("=")) {
                var varValue = variable.substringFromIndex(varName.length+1);
                return varValue;
            }
        }
        var tempString : NSString?;
        return tempString;
    }
    
}