Dir = {Forward = "z", Side = "x"}

RCCar = true

-- Changes whether the vehicle cares about touching the floor.
WheelsMustTouchGround = false

AccelerationSpeed = .2
MoveMax = 599
TurnSpeed = 3

-- Controls which scripting buttons move the vehicle forwards, backwards, left & right.
Indexes = {}
Indexes[8] = "Forwards"
Indexes[4] = "Left"
Indexes[5] = "Backwards"
Indexes[6] = "Right"
Indexes[7] = "Interact"
Indexes[0] = "Shoot"
-- These should not be changed.
Movement = {}
Movement.Forwards = false
Movement.Right = false
Movement.Backwards = false
Movement.Left = false

function round(n, dp)
    return math.floor(n*(dp*10)+0.5)/(dp*10)
end

function getGlobalForce(vector)
    local local_pos = self:positionToWorld(vector)
    local my_pos = self:getPosition()
    local new_force = {x=local_pos.x - my_pos.x, y=local_pos.y - my_pos.y, z=local_pos.z - my_pos.z}
    return new_force
end

function fixedUpdate()
    if (Movement.Forwards == true or Movement.Backwards == true or Movement.Left == true or Movement.Right == true) then
        if Movement.Forwards == true or Movement.Backwards == true then
            local vel = self.getVelocity()
            if (math.abs(vel.x) + math.abs(vel.z)) < MoveMax then
                local add_force = {x=0, y=0, z=0}
                if Movement.Forwards == true then
                    add_force[Dir.Forward] = add_force[Dir.Forward] + AccelerationSpeed
                end
                if Movement.Backwards == true then
                    add_force[Dir.Forward] = add_force[Dir.Forward] - AccelerationSpeed
                end
                self:addForce(getGlobalForce(add_force), 4)
            end
        end
        if Movement.Left == true or Movement.Right == true then
            local my_torque = {x=0, y=0, z=0}
            if Movement.Left == true then
                my_torque.y = my_torque.y - TurnSpeed
            end
            if Movement.Right == true then
                my_torque.y = my_torque.y + TurnSpeed
            end
            self:setAngularVelocity(my_torque)
        end
    end
end

function inRange(num1, num2, range)
    if num1 >= num2 - range and num1 <= num2 + range then return true end
    return false
end

function isOwner(my_col)
    for _, col in pairs(getSeatedPlayers()) do
        if self:getDescription() == col then
            if my_col == col then
                return true
            end
            return false
        end
    end
    return true
end

function onScriptingButtonDown(index, player_colour)
    if Indexes[index] ~= nil and isOwner(player_colour) then
        Movement[Indexes[index]] = true
    end
end


local is_first_person = false
function onScriptingButtonUp(index, player_colour)
    if Indexes[index] ~= nil and isOwner(player_colour) then
        Movement[Indexes[index]] = false
    end
    --combat handler
    local assetBundle = self.AssetBundle
    if index == 10 and isOwner(player_colour) then
        fireball()
    end

    --firstperson handler
    if index == 9 and isOwner(player_colour) then
        if is_first_person then
            assetBundle.playLoopingEffect(0)
            is_first_person = false
        else
            is_first_person = true
            assetBundle.playLoopingEffect(1)
        end
    end

    --interaction handler
    if index == 7 and isOwner(player_colour) then
        print("touch")
        interact()
    end

end


function fireball()
    self.playTriggerEffect(0)
    fireball_bag = getObjectFromGUID("aefd51")
    
end

function interact()
end
