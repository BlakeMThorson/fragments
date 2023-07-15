-- Define the starting position (point A) and the target position (point B)
local pointA = Vector(-24.0692405700684,1.10245215892792,20.8596668243408)
local pointB = Vector(-23.5129985809326,1.10245203971863,-20.1370906829834)

-- Define the number of intermediate points
local numPoints = 25  -- Adjust the number of intermediate points as desired

-- Calculate the positions of the intermediate points
local points = {}
for i = 0, numPoints do
    points[i+1] = pointA:lerp(pointB, i / numPoints)
end

-- Define a flag to keep track of the current target
local movingToA = true

-- Define the current point index
local pointIndex = 1

function onLoad()
    -- Start moving after a short delay
    Wait.time(move_to_next_point, 1)
end

function checkForPlayersInBubble()
    -- Define the radius of the bubble
    local bubbleRadius = 2.0

    -- Perform a physics cast to detect players within the bubble
    local bubbleCenter = self.getPosition() + Vector(0, 0, 0)
    local objects = Physics.cast({
        origin = bubbleCenter,
        direction = Vector(0, 1, 0),
        type = 3, -- Type 3 represents players
        size = Vector(bubbleRadius, bubbleRadius, bubbleRadius),
        max_distance = bubbleRadius,
        debug = false
    })

    -- Check if any object named "player" is found within the bubble
    local playerFound = false
    local player = nil
    for _, object in ipairs(objects) do
        if object.hit_object and object.hit_object.getName() == "player" then
            playerFound = true
            player = object.hit_object
            break
        end
    end

    -- Print "PLAYER FOUND" if a player is found
    if playerFound then
        print("PLAYER FOUND")
        player.setPositionSmooth(Vector(-46.6064224243164,18.7418270111084,-33.8052558898926))
    end
end

local health = 25
function add_damage(damage)
    health = health - damage
    print(health)
    if health <= 0 then
        memory = getObjectFromGUID("ed7675")
        memory.call("adjust_kills",1)
        memory.call("adjust_currency",5)
        destroyObject(self)
    end
end

function move_to_next_point()
    checkForPlayersInBubble()
    -- Determine the next target point based on the current target
    local nextPoint = points[pointIndex]

    -- Move the object to the next point
    self.setPositionSmooth(nextPoint)

    -- Schedule the next movement after the current one is expected to finish
    Wait.condition(move_to_next_point, function()
        return (self.getPosition() - nextPoint):magnitude() < 0.1
    end)

    -- Update the point index and target flag for the next movement
    if movingToA then
        pointIndex = pointIndex + 1
        if pointIndex > numPoints + 1 then
            movingToA = false
            pointIndex = numPoints
        end
    else
        pointIndex = pointIndex - 1
        if pointIndex < 1 then
            movingToA = true
            pointIndex = 2
        end
    end
end
