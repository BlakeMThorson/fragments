--format is
--x,y,z,r,s (x,y,z,rotation,steps TO this point)
local destinations = {} -- holds the main coordinates


local rotations = {} -- is a value on each line
local steps = {} -- steps and shit
local between_steps = {} -- steps between steps


local health = 6
local strength = 1


local player_respawn_vector = Vector(-46.6064224243164,18.7418270111084,-33.8052558898926)


--converts the description to working pathing instructions
function convert_description()
    local lines = description:split("\n")




    for _, line in ipairs(lines) do
        local parts = line:split(",")
        if #parts >= 3 then
            local x = tonumber(parts[1])
            local y = tonumber(parts[2])
            local z = tonumber(parts[3])
            local destination = Vector(x, y, z)
            table.insert(destinations, destination)
        end
        if #parts >= 4 then
            table.insert(rotations,tonumber((parts[4])))
        else
            table.insert(rotations,0)
        end
        if #parts >= 5 then
            table.insert(steps,tonumber(parts[5]))
        else
            table.insert(steps,20)
        end
    end


    return true
end


--calculates the fun steps between steps
function calculate_intermediates(pointA,PointB)
    local points = {}
    for i = 0, numPoints do
        points[i+1] = pointA:lerp(pointB, i / numPoints)
    end
end


--this stays.
local current = 0
local next = nil
function onLoad()
    --get shit from the description & convert it
    if convert_description then
        print("You are the circus providing your own bread while admiring the man with the chair that put you there.")
        --if we are able to set the variables
        --then we have all the of points
        -- so we need to get the between points and move to them
        --get the points
        if next > #destinations then
            --if we have cycled to the end and next is now invalid
            next = 0
        end
        if current > #destinations then
            current = 0
            next = 1
        end
        calculate_intermediates(destinations[current],destinations[next])


        Wait.time(move_to_next_point, 1)
        local point_index = 0
        move_to_next_point()
    end
    --make them big steppers and shit.




end


function checkForPlayersInBubble()
    local coll_box_size = 2.0


    -- Perform a physics cast to detect players within the bubble
    local col_box_center = self.getPosition()
    local objects = Physics.cast({
        origin = col_box_center,
        direction = Vector(0, 1, 0),
        type = 3,
        size = Vector(coll_box_size, coll_box_size, coll_box_size),
        max_distance = coll_box_size,
        debug = false
    })


    -- Check if any object named "player" is found within the bubble
    local playerFound = false
    local player = nil
    for _, object in ipairs(objects) do
        if object.hit_object and object.hit_object.getName() == "player" then
            object.hit_object.setPositionSmooth(player_respawn_vector)
            break
        end
    end
end


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


function move_to_next_point(movements, rotation, steps)
    checkForPlayersInBubble()
    -- Determine the next target point based on the current target
    local next_point = movements[point_index]
    point_index += 1


    -- Move the object to the next point
    self.setPositionSmooth(nextPoint)


    -- Schedule the next movement after the current one is expected to finish
    Wait.condition(move_to_next_point, function()
        return (self.getPosition() - next_point):magnitude() < 0.1
    end)




end

