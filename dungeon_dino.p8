pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- todo fix animation where for about 3 frames after pressing a different direction, the dino doesn't update to the right sprite
function _init()
	door_size=10
	floor={
		x0=15,
		y0=15,
		x1=127-15,
		y1=127/1.5-15
	}

	--health sprites
	full=9
	half=10
	empty=11
end--init

function _update()
	player.update()
end--_update()

function _draw()
	cls()
	ui()
	map(0,0)
	player.draw()
end--_draw()

function ui()
	x=4
	--example health
	spr(full,x,4)
	spr(half,x+9,4)
	spr(empty,x+18,4)

	--example location for text
	local location="room 1"
	print(location, (128/2)-(#location)-8,6,7)
end

function print_debug()
	print("sprite:"..player.sprite,2,2,8)
	print("direction:"..player.direction,2,10,8)
end
-->8
--================ player ======================================
player={
	x=60,
	y=(127/1.5)/2-4,
	size=8,
	sprite=1,
	walking=false,
	anim_time=0,
	anim_wait=0.16,
	flp=false,
	direction="",
}

------- player.draw --------------
player.draw=function()
		spr(player.sprite,player.x,player.y,1,1,player.flp)
end

------- player.update --------------
player.update=function()
	player.walking=false
	player.boundaries()
	player.controls()
	player.set_sprite()
	end

------- player.controls --------------
player.controls=function()
	if btn(0) then
		player.x-=1
		player.walking=true
		player.flp=true
		player.direction = "l"
	elseif btn(1) then
		player.x+=1
		player.walking=true
		player.flp=false
		player.direction = "r"
	elseif btn(2) then
		player.y-=1
		player.walking=true
		player.direction = "u"
		player.flp=false
	elseif btn(3) then
		player.y+=1
		player.walking=true
		player.direction = "d"
		player.flp=false
	end
end

------- player.set_sprite --------------
player.set_sprite=function()
	if player.walking then
		if player.direction=="l" or player.direction=="r" then player.animate(1,4) end
		if player.direction=="u" then player.animate(7,8) end
		if player.direction=="d" then player.animate(5,6) end
	else
		if player.direction=="l" or player.direction=="r" then player.sprite=1 end
		if player.direction=="u" then player.sprite=7 end
		if player.direction=="d" then player.sprite=5 end
	end
end

------- player.animate --------------
player.animate=function(first,last)
	if time()-player.anim_time>player.anim_wait then
		player.sprite+=1
		player.anim_time=time()
		if player.sprite>last then player.sprite=first end
	end
end--player.animate()


player.boundaries=function()
	-- right wall collision
	if player.x+player.size>=floor.x1 then player.x=floor.x1-player.size end
	-- left wall collision
	if player.x<=floor.x0 then player.x=floor.x0 end
	-- top wall collision
	if player.y<=floor.y0 then player.y=floor.y0 end
	-- bottom wall collision
	if player.y+player.size>=floor.y1 then player.y=floor.y1-player.size end
end

-->8
--================ dungeons ======================================
dungeons={
	map={
		dungeon_1={
			room_1={
				name="entrance",
				door_n=true,
				door_s=false,
				door_e=true,
				door_w=true,
				items={},
				current=true
			}
		}
	},
	draw=function()
		local current_dungeon = dungeons.map.dungeon_1
		local current_room=current_dungeon.room_1
		room.draw(current_room.door_n,current_room.door_s,current_room.door_e,current_room.door_w)
		-- print(current_room.door_n,0,0,1)
	end
}--end dungeons

room={
	draw=function(n,s,e,w)
		local offset=15
		--walls
		rectfill(1,1,126,127/1.5,6)
		--floor
			rectfill(floor.x0,floor.y0,floor.x1,floor.y1,5)
		--corners
		local corner_col=1
		line(0,0,14,14,corner_col)
		line(127,0,127-14,14,corner_col)
		line(0,127/1.5,14,127/1.5-14,corner_col)
		line(127,127/1.5,127-14,127/1.5-14,corner_col)

		--doors
		if n then draw_north_door() end
		if s then draw_south_door() end
		if e then draw_east_door() end
		if w then draw_west_door() end
		--border
		rect(0,0,127,127/1.5,7)
	end
}--end room

-->8
--================ misc functions ======================================
function draw_north_door()
	-- rectfill(127/2-door_size/2,
	-- 										door_size/2,
	-- 										127/2+door_size/2,
	-- 										14,
	-- 										1)
	spr(64,127/2-4,2,2,2)
end

function draw_south_door()
	rectfill(127/2-door_size/2,
											127/2+door_size/2+2,
											127/2+door_size/2,
											127/2+16,
										1)
end

function draw_east_door()
	rectfill(14-door_size,
											(127/1.5)/2-door_size/2,
										 14,
									  (127/1.5)/2+door_size/2,
										 1)
end

function draw_west_door()
	rectfill(127-4-door_size,
										 (127/1.5)/2-door_size/2,
											127-4,
											(127/1.5)/2+door_size/2,
											1)

end

__gfx__
00000000000303300003033000030330000303300003300000033000000330000003300000000000000000000000000000000000000000000000000000000000
00000000003bbdbb003bbdbb003bbdbb003bbdbb0bdbbdb00bdbbdb00bbbbbb00bbbbbb005505500055055000550550000000000000000000000000000000000
00700700000bbbbb000bbbbb000bbbbb000bbbbb0bbbbbb00bbbbbb00bbbbbb00bbbbbb058858850588500505005005000000000000000000000000000000000
00077000000330000003300000033000000330000003300000033000000330000003300058888850588800505000005000000000000000000000000000000000
00077000b00333000b033300b00333000b0333000033330000333300003333000033330058888850588800505000005000000000000000000000000000000000
007007000bb990b00bb990b00bb990b00bb990b0000990b00b099000000990b00b09900005888500058805000500050000000000000000000000000000000000
00000000000940000009400000049000000490000009400000049000000940000004900000585000005850000050500000000000000000000000000000000000
00000000000b3000000b30000003b0000003b000000b30000003b000000b30000003b00000050000000500000005000000000000000000000000000000000000
00000000000330000003300000033000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000bdbbdb00bdbbdb00bdbbdb00bdbbdb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000bbbbbb00bbbbbb00bbbbbb00bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000330000003300000033000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003333000033330000333300003333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000990b0000990b00b0990000b0990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000940000009400000049000000490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b3000000b30000003b0000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000330000003300000033000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000bbbbbb00bbbbbb00bbbbbb00bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000bbbbbb00bbbbbb00bbbbbb00bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000330000003300000033000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003333000033330000333300003333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000990b0000990b00b0990000b0990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000940000009400000049000000490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b3000000b30000003b0000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111111111111111111666666661111111111111111666666666666666d1666666666666661000000000000000000000000000000000000000000000000
666666666666666615666666666666666666666666666651666666666666666d1666666666666661000000000000000000000000000000000000000000000000
6666666dd666666616566666666666666666666666666561666666666666666d1666666666666661000000000000000000000000000000000000000000000000
666666dddd66666616656666666666666666666666665661666666666666666d1666666666666661000000000000000000000000000000000000000000000000
66666dddddd6666616665666666666666666666666656661666666666666666d1666666666666661000000000000000000000000000000000000000000000000
66666dddddd6666616666566666666666666666666566661666666666666666d1666666666666661000000000000000000000000000000000000000000000000
6666dddddddd666616666656666666666666666665666661666666666666666d1666666666666661000000000000000000000000000000000000000000000000
6666dddddddd66661666666566666666666666665666666111111111111111111666666666666661000000000000000000000000000000000000000000000000
666dddddddddd6661666666556666666666666655666666100000000000000000000000000000000000000000000000000000000000000000000000000000000
666dddddddddd6661666665665666666666666566566666100000000000000000000000000000000000000000000000000000000000000000000000000000000
666dddddddddd6661666656666566666666665666656666100000000000000000000000000000000000000000000000000000000000000000000000000000000
66dddddddddddd661666566666656666666656666665666100000000000000000000000000000000000000000000000000000000000000000000000000000000
66dddddddddddd661665666666665666666566666666566100000000000000000000000000000000000000000000000000000000000000000000000000000000
66dddddddddddd661656666666666566665666666666656100000000000000000000000000000000000000000000000000000000000000000000000000000000
66dddddddddddd661566666666666656656666666666665100000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111166666661166666661111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000006666666100000000166666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000006666665600000000656666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000006666656600000000665666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000006666566600000000666566660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000006665666600000000666656660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000006656666600000000666665660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000006566666600000000666666560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000005666666600000000666666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000ddddddd0dd0dd0d020222020222222200900009055555550909099900000000000000000000000000000000009999900099999000000000000000000
00000000ddddddd00000000000000000222222200999999000055550909090900000000000000000000000000000000000990000909090900555555009999990
00000000ddddddd0ddd0ddd0222022202222222009000090dd000050909090900000000000000000000000000000000009990900099999000500005009000090
00000000ddddddd000000000000000002222222009999990dd0dd000909099900000000000000000000000000000000099999990999999900555555009999990
00000000ddddddd0d0ddd0d0ddddddd02222222009000090dd0dd0d0909090000000000000000000000000000000000099999090990990900505505009099090
00050000ddddddd000000000ddddddd0222222200999999000000000909090000000000000000000000000000000000099900990999009900500005009000090
00000000ddddddd0dd0dd0d0ddddddd02222222009000090ddddddd0999090000000000000000000000000000000000009999900099999000555555009999990
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009990000000000000000000
00000000ddd020202020ddd0ddddddd0ddddddd066660dd0dd066660ddddd0d000000000000000000000000000000000009990000000000099999990e0eee0e0
00000000ddd020000020ddd0ddddddd0ddddddd066660dd0dd066660ddddd0d000000000000000000000000000000000000900000000000099999990e0eee000
00000000ddd020202020ddd0ddddddd0ddddddd066660dd0dd066660ddddd0d000000000000000000000000000000000009909000000000099999990e0eee0e0
00000000ddd000202000ddd0000000000000000066660dd0dd0666600000000000000000000000000000000000000000099999000000000000000000ee0ee0e0
00000000ddd020202020ddd0222022202222222000000dd0dd0000002202222000000000000000000000000000000000099990000000000090999090e0eee0e0
00060000ddd020000020ddd00000000022222220ddddddd0ddddddd02202222000000000000000000000000000000000099009000000000099099000e0eee000
00000000ddd020202020ddd02022202022222220ddddddd0ddddddd02202222000000000000000000000000000000000009990000000000090999090e0eee0e0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ddd020202020ddd0ddddddd0ddddddd0ddddddd0ddddddd0ddddddd06660ddd0ddd06660666666600000000000000000000000009099909090999090
00000000ddd000000020ddd0ddddddd0ddddddd0ddddddd0ddddddd0ddddddd06660ddd0ddd06660666666600000000000000000000000000099099090999090
00000000ddd022202020ddd0ddddddd0ddddddd0ddddddd0ddddddd0ddddddd06660ddd0ddd06660666666600000000000000000000000009099909090999090
00000000ddd000000000ddd00000ddd0ddd000000000ddd0ddd00000000000006660ddd0ddd06660000000000000000000000000000000000000000099090990
00000000ddddddd0ddddddd02020ddd0ddd020206660ddd0ddd06660666666606660ddd0ddd06660ddddddd00000000000000000000000009999999090999090
00000000ddddddd0ddddddd00020ddd0ddd020006660ddd0ddd06660666666606660ddd0ddd06660ddddddd00000000000000000000000009999999090999090
00000000ddddddd0ddddddd02020ddd0ddd020206660ddd0ddd06660666666606660ddd0ddd06660ddddddd00000000000000000000000009999999090999090
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066066060ddd0000066666660ddddddd00000000000000000000000000000000000000000000000000000000000000000000000009990999000000000
0000000000000000ddddddd066666660ddddddd00000000000000000000000000000000000000000000000000000000000000000000000009990090000000000
0000000066606660ddddddd066666660000000000000000000000000000000000000000000000000000000000000000000000000000000009990900000000000
00000000000000000000000066666660222222200000000000000000000000000000000000000000000000000000000000000000000000009990999000000000
00000000606660602220222066666660222222200000000000000000000000000000000000000000000000000000000000000000000000009990999000000000
00000000000000000000000066666660222222200000000000000000000000000000000000000000000000000000000000000000000000009990000000000000
00000000660660602022202066666660222222200000000000000000000000000000000000000000000000000000000000000000000000009990909000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010000000000000000000101000101010101010100000000000000000001010101010101010101000000000000010101010000000000000000000000
__map__
c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e4d3d3d3e4d3d3d3d3e3d3d3d3d3d3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c6c0c0d1c0c0c0c0d2c5c0c0c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1d3c0c0d1c0c0c0c0d2c0c0c0c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0d1c0c0c0c0d2c0c0c0c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0d3d3d3ded3d3c0c0e4d3d3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0c0c0c0c0c0c0c0c0fec0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0e4d3d3e3c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0d1cfccd2c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0d1dcc0d2c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0d3d3ded3c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1c0c0c0c0c0c0c0c0c0c0c0d1c0c0d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e1c3c3c3c3c3c3c3c3c3c3c3e1c3c3e200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
