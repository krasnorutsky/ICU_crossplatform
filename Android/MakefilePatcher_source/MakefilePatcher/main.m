//
//  main.m
//  MakefilePatcher
//
//  Created by Mikhail Krasnorutsky on 1/06/2019.
//  Copyright © 2019 Mikhail Krasnorutskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* prependCompilerPath(NSString* line)
{
    NSUInteger r = [line rangeOfString:@"-clang"].location;
    
    if (r == NSNotFound)
    {
        return line;
    }
    
    NSString* abbr = [line substringToIndex:r];
    abbr = [abbr stringByReplacingOccurrencesOfString:@"i686" withString:@"x86"];
    
    return [NSString stringWithFormat:@"./../../%@/bin/%@", abbr, line];
}

NSArray* extractObjectFiles(NSString* line, NSString* path)
{
    NSMutableArray* objectFiles = [NSMutableArray new];
    
    for (NSString* s in [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])
    {
        if ([s hasSuffix:@".o"])
        {
            [objectFiles addObject:[path stringByAppendingPathComponent:s]];
        }
    }
    
    return objectFiles;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        //@"/Users/misha/Downloads/ios_ios/icu-ios/build-x86-linux-android/output.txt";
        NSString* outfileName = [NSString stringWithUTF8String:argv[1]];
        NSString* mfContent = [NSString stringWithContentsOfFile:outfileName encoding:NSUTF8StringEncoding error:nil];
        
        NSString* icuUcLine = nil;
        NSString* icuI18nLine = nil;
        
        for (NSString* s in [mfContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
        {
            if ([s containsString:@"clang++"])
            {
                if ([s containsString:@"libicuuc.so"])
                {
                    icuUcLine = s;
                    
                    NSLog(@"icu uc lib linking command found: %@",s);
                }
                else if ([s containsString:@"libicui18n.so"])
                {
                    icuI18nLine = s;
                    
                    NSLog(@"icu i18n lib linking command found: %@",s);
                }
            }
        }
        
        if (!icuUcLine ||
            !icuI18nLine)
        {
            return 1;
        }
        
        NSUInteger r = [icuUcLine rangeOfString:@".o " options:NSBackwardsSearch].location;
        
        if (r == NSNotFound)
        {
            return 2;
        }
        
        r += @".o ".length;
        
        NSArray* newObjects = extractObjectFiles(icuI18nLine, @"./../i18n");
        
        if (!newObjects.count)
        {
            return 3;
        }
        
        NSString* toBeInserted = [[newObjects componentsJoinedByString:@" "]stringByAppendingString:@" "];
        icuUcLine = [icuUcLine stringByReplacingCharactersInRange:NSMakeRange(r, 0) withString:toBeInserted];
        icuUcLine = [icuUcLine stringByReplacingOccurrencesOfString:@"libicuuc" withString:@"libicu"];
        icuUcLine = [icuUcLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        icuUcLine = prependCompilerPath(icuUcLine);
        
        icuUcLine = [@"cd \"$( dirname \"${BASH_SOURCE[0]}\" )\"\nmkdir lib\ncd common\n" stringByAppendingString:icuUcLine];
        
        NSString* fName = [[outfileName stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"build_libicu.sh"];
        if (![icuUcLine writeToFile:fName atomically:YES encoding:NSUTF8StringEncoding error:nil])
        {
            return 4;
        }
        
        return 0;
    }
}
