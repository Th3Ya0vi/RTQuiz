//
//  GamePlayController.h
//  RTQuiz
//
//  Created by C. A. Beninati on 2/15/12.
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

#import <Foundation/Foundation.h>
#import "GamePlayDelegate.h"

@class QuizElement;

@interface GamePlayController : NSObject {
    
@private
    SharedDataManager *sharedDataManager;
}

@property (unsafe_unretained) id<GamePlayDelegate> currentGameScene;

@property (nonatomic) int errorCount;

@property (nonatomic) int currentWordInt;
@property (nonatomic, strong) QuizElement *currentWord;

@property (nonatomic) int currentPoints;
@property (nonatomic) int totalPoints;

@property (nonatomic, copy) NSArray *currentTopicLevelsList;
@property (nonatomic, strong) NSString *currentTopic;
@property (nonatomic) int currentLevel;
@property (nonatomic, copy) NSMutableArray *currentQuiz;

@property (strong, nonatomic) NSTimer *theTimer;
@property (nonatomic) float timeLeft;

- (void)initializeTimer;
- (void)incrementTimer;
- (void)reduceTimerIndicator;
- (void)killTimer;

- (void)setNewCurrentWord;
- (void)checkWordForTag:(int)tag;

- (void)newGame;
- (void)startGame;
- (void)endLevel;
- (void)endGame;
- (void)resetGame;

- (int)calculateBonusPoints;

+ (GamePlayController *)sharedGamePlayController;

@end
