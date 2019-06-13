//
//  main.m
//  CreateJoinedLib
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
        return nil;
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
        NSString* outfileName = nil;//@"/Users/misha/Downloads/ios_ios/icu-ios/build-x86-linux-android/output.txt";
        
        if (argc < 2 ||
            !argv[1] ||
            !(outfileName = [NSString stringWithUTF8String:argv[1]]))
        {
            NSLog(@"Usage: CreateJoinedLib path_to_output.txt");
            
            return 1;
        }
        
        NSLog(@"CreateJoinedLib utility will now insert ELF object files from i18n library into the existing libicuuc.so linking command. So we want to generate a script to create a new shared library libicu.so, which is, in fact, just a sum of libicuuc.so and libicui18n.so .");
        
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
        
        if (!icuUcLine)
        {
            NSLog(@"Error: icu uc lib linking command not found.");
            
            return 2;
        }
        
        if (!icuI18nLine)
        {
            NSLog(@"Error: icu i18n lib linking command found.");
            
            return 3;
        }
        
        NSUInteger r = [icuUcLine rangeOfString:@".o " options:NSBackwardsSearch].location;
        
        if (r == NSNotFound)
        {
            NSLog(@"Error: no object files (*.o) found in the icu uc lib linking command");
            
            return 4;
        }
        
        r += @".o ".length;
        
        NSLog(@"Insertion position found in the icu uc lib linking command:\n%@", [icuUcLine stringByReplacingCharactersInRange:NSMakeRange(r, 0) withString:@"<<<< i18n object files will be inserted here >>>>"]);
        
        NSArray* newObjects = extractObjectFiles(icuI18nLine, @"./../i18n");
        if (!newObjects.count)
        {
            NSLog(@"Error: no object files (*.o) found in the icu i18n lib linking command");
            
            return 5;
        }

        NSLog(@"%d files will be inserted: %@", (int)newObjects.count, [newObjects componentsJoinedByString:@" "]);
        
        NSString* toBeInserted = [[newObjects componentsJoinedByString:@" "]stringByAppendingString:@" "];
        icuUcLine = [icuUcLine stringByReplacingCharactersInRange:NSMakeRange(r, 0) withString:toBeInserted];
        icuUcLine = [icuUcLine stringByReplacingOccurrencesOfString:@"libicuuc" withString:@"libicu"];
        icuUcLine = [icuUcLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        icuUcLine = prependCompilerPath(icuUcLine);
        if (!icuUcLine)
        {
            NSLog(@"Error: can`t find clang compiler call in the icu uc lib linking command.");
            
            return 6;
        }
        
        icuUcLine = [@"cd \"$( dirname \"${BASH_SOURCE[0]}\" )\"\nmkdir lib\ncd common\n" stringByAppendingString:icuUcLine];
        
        NSString* fName = [[outfileName stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"build_libicu.sh"];
        if (![icuUcLine writeToFile:fName atomically:YES encoding:NSUTF8StringEncoding error:nil])
        {
            NSLog(@"Error: can`t save the libicu.so build script to \"%@\"", fName);
            
            return 7;
        }
        
        NSLog(@"Success.");
        
        return 0;
    }
}
