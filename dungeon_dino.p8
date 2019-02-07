pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
	t=0 -- keep track of frames as update runs
	--health sprites
	health={
		full=64,
		half=65,
		empty=66
	}

	rooms={
		r1={
			x=0,
			y=0,
			keys=2
		}
	}

	current_room=rooms.r1
end--init

function _update()
	t+=1
	player.update()
end--_update()

function _draw()
	cls()
	palt(0,false)

	draw_room(current_room.x,current_room.y)
	player.draw()
	ui()
end--_draw()

function draw_room(x,y)
	map(x,y)
end

function ui()
	local x=4
	--example health
	spr(health.full,x,4)
	spr(health.half,x+9,4)
	spr(health.empty,x+18,4)

	--example location for text
	local location="room 1"
	print(location, (128/2)-(#location)-8,6,7)

	--inventory display
	local y,y_add=14*8,2
	local x_add=0
	-- print("test",0,y+y_add,7)
	for i in all(player.items) do
		print(i,x+x_add,y+y_add,7)
		x_add+=20
	end
end

function print_debug()
	-- print("sprite:"..player.sprite,2,2,8)
	-- print("direction:"..player.direction,2,10,8)

end
-->8
--================ player ======================================
player={
	x=1,
	y=3,
	size=8,
	walking=false,
	anim_time=0,
	anim_wait=0.16,
	sprites={{1,2,3,4},{1,2,3,4},{5,6},{7,8}}, --l,r,u,d
	flp=false,
	direction=0,
	items={}
}

------- player.draw --------------
player.draw=function()
		spr(getframe(player.sprites, player.direction),player.x*8,player.y*8,1,1,player.flp)
end

function getframe(anim,direction)
	-- return anim[flr(t/8)%#anim[direction+1]]
	-- direction+1 because Lua tables start at 1 and the directions start at 0
	return anim[direction+1][1]
end

------- player.update --------------
player.update=function()
	player.walking=false
	player.controls()
end

------- player.controls --------------
player.controls=function()
	local next_x,next_y=player.x,player.y
	if btnp(0) then
		-- player.x-=1
		next_x-=1
		player.walking=true
		player.flp=true
		player.direction = 0
	elseif btnp(1) then
		-- player.x+=1
		next_x+=1
		player.walking=true
		player.flp=false
		player.direction = 1
	elseif btnp(2) then
		-- player.y-=1
		next_y-=1
		player.walking=true
		player.direction = 2
		player.flp=false
	elseif btnp(3) then
		-- player.y+=1
		next_y+=1
		player.walking=true
		player.direction = 3
		player.flp=false
	end

	--open locked doors
	local next_tile=mget(next_x,next_y)
	local has_key=false
	for i in all(player.items) do
		if i=="key" then
			has_key=true
		end
	end

	--locked door
	if fget(next_tile,7) and has_key then
		--remove immovable flag
		fset(next_tile,0,false)
		--change tile in location to unlocked door color
		mset(next_x,next_y,next_tile+1)
		--remove key from inventory
		del(player.items,"key")
	end

	--vase
	if fget(next_tile,1) then
		print("break vase",10,10,8)
		mset(next_x,next_y,192)
	end

--todo fix so it works for all chests, not just the first one you go to
--and mget(next_x,next_y,206) == 207
	--key chest
	if fget(next_tile,2) then
		add(player.items,"key")
		--remove key from chest by removing flag
		fset(next_tile,2,false)
		--change chest sprite
		mset(next_x,next_y,206)
	end

	--move if possible
	if not fget(next_tile,0) then
		player.x=next_x
		player.y=next_y
	end

end

------- player.set_sprite --------------
-- player.set_sprite=function()
-- 	if player.walking then
-- 		if player.direction=="l" or player.direction=="r" then player.animate(1,4) end
-- 		if player.direction=="u" then player.animate(7,8) end
-- 		if player.direction=="d" then player.animate(5,6) end
-- 	else
-- 		if player.direction=="l" or player.direction=="r" then player.sprite=1 end
-- 		if player.direction=="u" then player.sprite=7 end
-- 		if player.direction=="d" then player.sprite=5 end
-- 	end
-- end

------- player.animate --------------
player.animate=function(first,last)
	if time()-player.anim_time>player.anim_wait then
		player.sprite+=1
		player.anim_time=time()
		if player.sprite>last then player.sprite=first end
	end
end--player.animate()
-->8
--================ misc functions ======================================


__gfx__
00000000000303300003033000030330000303300003300000033000000330000003300000000000000000000000000000000000000000000000000000000000
00000000003bbdbb003bbdbb003bbdbb003bbdbb0bbbbbb00bbbbbb00bdbbdb00bdbbdb000000000000000000000000000000000000000000000000000000000
00700700000bbbbb000bbbbb000bbbbb000bbbbb0bbbbbb00bbbbbb00bbbbbb00bbbbbb000000000000000000000000000000000000000000000000000000000
00077000000330000003300000033000000330000003300000033000000330000003300000000000000000000000000000000000000000000000000000000000
00077000b00333000b033300b00333000b0333000033330000333300003333000033330000000000000000000000000000000000000000000000000000000000
007007000bb990b00bb990b00bb990b00bb990b0000990b00b099000000990b00b09900000000000000000000000000000000000000000000000000000000000
00000000000940000009400000049000000490000009400000049000000940000004900000000000000000000000000000000000000000000000000000000000
00000000000b3000000b30000003b0000003b000000b30000003b000000b30000003b00000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000006666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05505500055055000550550006000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58858850588500505005005006666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58888850588800505000005000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58888850588800505000005000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05888500058805000500050000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00585000005850000050500000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000500000005000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ddddddd0dd0dd0d020222020000000000900009055555550055555550000000000000000000000000000000009999900099999000555555009999990
00000000ddddddd00000000000000000022222200999999000055550055550000000000000000000000000000000000000990000909090900500005009000090
00000000ddddddd0ddd0ddd0222022200222222009000090dd000050050000dd0000000000000000000000000000000009990900099999000555555009999990
00000000ddddddd000000000000000000222222009999990dd0dd000000dd0dd0000000000000000000000000000000099999990999999900505505009099090
00000000ddddddd0d0ddd0d0ddddddd00222222009000090dd0dd0d00d0dd0dd0000000000000000000000000000000099999090990990900500005009000090
00050000ddddddd000000000ddddddd0022222200999999000000000000000000000000000000000000000000000000099900990999009900500005009000090
00000000ddddddd0dd0dd0d0ddddddd00222222009000090ddddddd00ddddddd0000000000000000000000000000000009999900099999000555555009999990
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009990000000000000000000
00000000ddd020202020ddd0ddddddd0ddddddd066660dd0dd066660ddddd0d000000000000000000000000000000000009990004444444099999990e0eee0e0
00000000ddd020000020ddd0ddddddd0ddddddd066660dd0dd066660ddddd0d000000000000000000000000000000000000900004444444099999990e0eee000
00000000ddd020202020ddd0ddddddd0ddddddd066660dd0dd066660ddddd0d000000000000000000000000000000000009909004444444099999990e0eee0e0
00000000ddd000202000ddd0000000000000000066660dd0dd0666600000000000000000000000000000000000000000099999000000000000000000ee0ee0e0
00000000ddd020202020ddd0222022202222222000000dd0dd0000002202222000000000000000000000000000000000099990004044404090999090e0eee0e0
00060000ddd020000020ddd00000000022222220ddddddd0ddddddd02202222000000000000000000000000000000000099009004404400099099000e0eee000
00000000ddd020202020ddd02022202022222220ddddddd0ddddddd02202222000000000000000000000000000000000009990004044404090999090e0eee0e0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ddd020202020ddd0ddddddd0ddddddd0ddddddd0ddddddd0ddddddd06660ddd0ddd06660666666600000000000000000404440409099909090999090
00000000ddd000000020ddd0ddddddd0ddddddd0ddddddd0ddddddd0ddddddd06660ddd0ddd06660666666600000000000000000004404400099099090999090
00000000ddd022202020ddd0ddddddd0ddddddd0ddddddd0ddddddd0ddddddd06660ddd0ddd06660666666600000000000000000404440409099909090999090
00000000ddd000000000ddd00000ddd0ddd000000000ddd0ddd00000000000006660ddd0ddd06660000000000000000000000000000000000000000099090990
00000000ddddddd0ddddddd02020ddd0ddd020206660ddd0ddd06660666666606660ddd0ddd06660ddddddd00000000000000000444444409999999090999090
00000000ddddddd0ddddddd00020ddd0ddd020006660ddd0ddd06660666666606660ddd0ddd06660ddddddd00000000000000000444444409999999090999090
00000000ddddddd0ddddddd02020ddd0ddd020206660ddd0ddd06660666666606660ddd0ddd06660ddddddd00000000000000000444444409999999090999090
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066066060ddd0000066666660ddddddd00000000000000000000000000000000000000000000000000000000000000000444044409990999000000000
0000000000000000ddddddd066666660ddddddd00000000000000000000000000000000000000000000000000000000000000000444004009990090000000000
0000000066606660ddddddd066666660000000000000000000000000000000000000000000000000000000000000000000000000444040009990900000000000
00000000000000000000000066666660222222200000000000000000000000000000000000000000000000000000000000000000444044409990999000000000
00000000606660602220222066666660222222200000000000000000000000000000000000000000000000000000000000000000444044409990999000000000
00000000000000000000000066666660222222200000000000000000000000000000000000000000000000000000000000000000444000009990000000000000
00000000660660602022202066666660222222200000000000000000000000000000000000000000000000000000000000000000444040409990909000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010000000000000002000105000101010101010100000000028100000001010101010101010101000081000000010101010000000000000000810000
__map__
c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e4d3d3d3e4d3d3d3d3e3d3d3d3d3d3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c6c0c0d1ccccc0cfd2c0c0c0c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e4d3c0c0d1dcdcc0c0d2c0c0c0c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0d1ccc0c0c0d2c0c0c0c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0d3d3d3ddd3d3c0c0e4d3d3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0c0c0c0c0c0c0c0c0fdc0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0e4d3d3e3c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0d1cfccd2c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0d1dcc0d2c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0d3d3ded3c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0c0c0c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0951090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f1f1c5e0e0e0e0e0e0e0e0e0e0e0f1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f1f1e0e0e0e0e0e0e0e0e0e0e0cff1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f1f1e0f1f1e0e0e0e0e0e0f1f1f1f1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f1f1e0e0e0e0e0e0f1f1e0e0e0e0f1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f1f1e0e0e0e0e0ccccccccccccccf1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
