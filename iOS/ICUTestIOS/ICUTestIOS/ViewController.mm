//
//  ViewController.m
//  ICUTestIOS
//
//  Created by Mikhail Krasnorutsky on 16/06/2019.
//  Copyright © 2019 Mikhail Krasnorutskiy. All rights reserved.
//

#import "ViewController.h"
#include <string>
#include <vector>
#include <algorithm>
#include "StringCompare.hpp"

using namespace std;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vector<string> toSort;
    toSort.push_back(u8"Здравствуйте");
    toSort.push_back(u8"я");
    toSort.push_back(u8"ваша");
    toSort.push_back(u8"тётя");
    
    shared_ptr<StringCompare> comparator = StringCompare::create("ru");
    
    sort(toSort.begin(), toSort.end(), [&comparator](string& a, string& b)->bool
         {
             return comparator->compare(a,b);
         });
    
    string hello = "Sorted:";
    
    for (auto& s : toSort)
    {
        hello += " ";
        hello += s;
    }
    
    self.textView.text = [NSString stringWithUTF8String:hello.c_str()];
}


@end
