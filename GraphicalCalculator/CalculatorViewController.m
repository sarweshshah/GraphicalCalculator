//
//  ViewController.m
//  RPNCalculator
//
//  Created by Sarwesh Shah (Intern) on 05/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphicalViewController.h"
#import "SplitViewBarButtonItemPresenter.h"
#import "GraphView.h"



@interface CalculatorViewController () <GraphViewDataSource>
@property (nonatomic,strong) CalculatorBrain *brain;
@property (atomic) BOOL userinthemiddleoftypinganumber;
@property (atomic) BOOL usertypeddecimalpoint;
- (double)getTopExpression:(NSMutableArray *)program forValue:(float)x;
@end




@implementation CalculatorViewController 

@synthesize description = _description;
@synthesize variableDisplay = _variableDisplay;
@synthesize display=_display;
@synthesize userinthemiddleoftypinganumber=_userinthemiddleoftypinganumber;
@synthesize brain=_brain;
@synthesize usertypeddecimalpoint=_usertypeddecimalpoint;

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButttonItemPresenter{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        return nil;
    }
    return detailVC; 
}

- (void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (BOOL) splitViewController:(UISplitViewController *)svc
    shouldHideViewController:(UIViewController *)vc
               inOrientation:(UIInterfaceOrientation)orientation{
    return [self splitViewBarButttonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void) splitViewController:(UISplitViewController *)svc
      willHideViewController:(UIViewController *)aViewController
           withBarButtonItem:(UIBarButtonItem *)barButtonItem
        forPopoverController:(UIPopoverController *)pc{
    barButtonItem.title = @"Calculator";
    //Done// tell the detail view to show the barButtonItem
    [self splitViewBarButttonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void) splitViewController:(UISplitViewController *)svc
      willShowViewController:(UIViewController *)aViewController
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    //tell the detail view to remove the barButtonItem
    [self splitViewBarButttonItemPresenter].splitViewBarButtonItem = nil;
}

-(CalculatorBrain *)brain{
    if (!_brain) {
        _brain=[[CalculatorBrain alloc]init];
    }
    return _brain;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"Graphify"]) {
            if (self.userinthemiddleoftypinganumber) [self enterPressed];
            GraphicalViewController *newController = segue.destinationViewController;
            [newController.view description];
            newController.graph.datasource = self;
    }
}

- (double)getTopExpression:(NSMutableArray *)program forValue:(float)x{
    id top = [program lastObject];
    if (top) [program removeLastObject];
    if ([top isKindOfClass:[NSNumber class]]) {
        return [top doubleValue];
    } else if ([top isKindOfClass:[NSString class]]) {
        if ([CalculatorBrain isOperation:top]) {
            if ([top isEqual:@"√x"]){
                double a = [self getTopExpression:program forValue:x];
                if (a>=0) return sqrt(a);
                else return 0.0;
            }
            else if ([top isEqual:@"cos"]){
                return cos([self getTopExpression:program forValue:x]);
            }
            else if ([top isEqual:@"sin"]){
                return sin([self getTopExpression:program forValue:x]);
            }
            else if ([top isEqual:@"tan"]){
                return tan([self getTopExpression:program forValue:x]);
            }
            else if ([top isEqual:@"+"]){
                double add=[self getTopExpression:program forValue:x];
                return (add + [self getTopExpression:program forValue:x]);
            }
            else if ([top isEqual:@"*"]){
                double mul=[self getTopExpression:program forValue:x];
                return ([self getTopExpression:program forValue:x]*mul);
            }
            else if ([top isEqual:@"/"]){
                double div=[self getTopExpression:program forValue:x];
                if (div) return ([self getTopExpression:program forValue:x]/div);
                else return 0.0;
            }
            else if ([top isEqual:@"-"]){
                double sub2=[self getTopExpression:program forValue:x];
                return ([self getTopExpression:program forValue:x]-sub2);
            }else{
                return M_PI;
            }
        }else return x;
    }else return 0.0;
}

- (NSNumber *)getFunctionValueForX:(float)x{
    NSMutableArray *program = [self.brain.stack mutableCopy];
    double result;
    if (program)
        result = [self getTopExpression:program forValue:x];
    else return nil;
    return [NSNumber numberWithDouble:result];
}

- (IBAction)digitPressed:(UIButton *)sender {
    if ([sender.currentTitle isEqual:@"0"] && ([self.display.text isEqual:@"0"] ||
                                               (self.userinthemiddleoftypinganumber==NO)));
    else{
    NSString *digit= sender.currentTitle;
    if (!self.userinthemiddleoftypinganumber)
    {
        self.display.text= digit;
        self.userinthemiddleoftypinganumber=YES;
    }else{
        self.display.text= [self.display.text stringByAppendingString:digit];
    }}
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userinthemiddleoftypinganumber=NO;
    self.usertypeddecimalpoint=NO;
}

- (IBAction)dotPressed {
    //if user first types a dot
    if (!self.userinthemiddleoftypinganumber) {
        self.display.text=[@"0" stringByAppendingString:@"."];
        self.userinthemiddleoftypinganumber=YES;
        self.usertypeddecimalpoint=YES;
    }
    //preventing user to type decimal 2 times in a number
    if (!self.usertypeddecimalpoint) {
        self.display.text=[self.display.text stringByAppendingString:@"."];
        self.usertypeddecimalpoint=YES;
    }
}

- (IBAction)allClearPressed {
    self.display.text = self.description.text = @"0";
    self.variableDisplay.text=@"nil";
    self.userinthemiddleoftypinganumber=NO;
    self.usertypeddecimalpoint=NO;
    [self.brain.stack removeAllObjects];
}

- (IBAction)clearPressed {
    self.display.text=@"0";
    self.userinthemiddleoftypinganumber=NO;
}

- (IBAction)undoPressed {
    //undo on 0 brings the previous result on display
    if ([self.display.text length] == 1){
        if ([self.display.text doubleValue]){
            self.display.text=@"0";
        }else{
            if([[self.brain.stack lastObject]isKindOfClass:[NSString class]]){
                self.display.text=[self.brain.stack lastObject];
            }
            else if ([[self.brain.stack lastObject]isKindOfClass:[NSNumber class]]){
                self.display.text=[NSString stringWithFormat:@"%g",[[self.brain.stack lastObject]doubleValue]];
            }
            [self.brain.stack removeLastObject];
            self.userinthemiddleoftypinganumber=NO;
        }
    }else{
        NSMutableString *undoText=[self.display.text mutableCopy];
        [undoText deleteCharactersInRange:NSMakeRange([undoText length]-1, 1)];
        self.display.text=undoText;
    }
    self.description.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)setPressed {
    NSNumber *number = [NSNumber numberWithDouble:[self.display.text doubleValue]];
    [self.brain.variableValues setValue:number forKey:@"x"];
}

- (IBAction)negpos {
    double neg = 0.0;
    if ([self.display.text doubleValue])
    neg=[self.display.text doubleValue]/-1;
    self.display.text=[NSString stringWithFormat:@"%g",neg];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userinthemiddleoftypinganumber){
        [self enterPressed];
    }
    self.userinthemiddleoftypinganumber=NO;
    self.display.text=[NSString stringWithFormat:@"%g",[self.brain performOperation:sender.currentTitle]];
}

- (IBAction)variablePressed:(UIButton *)sender{
    NSString *variabletext = sender.currentTitle;
    self.display.text=variabletext;
    [self.brain pushVariables:sender.currentTitle];
    self.userinthemiddleoftypinganumber=NO;
}

- (IBAction)testPressed:(UIButton *)sender{
    if ([sender.currentTitle isEqual:@"Test1"]) {
        NSMutableArray *a = [self.brain.stack mutableCopy];
        NSString *str = [CalculatorBrain descriptionOfProgram:a];
        for (;a.count > 0;) {
            str = [[CalculatorBrain descriptionOfProgram:a] stringByAppendingFormat:@", %@",str];
        }
        self.description.text = str;
    }
    else if ([sender.currentTitle isEqual:@"Test2"]){
        self.variableDisplay.text=@"nil";
        NSSet *set = [CalculatorBrain variablesUsedInProgram:self.brain.program];
        if ([set containsObject:@"x"]) {
            if ([self.variableDisplay.text isEqual:@"nil"]) {
                double x = [[self.brain.variableValues objectForKey:@"x"]doubleValue];
                self.variableDisplay.text = [NSString stringWithFormat:@"x=%g",x];
            }
        }
    }
}

@end