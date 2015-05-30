--- Timer ---

-- Setup local access
local Timer = {}
local Timer_mt = {}
Timer_mt.__index = Timer
    
-- for some reason 10 sounds like a traditional default number for a timer :)
Timer.DEFAULT_TIME = 10

-- Creates a new Timer with the specified initial time. NOTE: time should be a
-- whole number, if it isn't the number will be floored.
-- param time: Time to set on the clock, default is 10 (time must be of type
--             number, or an error will be thrown)
function Timer:new(time)
    -- sanity check for numbers
    if type(time) ~= 'number' and time ~= nil then
        error('Timer must be set with a number.', 2)
    end

    local timer = {}
    
    timer.time = time or Timer.DEFAULT_TIME 

    -- make sure time is not a decimal
    timer.time = math.floor(timer.time)

    -- save the original time value to use for reset()
    timer.originalTime = timer.time
    timer.elapsedTime = 0

    -- flag to indicate whether the timer is counting down or not
    timer.isRunning = false

    return setmetatable(timer, Timer_mt)
end

-- Sets the time to countdown from
-- param time: Time to set on the clock, default is 10 (time must be of type
--             number, or an error will be thrown)
function Timer:setTime(time)
    if type(time) ~= 'number' and time ~= nil then
        error('Timer must be set with a number.', 2)
    end
    
    self.time = time or Timer.DEFAULT_TIME 

    self.time = self.time
    self.originalTime = self.time
end

-- Starts the Timer
function Timer:start()
    self.isRunning = true
end

-- Stops the Timer at the current time
function Timer:stop()
    self.isRunning = false
end

-- Resets the Timer to the value given by the last call to setTime or from the
-- original constructor call.
function Timer:reset()
    self.time = self.originalTime
end

-- Gets the remaining time on the Timer (in seconds)
function Timer:getTimeRemaining()
    return self.time
end

-- Updates the timer, if the Timer is not running from a call to start this
-- function will not do anything.
-- param dt: The elapsed time since the last call to update() (in seconds).
function Timer:update(dt)
    -- only update the elapsedTime is the Timer is running.
    if self.isRunning then
        self.elapsedTime = self.elapsedTime + dt
            
        if self.time ~= 0  and self.elapsedTime >= 1 then
            -- Every step just decrements 1 second, this game is really only concerned
            -- with seconds.
            self.time = self.time - 1
            self.elapsedTime = self.elapsedTime - 1
        elseif self.time <= 0 then
            self.time = 0
            self:stop()
        end
    end
end

return Timer
