//
//  NEOColorPickerBaseViewController.m
//
//  Created by Karthik Abram on 10/23/12.
//  Copyright (c) 2012 Neovera Inc.
//

/*
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
*/

#import "NEOColorPickerBaseViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation NEOColorPickerFavoritesManager {
    NSMutableOrderedSet *_favorites;
}

+ (NEOColorPickerFavoritesManager *) instance {
    static dispatch_once_t _singletonPredicate;
    static NEOColorPickerFavoritesManager *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    
    return _singleton;
}


- (id)init {
    if (self = [super init]) {

        NSFileManager *fs = [NSFileManager defaultManager];
        NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"neoFavoriteColors.data"];
        if ([fs isReadableFileAtPath:filename]) {
            _favorites = [[NSMutableOrderedSet alloc] initWithOrderedSet:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]];
        } else {
            _favorites = [[NSMutableOrderedSet alloc] init];            
        }
    }
    
    return self;
}


+ (id) allocWithZone:(NSZone *)zone {
    return [self instance];
}


- (void)addFavorite:(UIColor *)color {
    [_favorites addObject:color];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_favorites];
    NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"neoFavoriteColors.data"];
    [data writeToFile:filename atomically:YES];
}


- (NSOrderedSet *)favoriteColors {
    return _favorites;
}

@end


@interface NEOColorPickerBaseViewController ()

@end

@implementation NEOColorPickerBaseViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : UIInterfaceOrientationIsPortrait(interfaceOrientation));
}


- (NSUInteger)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait);
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonPressCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonPressDone:)];

    self.contentSizeForViewInPopover = CGSizeMake(320.0f, 460.0f);

    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (IBAction)buttonPressCancel:(id)sender {
    [self.delegate colorPickerViewControllerDidCancel:self];
}


- (IBAction)buttonPressDone:(id)sender {
    [self.delegate colorPickerViewController:self didSelectColor:self.selectedColor];
}



- (void) setupShadow:(CALayer *)layer {
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    layer.shadowOffset = CGSizeMake(0, 2);
    CGRect rect = layer.frame;
    rect.origin = CGPointZero;
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:layer.cornerRadius].CGPath;
}

@end
