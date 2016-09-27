debug = true

function love.load()
	hero = {} -- new table for the hero
	hero.x = 300	-- x,y coordinates of the hero
	hero.y = 450
	hero.width = 30
	hero.height = 15
	hero.speed = 150
	hero.shots = {} -- holds our fired shots

	enemies = {}
	for i=0,7 do
		enemy = {}
		enemy.width = 40
		enemy.height = 20
		enemy.x = i * (enemy.width + 60) + 100
		enemy.y = enemy.height + 100
		table.insert(enemies, enemy)
	end

    colors = {}
    colors["red"] = {255, 255, 0}
    colors["green"] = {0, 255, 255}
end

function love.keypressed(key)
    if (key == "d") then
        shoot()
    end
end

function love.keyreleased(key)
	if (key == "space") then
		shoot()
	end
end

function love.update(dt)
	-- keyboard actions for our hero
	if love.keyboard.isDown("left") then
		hero.x = hero.x - hero.speed*dt
	elseif love.keyboard.isDown("right") then
		hero.x = hero.x + hero.speed*dt
	end

	local remEnemy = {}
	local remShot = {}

	-- update the shots
	for i,v in ipairs(hero.shots) do

		v.y = v.y - dt * 100 -- move them up up up

		-- mark shots that are not visible for removal
		if v.y < 0 then
			table.insert(remShot, i)
		end

		-- check for collision with enemies
		for ii,vv in ipairs(enemies) do
			if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then
				table.insert(remEnemy, ii) -- mark that enemy for removal
				table.insert(remShot, i) -- mark the shot to be removed
			end
		end
	end

	-- remove the marked enemies
	for i,v in ipairs(remEnemy) do
		table.remove(enemies, v)
	end

	for i,v in ipairs(remShot) do
		table.remove(hero.shots, v)
	end

	-- update those evil enemies
	for i,v in ipairs(enemies) do
		-- let them fall down slowly
		v.y = v.y + dt
		-- check for collision with ground
		if v.y > 465 then
			-- you loose!!!
		end
	end
end


function love.draw()
	-- let's draw a background
	love.graphics.setColor(255,255,255,255)

	-- let's draw some ground
	love.graphics.setColor(0,255,0,255)
	love.graphics.rectangle("fill", 0, 465, 800, 150)

	-- let's draw our hero
	love.graphics.setColor(255,255,0,255)
	love.graphics.rectangle("fill", hero.x, hero.y, hero.width, hero.height)

	-- let's draw our heros shots
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(hero.shots) do
		love.graphics.rectangle("fill", v.x, v.y, 2, 5)
	end

    -- Draw words
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("ddd", 10, 200)

    love.graphics.setColor(255, 255, 255)
    colored_text = {colors.red, "uuuu", colors.green, "dd"}
    love.graphics.print(colored_text, 10, 100)

	-- let's draw our enemies
	love.graphics.setColor(0,255,255,255)
	for i,v in ipairs(enemies) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end
end

function shoot()
	local shot = {}
	shot.x = hero.x+hero.width/2
	shot.y = hero.y
	table.insert(hero.shots, shot)
end

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
