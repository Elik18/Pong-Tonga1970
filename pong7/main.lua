
--Taught Dev by Colton Ogden
-- Script wrote and learned by Elikplim Nyakutse B.
--Fixme for continous xy paddle speed not stopping without keyisbeingpressed

--library for adding stack elements to stack or pushing elements( push library)
local push = require "push"

  local Class = require 'class'

    require 'Paddle'

    require 'Ball'
-- default window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual new window size
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--Default paddle speed (rectangles on the sides)
PADDLE_SPEED = 200

Player1Serve = false
Player2Serve = false

WinningPlayer = 0

Sounds = {}

--Main function that changes the behaviour of the program
function love.load()

    --Default filter for screen resolution
    love.graphics.setDefaultFilter('nearest', 'nearest')

    Sounds = { 
        ["score"] = love.audio.newSource("Sounds/Pickup_Coin.wav", "static"),
       ["paddlehit"] = love.audio.newSource("Sounds/Jump.wav" , "static"),
       ["gamecube"] = love.audio.newSource("Sounds/gamecube.mp3","static")
    }

    -- seeding random seed for generator 
    math.randomseed(os.time())
    -- small font included in program
   -- SmallFont = love.graphics.newFont('Debrosee-ALPnL.ttf', 8)
   -- love.graphics.setFont(SmallFont)

    --Pushing screen size to stack state (i.e. pushing the screen values to the console)
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
    fullscreen = false,
    resizable = false,
    vsync = true })

     --Creating two players score
    Player1Score = 0
    Player2Score = 0
    
   --paddle positions
   Paddle1 = Paddle(10,30,5,20)
   Paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5 , 20)

   --Ball values x y starting positions
   Ball1 = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4 , 4)
  
      
    -- Score font 
    --ScoreFont = love.graphics.newFont('Debrosee-ALPnL.ttf', 8)
   --love.graphics.setFont(ScoreFont)

   --Starting state being pushed to stack
   GameState = 'start'

end

function love.update(dt)

   
    if GameState == 'Serving' then
        if Player1Serve == true then
            Ball1:reset()
            Ball1.dx = math.random(140, 200)
            Ball1.dy = math.random( 50, 50 )

        elseif Player2Serve == true then   
            Ball1:reset()
            Ball1:reset()
            Ball1.dx = -math.random(140, 200)
            Ball1.dy = math.random( 50, 50 )
        end
    end
        
        --Holding up values for paddle 1
        if love.keyboard.isDown('w') then
        Paddle1.dy = PADDLE_SPEED
        --End of screen collision detection
        Paddle1.dy = 0 +- PADDLE_SPEED

        --Holding downwards values for paddle 
        elseif love.keyboard.isDown('s') then
        Paddle1.dy = PADDLE_SPEED
        --End of screen collision detection
        Paddle1.dy = Paddle1.dy + Paddle1.height
        end

        --Holding up values for paddle 2
        if love.keyboard.isDown('up') then
        Paddle2.dy = PADDLE_SPEED
        --End of screen collision detection
        Paddle2.dy = 0 +- PADDLE_SPEED

        --Holding up values for paddle 2
        elseif love.keyboard.isDown('down') then
        Paddle2.dy = PADDLE_SPEED
        --End of screen collision detection
        Paddle2.dy = Paddle2.dy + Paddle2.height
        end

        --Ball state definition loaded into stack
        if GameState == 'play' then

            Sounds["gamecube"]:play()
        
            if Ball1.x < 0 then
                Player2Score = Player2Score + 1
                Sounds["score"]:play()
                GameState = 'Serving'
                Player1Serve = true

            elseif Ball1.x > VIRTUAL_WIDTH then
                Sounds["score"]:play()
                Player1Score = Player1Score + 1
                    GameState = 'Serving'
                    Player2Serve = true
            
            end
    
            if Player1Score == 10 or Player2Score == 10 then
                GameState = 'Victory'
                if Player1Score == 10 then
                    WinningPlayer = 1 

                end
            elseif Player2Score == 10 then
                WinningPlayer = 2
            end
            
            
            --Collision detection 
        if Ball1:collides(Paddle1)then
            Sounds["paddlehit"]:play()
            Ball1.dx = -Ball1.dx * 1.03
            Ball1.x = Paddle1.x + 5 
            if Ball1.dy < 0 then
                Ball1.dy = -math.random(10,150)
            else
                Ball1.dy = math.random(10,150)
            end  
        end

        

        if Ball1:collides(Paddle2)then
            Ball1.dx = -Ball1.dx * 1.03
            Ball1.x = Paddle2.x - 4  
            if Ball1.dy < 0 then
                Ball1.dy = -math.random(10,150)
            else
                Ball1.dy = math.random(10,150)
            end

            Sounds["paddlehit"]:play()
        end

        if Ball1.y <= 0 then
            Ball1.y = 0
            Ball1.dy = -Ball1.dy
        end
        if Ball1.y >= VIRTUAL_HEIGHT - 4 then
            Ball1.y = VIRTUAL_HEIGHT  -4 
            Ball1.dy = -Ball1.dy
        end

        Ball1:update(dt)

        elseif GameState == 'start' then
            Ball1:reset()
        end
    
        --Update Paddle values
        Paddle1:update(dt)
        Paddle2:update(dt)
end

function DisplayFPS()
    love.graphics.setColor(0,1,0,1)
    love.graphics.print("FPS: ".. tostring(love.timer.getFPS()))
end
-- Function For GameState while key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
       if GameState == 'start' then
        GameState = 'play'
        
    
    else
        GameState = 'start'
        --Ball values x y starting positions
        Ball1:reset() 
       end
    end
end


--Function for drawing objects to screen
function love.draw()
    --pushes the first objects to screen
    push:apply('start')

    love.graphics.clear(0.2, 0.21, 0.3, 1)
    if GameState == 'Victory'then
        love.graphics.print("Congrats Winning Player is Player:".. WinningPlayer , 50, 50)
    end
    --Prints the Title in middle
   -- love.graphics.setFont(SmallFont)
    if GameState == 'start' then
    love.graphics.printf(
        'Hello Pong!',
        0,
        20,
        VIRTUAL_WIDTH,
        'center'
    )
        if Player1Serve == true then
            love.graphics.print("Player 1 is Serving.. ", VIRTUAL_WIDTH / 2 - 22, 10)
        elseif Player2Serve == true then
            love.graphics.print("Player 2 is Serving.. ", VIRTUAL_WIDTH / 2 - 22, 10)       
        end
    elseif GameState == 'play' then
    love.graphics.printf("Play State", 0, 20,VIRTUAL_WIDTH, 'center')
        
    end
    --Drawing score at top of screen
  -- love.graphics.setFont(SmallFont)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    --Prints the paddles and the ball   
    Paddle1:render()
    Paddle2:render()
    Ball1:render()
    DisplayFPS()
    -- Stacks the end behaviour to be printed
    push:apply('end')
end