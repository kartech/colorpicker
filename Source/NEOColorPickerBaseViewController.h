//
//  NEOColorPickerBaseViewController.h
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


@class NEOColorPickerBaseViewController;

@protocol NEOColorPickerViewControllerDelegate <NSObject>

@required
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color;
- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller;
@optional
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didChangeColor:(UIColor *)color;

@end


#define NEOColorPicker4InchDisplay()  [UIScreen mainScreen].bounds.size.height == 568


@interface NEOColorPickerFavoritesManager : NSObject

@property (readonly, nonatomic, strong) NSOrderedSet *favoriteColors;

+ (NEOColorPickerFavoritesManager *) instance;

- (void) addFavorite:(UIColor *)color;


@end


@interface NEOColorPickerBaseViewController : UIViewController

@property (nonatomic, weak) id <NEOColorPickerViewControllerDelegate> delegate;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) BOOL disallowOpacitySelection;
@property (nonatomic, strong) NSString* selectedColorText;

- (IBAction)buttonPressCancel:(id)sender;
- (IBAction)buttonPressDone:(id)sender;

- (void) setupShadow:(CALayer *)layer;
@end
