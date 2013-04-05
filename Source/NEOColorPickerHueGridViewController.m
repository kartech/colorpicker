//
//  NEOColorPickerHueGridViewController.m
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


#import "NEOColorPickerHueGridViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface NEOColorPickerHueGridViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) CALayer *selectedColorLayer;
@property (nonatomic, strong) NSMutableArray *hueColors;

@end

@implementation NEOColorPickerHueGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hueColors = [NSMutableArray array];
        
        for (int i = 0 ; i < 12; i++) {
            CGFloat hue = i * 30 / 360.0;
            int colorCount = NEOColorPicker4InchDisplay() ? 32 : 24;
            for (int x = 0; x < colorCount; x++) {
                int row = x / 4;
                int column = x % 4;
                
                CGFloat saturation = column * 0.25 + 0.25;
                CGFloat luminosity = 1.0 - row * 0.12;
                UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:luminosity alpha:1.0];
                [self.hueColors addObject:color];
            }
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.selectedColorText.length != 0)
    {
        self.selectedColorLabel.text = self.selectedColorText;
    }
    
    CGRect frame = CGRectMake(130, 16, 100, 40);
    UIImageView *checkeredView = [[UIImageView alloc] initWithFrame:frame];
    checkeredView.layer.cornerRadius = 6.0;
    checkeredView.layer.masksToBounds = YES;
    checkeredView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorPicker.bundle/color-picker-checkered"]];
    [self.view addSubview:checkeredView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(130, 16, 100, 40);
    layer.cornerRadius = 6.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.8;
    
    [self.view.layer addSublayer:layer];
    self.selectedColorLayer = layer;
    self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
    
    int index = 0;
    for (int i = 0; i < 12; i++) {
        int colorCount = NEOColorPicker4InchDisplay() ? 32 : 24;
        for (int x = 0; x < colorCount && index < self.hueColors.count; x++) {
            CALayer *layer = [CALayer layer];
            layer.cornerRadius = 6.0;
            UIColor *color = [self.hueColors objectAtIndex:index++];
            layer.backgroundColor = color.CGColor;
            
            int column = x % 4;
            int row = x / 4;
            layer.frame = CGRectMake(i * 320 + 8 + (column * 78), 8 + row * 48, 70, 40);
            [self setupShadow:layer];
            [self.scrollView.layer addSublayer:layer];
        }
    }

    self.scrollView.contentSize = CGSizeMake(3840, 296);
    self.colorBar.image = [UIImage imageNamed:@"colorPicker.bundle/color-bar"];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.scrollView addGestureRecognizer:recognizer];
    
    self.colorBar.userInteractionEnabled = YES;
    UITapGestureRecognizer *barRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorBarTapped:)];
    [self.colorBar addGestureRecognizer:barRecognizer];
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setColorBar:nil];
    [super viewDidUnload];
}


- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.scrollView];
    int page = point.x / 320;
    int delta = (int)point.x % 320;
    
    int row = (int)((point.y - 8) / 48);
    int column = (int)((delta - 8) / 78);
    int colorCount = NEOColorPicker4InchDisplay() ? 32 : 24;
    int index = colorCount * page + row * 4 + column;
	if (index < self.hueColors.count) {
		self.selectedColor = [self.hueColors objectAtIndex:index];
		self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
		[self.selectedColorLayer setNeedsDisplay];

		if ([self.delegate respondsToSelector:@selector(colorPickerViewController:didChangeColor:)]) {
			[self.delegate colorPickerViewController:self didChangeColor:self.selectedColor];
		}
	}
}


- (void) colorBarTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.colorBar];
    int page = point.x / 25;
    [self.scrollView scrollRectToVisible:CGRectMake(page*320, 0, 320, self.scrollView.frame.size.height) animated:YES];
}

@end
