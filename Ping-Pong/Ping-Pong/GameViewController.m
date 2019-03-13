//
//  GameViewController
//  Ping-Pong
//
//  Created by Оксана Лобышева on 10/03/2019.
//  Copyright © 2019 Oxana Lobysheva. All rights reserved.
//

#import "GameViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HALF_SCREEN_WIDTH SCREEN_WIDTH/2
#define HALF_SCREEN_HEIGHT SCREEN_HEIGHT/2
#define MAX_SCORE 2
#define SCORE_SIZE 50
#define SCORE_OFFSET 70
#define PADDLE_OFFSET 40
#define PADDLE_HEIGHT 60
#define PADDLE_WIDTH  90
#define BALL_SIZE 20

@interface GameViewController ()

@property (strong, nonatomic) UIImageView *paddleTop;
@property (strong, nonatomic) UIImageView *paddleBottom;
@property (strong, nonatomic) UIView *gridView;
@property (strong, nonatomic) UIView *ball;
@property (strong, nonatomic) UITouch *topTouch;
@property (strong, nonatomic) UITouch *bottomTouch;
@property (strong, nonatomic) NSTimer * timer;
@property (nonatomic) float dx;
@property (nonatomic) float dy;
@property (nonatomic) float speed;
@property (strong, nonatomic) UILabel *scoreTop;
@property (strong, nonatomic) UILabel *scoreBottom;

@end

@implementation GameViewController

int level = 1;

- (void)configUI {
    
    [self configPlayground];
    [self configBall];

    [self configPaddleTop];
    [self configPaddleBottom];

    [self configScoreTop];
    [self configScoreBottom];

}

- (void)configPlayground {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:135.0/255.0 blue:191.0/255.0 alpha:1.0];
    self.gridView = [[UIView alloc] initWithFrame:CGRectMake(0, HALF_SCREEN_HEIGHT - 2, SCREEN_WIDTH, 4)];
    self.gridView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview: self.gridView];
}

- (void) configBall {
    self.ball = [[UIView alloc]
             initWithFrame:CGRectMake(
                                      self.view.center.x - BALL_SIZE/2,
                                      self.view.center.y - BALL_SIZE/2,
                                      BALL_SIZE,
                                      BALL_SIZE)];
    self.ball.backgroundColor = [UIColor whiteColor];
    self.ball.layer.cornerRadius = BALL_SIZE/2;
    self.ball.hidden = YES;
    [self.view addSubview:_ball];
}

- (void)configPaddleTop {
    self.paddleTop = [[UIImageView alloc]
                  initWithFrame:CGRectMake(
                                           PADDLE_OFFSET,
                                           PADDLE_OFFSET,
                                           PADDLE_WIDTH,
                                           PADDLE_HEIGHT
                                           )];
    self.paddleTop.image = [UIImage imageNamed: @"paddleBottom"];
    self.paddleTop.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview: self.paddleTop];
}

- (void)configPaddleBottom {
    self.paddleBottom = [[UIImageView alloc]
                 initWithFrame:CGRectMake(
                                          PADDLE_OFFSET,
                                          SCREEN_HEIGHT - PADDLE_WIDTH,
                                          PADDLE_WIDTH,
                                          PADDLE_HEIGHT
                                          )];
    self.paddleBottom.image = [UIImage imageNamed: @"paddleBottom"];
    self.paddleBottom.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview: self.paddleBottom];
}

- (void)configScoreTop {
    self.scoreTop = [[UILabel alloc]
                 initWithFrame:CGRectMake(
                                          SCREEN_WIDTH - SCORE_OFFSET,
                                          HALF_SCREEN_HEIGHT - SCORE_OFFSET,
                                          SCORE_SIZE,
                                          SCORE_SIZE
                                          )];
    self.scoreTop.textColor = [UIColor whiteColor];
    self.scoreTop.text = @"0";
    self.scoreTop.font = [UIFont systemFontOfSize: 40.0 weight:UIFontWeightLight];
    self.scoreTop.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: self.scoreTop];
}

- (void)configScoreBottom {
    self.scoreBottom = [[UILabel alloc]
             initWithFrame:CGRectMake(
                                      SCREEN_WIDTH - SCORE_OFFSET,
                                      HALF_SCREEN_HEIGHT + SCORE_OFFSET - SCORE_SIZE,
                                      SCORE_SIZE,
                                      SCORE_SIZE
                                      )];
    self.scoreBottom.textColor = [UIColor whiteColor];
    self.scoreBottom.text = @"0";
    self.scoreBottom.font = [UIFont systemFontOfSize: 40.0 weight:UIFontWeightLight];
    self.scoreBottom.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: self.scoreBottom];
}


# pragma mark - TOUCHES

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        //bottom player
        if (self.bottomTouch == nil && point.y > HALF_SCREEN_HEIGHT) {
            self.bottomTouch = touch;
            self.paddleBottom.center = CGPointMake(point.x, point.y);
        }
        //top player
        //else if (_topTouch == nil && point.y < HALF_SCREEN_HEIGHT) {
        //    self.topTouch = touch;
        //    self.paddleTop.center = CGPointMake(point.x, point.y);
        //}
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        if (touch == self.topTouch) {
            if (point.y > HALF_SCREEN_HEIGHT) {
                self.paddleTop.center = CGPointMake(point.x, HALF_SCREEN_HEIGHT);
                return;
            }
            self.paddleTop.center = point;
        }
        else if (touch == _bottomTouch) {
            if (point.y < HALF_SCREEN_HEIGHT) {
                self.paddleBottom.center = CGPointMake(point.x, HALF_SCREEN_HEIGHT);
                return;
            }
            self.paddleBottom.center = point;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch == _topTouch) {
            self.topTouch = nil;
        }
        else if (touch == _bottomTouch) {
            self.bottomTouch = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)displayMessage:(NSString *)message {
    [self stop];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ping Pong" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if ([self gameOver]) {
            [self newGame];
            return;
        }
        [self reset];
        [self start];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)newGame {
    [self reset];
    self.scoreTop.text = @"0";
    self.scoreBottom.text = @"0";
    NSString *nextLevel =  [@"LEVEL " stringByAppendingString: [NSString stringWithFormat: @"%d", level]] ;
    [self displayMessage: [nextLevel stringByAppendingString: @"\n\nAre you ready?"]];
}

- (int)gameOver {
    if ([self.scoreTop.text intValue] >= MAX_SCORE) {
        return 1;
    }
    if ([self.scoreBottom.text intValue] >= MAX_SCORE) {
        return 2;
    }
    return 0;
}

- (void)start {
    self.ball.center = CGPointMake(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT);
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    }
    self.ball.hidden = NO;
}

- (void)reset {
    if ((arc4random() % 2) == 0) {
        _dx = -1;
    } else {
        _dx = 1;
    }
    
    if (_dy != 0) {
        _dy = -_dy;
    } else if ((arc4random() % 2) == 0) {
        _dy = -1;
    } else  {
        _dy = 1;
    }
    
    self.ball.center = CGPointMake(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT);
    self.speed = 2;
}

- (void)stop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.ball.hidden = YES;
}

- (void)animate {
    self.ball.center = CGPointMake(self.ball.center.x + _dx*_speed, _ball.center.y + _dy*_speed);
    [self checkCollision:CGRectMake(0, 0, 20, SCREEN_HEIGHT) X:fabs(_dx) Y:0];
    [self checkCollision:CGRectMake(SCREEN_WIDTH, 0, 20, SCREEN_HEIGHT) X:-fabs(_dx) Y:0];
    if ([self checkCollision:_paddleTop.frame X:(self.ball.center.x - self.paddleTop.center.x) / 32.0 Y:1]) {
        [self increaseSpeed];
    }
    if ([self checkCollision:_paddleBottom.frame X:(self.ball.center.x - self.paddleBottom.center.x) / 32.0 Y:-1]) {
        [self increaseSpeed];
    }
    [self goal];
    [self aiPlayer];
}

- (void)increaseSpeed {
    self.speed += 0.5;
    if (self.speed > 10) self.speed = 10;
}

- (BOOL)checkCollision: (CGRect)rect X:(float)x Y:(float)y {
    if (CGRectIntersectsRect(self.ball.frame, rect)) {
        if (x != 0) _dx = x;
        if (y != 0) _dy = y;
        return YES;
    }
    return NO;
}

- (void)aiPlayer{
    
    // super player
    //_paddleTop.center = CGPointMake(self.ball.center.x, self.paddleTop.center.y);
    
    // ordinary player
    /*
    if (self.ball.center.y < SCREEN_HEIGHT/2) {
        if (self.ball.center.x > self.paddleTop.center.x){
            self.paddleTop.center = CGPointMake(self.paddleTop.center.x + arc4random_uniform(self.speed), self.paddleTop.center.y);
        } else {
            self.paddleTop.center = CGPointMake(self.paddleTop.center.x - arc4random_uniform(self.speed), self.paddleTop.center.y);
        }
    }
    */
    
    // level player
    if (self.ball.center.y < SCREEN_HEIGHT/2) {
        if (self.ball.center.x > self.paddleTop.center.x){
            self.paddleTop.center = CGPointMake(self.paddleTop.center.x + level, self.paddleTop.center.y);
        } else {
            self.paddleTop.center = CGPointMake(self.paddleTop.center.x - level, self.paddleTop.center.y);
        }
    }
    
}

- (BOOL)goal
{
    if (self.ball.center.y < 0 || self.ball.center.y >= SCREEN_HEIGHT) {
        int s1 = [self.scoreTop.text intValue];
        int s2 = [self.scoreBottom.text intValue];
        
        if (self.ball.center.y < 0) ++s2; else ++s1;
        self.scoreTop.text = [NSString stringWithFormat:@"%u", s1];
        self.scoreBottom.text = [NSString stringWithFormat:@"%u", s2];
        
        int gameOver = [self gameOver];
        if (gameOver) {
            [self upgradeLevelForResult: gameOver];
            [self displayMessage:[NSString stringWithFormat:@"PLAYER %i won", gameOver]];
        } else {
            [self reset];
        }
        
        return YES;
    }
    return NO;
}

-(void)upgradeLevelForResult: (int) winner{
    if (winner == 1 && level > 1) {
        level--;
    }
    if (winner == 2) {
        level++;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [self newGame];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resignFirstResponder];
}

@end
