local player = getObjectFromGUID("2cb0e2")
local AccelerationSpeed = .2

function getGlobalForce(vector)
  local local_pos = self:positionToWorld(vector)
  local my_pos = self:getPosition()
  local new_force = {x=local_pos.x - my_pos.x, y=local_pos.y - my_pos.y, z=local_pos.z - my_pos.z}
  return new_force
end

--rotate to the player's rotation
self.setRotation(player.getRotation())

--teleport to the player
local yRotRadians = math.rad(player.getRotation()[2]) -- getRotation instead of getPosition
local direction = { x = math.sin(yRotRadians), z = math.cos(yRotRadians) }
local spawnDistance = 25
local cubeLocation = player.getPosition()
local spawnLocation = { x = cubeLocation.x + direction.x * spawnDistance, y = cubeLocation.y , z = cubeLocation.z + direction.z * spawnDistance } -- direction.z is added for z calculation

self.setPosition(spawnLocation)

-- Move the fireball in the direction the player is facing
local add_force = {x = direction.x * AccelerationSpeed, y = 0, z = direction.z * AccelerationSpeed} -- add force in the direction player is facing
self:addForce(getGlobalForce(add_force), 2)

-- Update function to keep moving the fireball
function fixedUpdate()
  to_check = self.getPosition()
  if to_check.z > 33 || to_check.z < -36 || to_check.x < -41 || to_check.x > 4 then
    self.destroyObject()
  end
  self:addForce(getGlobalForce(add_force), 2)
end
