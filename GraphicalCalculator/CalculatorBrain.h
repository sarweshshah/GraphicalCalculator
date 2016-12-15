//
//  CalculatorBrain.h
//  RPNCalculator
//
//  Created by Sarwesh Shah (Intern) on 05/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSMutableDictionary *variableValues;
@property (readonly) id program;


-(void)pushOperand: (double)anOperand;
-(void)pushVariables: (NSString *)aVariable;
-(double)performOperation: (NSString *)operation;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL)isOperation:(NSString *)operation;

@end
