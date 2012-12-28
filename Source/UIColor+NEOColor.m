//
//  UIColor+NEOColor.m
//
//  Created by Karthik Abram on 9/21/12.
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


#import "UIColor+NEOColor.h"

@implementation UIColor (NEOColor)


+ (UIColor *) neoRandomColor {
    return [UIColor colorWithRed:(random()%100)/(float)100 green:(random()%100)/(float)100 blue:(random()%100)/(float)100 alpha:1];
}


- (CGFloat) neoLuminosity {
    BOOL compatible;
    CGFloat r, g, b, a, w, h, s, l;
    
    compatible = [self getWhite:&w alpha:&a];
    if (compatible) {
        return w;
    } else {
        compatible = [self getRed:&r green:&g blue:&b alpha:&a];
        if (compatible) {
            return 0.2125 * r + 0.7154 * g + 0.07210 * b;
        } else {
            [self getHue:&h saturation:&s brightness:&l alpha:&a];
            return l;
        }
    }
}


- (UIColor *) neoToHSL {
    CGFloat h, s, l, w, a;
    if ([self getHue:&h saturation:&s brightness:&l alpha:&a]) {
        return self;
    } else if ([self getWhite:&w alpha:&a]) {
        return [UIColor colorWithHue:0 saturation:0 brightness:w alpha:a];
    } else {
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b alpha:&a];
        CGFloat min, max, delta;
        min = MIN(MIN(r, g), b);
        max = MAX(MAX(r, g), b);
        delta = max - min;
        l = (max + min) / 2;
        if (delta == 0) {
            h = 0;
            s = 0;
        } else {
            if (l < 0.5 ) {
                s = max / ( max + min );
            } else {
                s = max / ( 2 - max - min );
            }
            
            CGFloat dR, dG, dB;
            
            dR = (((max - r) / 6.0) + (max / 2)) / max;
            dG = (((max - g) / 6) + (max / 2)) / max;
            dB = (((max - b) / 6) + (max / 2)) / max;

            if (r == max) {
                h = dB - dG;
            } else if (g == max) {
                h = 1/3 + dR - dB;
            } else if (b == max) {
                h = 2/3 + dG - dR;
            }
            
            if (h < 0) h += 1;
            if (h > 1) h -= 1;
        }
        return [UIColor colorWithHue:h saturation:s brightness:l alpha:a];
    }
}


- (UIColor *)neoComplementary {
    UIColor *hsl = [self neoToHSL];
    CGFloat h, s, l, a;
    if (![hsl getHue:&h saturation:&s brightness:&l alpha:&a]) {
        return nil;
    } else {
        h += 0.5;
        if (h > 1) {
            h -= 1;
        }
        l = 1.0 - l;
        return [UIColor colorWithHue:h saturation:s brightness:l alpha:a];
    }
}


- (UIColor *)neoContrastingBW {
    CGFloat luminosity = [self neoLuminosity];
    return luminosity < 0.5 ? [UIColor whiteColor] : [UIColor blackColor];
}


- (CGFloat) neoAlpha {
    CGFloat r, g, b, a, w, h, s, l;
    
    BOOL compatible = [self getWhite:&w alpha:&a];
    if (compatible) {
        return a;
    } else {
        compatible = [self getRed:&r green:&g blue:&b alpha:&a];
        if (compatible) {
            return a;
        } else {
            [self getHue:&h saturation:&s brightness:&l alpha:&a];
            return a;
        }
    }
}


- (UIColor *) neoColorWithAlpha:(CGFloat) alpha {
    CGFloat r, g, b, a, w, h, s, l;
    
    BOOL compatible = [self getWhite:&w alpha:&a];
    if (compatible) {
        return [UIColor colorWithWhite:w alpha:alpha];
    } else {
        compatible = [self getRed:&r green:&g blue:&b alpha:&a];
        if (compatible) {
            return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
        } else {
            [self getHue:&h saturation:&s brightness:&l alpha:&a];
            return [UIColor colorWithHue:h saturation:s brightness:l alpha:alpha];
        }
    }
}


- (BOOL) neoIsEqual:(UIColor *)color {
    if (color == nil) {
        return NO;
    } else {
        UIColor *a = [self neoToHSL];
        UIColor *b = [color neoToHSL];
        CGFloat h1, s1, l1, h2, s2, l2;
        CGFloat a1, a2;
        [a getHue:&h1 saturation:&s1 brightness:&l1 alpha:&a1];
        [b getHue:&h2 saturation:&s2 brightness:&l2 alpha:&a2];
        return (h1 == h2 && s1 == s2 && l1 == l2 && a1 == a2);
    }
}
@end
