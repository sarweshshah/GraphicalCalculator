//
//  ViewController.h
//  RPNCalculator
//
//  Created by Sarwesh Shah (Intern) on 05/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)dotPressed;
- (IBAction)allClearPressed;
- (IBAction)clearPressed;
- (IBAction)negpos;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)testPressed:(UIButton *)sender;
- (IBAction)undoPressed;
- (IBAction)setPressed;


@end
