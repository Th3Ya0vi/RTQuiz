//
//  EndLevelVC.h
//  RTQuiz
//
//  Created by C. A. Beninati on 4/13/11.
//  Copyright (c) 2012 C. A. Beninati. All rights reserved.
//
//	This file is part of RTQuiz.
//
//	RTQuiz is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	RTQuiz is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser Public License for more details.
//
//	You should have received a copy of the GNU Lesser Public License
//	along with RTQuiz.  If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import "GamePlayDelegate.h"

@interface EndLevelVC : UIViewController <UITextFieldDelegate> {
    
@private
    SharedDataManager *sharedDataManager;
}

@property (strong) id<GamePlayDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel *totalPointsLabel;
@property (nonatomic, strong) IBOutlet UIButton *mainMenuButton;

@property (nonatomic) int score;
@property (nonatomic, strong) NSString *category;

- (void)setScoreLabel:(int)theScore;
- (IBAction)didClickMainMenu;

@end
