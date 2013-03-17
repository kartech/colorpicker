//
//  NEOColorPickerGradientView.m
//
//  Created by Karthik Abram on 10/10/12.
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


#import "NEOColorPickerGradientView.h"

#define CP_RESOURCE_GRADIENT_TRACKER                           @"colorPicker.bundle/color-picker-bar"


@interface NEOColorPickerGradientView()

@property (nonatomic, weak) UIImageView *selectorView;

@end

@implementation NEOColorPickerGradientView {
    CGGradientRef _gradient;
}

@synthesize value = _value;


- (void)awakeFromNib {
    [super awakeFromNib];
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOrTapValue:)];
    [self addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panOrTapValue:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}


- (void) reloadGradient {
	const CGFloat *c1 = CGColorGetComponents(self.color1.CGColor);
	const CGFloat *c2 = CGColorGetComponents(self.color2.CGColor);
    
	CGFloat colors[] = {
		c1[0], c1[1], c1[2], c1[3],
        c2[0], c2[1], c2[2], c2[3]
	};
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	
    if (_gradient != nil) {
        CGGradientRelease(_gradient);
    }
	_gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();		
	CGContextDrawLinearGradient(context, _gradient, CGPointZero, CGPointMake(rect.size.width, 0), 0);
}


- (void)setValue:(CGFloat)value {
    _value = value;
    if (!self.hidden) {
        if (!self.selectorView) {
            UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CP_RESOURCE_GRADIENT_TRACKER]];
            view.frame = CGRectMake(0, self.frame.origin.y, 14, 40);
            [self.superview addSubview:view];
            self.selectorView = view;
        }
        
        CGRect frame = self.selectorView.frame;
        frame.origin.x = value * (self.frame.size.width - 4) + self.frame.origin.x - 7 + 2; // + 2 for border
        self.selectorView.frame = frame;        
    }
}


- (void) panOrTapValue:(UIGestureRecognizer *) recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded: {
            CGPoint point = [recognizer locationInView:self];
            if (CGRectContainsPoint(self.bounds, point)) {
                CGFloat val = point.x / self.frame.size.width;
                self.value = val;
                [self.delegate colorPickerGradientView:self valueChanged:self.value];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        default: {
            // Canceled or error state.
            break;
        }
    }
}


@end
