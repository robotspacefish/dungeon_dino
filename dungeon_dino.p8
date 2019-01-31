pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- todo figure out why dino wont animate properly
function _init()
	door_size=10
	floor={
		x0=15,
		y0=15,
		x1=127-15,
		y1=127/1.5-15
	}
end--init

function _update()
	player.update()
	player.animate()
end--_update()

function _draw()
	cls()
	dungeons.draw()
	player.draw()
end--_draw()

-->8
--================ PLAYER ======================================
player={
	x=60,
	y=(127/1.5)/2-4,
	size=8,
	sprite=1,
	walking=false,
	anim_time=0,
	anim_wait=0.08,
	flp=false,
	direction=""
}

------- player.draw --------------
player.draw=function()
		--player
		spr(player.sprite,player.x,player.y,1,1,player.flp)
		print(player.sprite,2,2,8)
end

------- player.update --------------
player.update=function()
	player.walking=false

	player.boundaries()
	player.controls()
	end

------- player.controls --------------
player.controls=function()
	if btn(0) then
		player.x-=1
		player.walking=true
		player.flp=true
		player.direction = "left"
	elseif btn(1) then
		player.x+=1
		player.walking=true
		player.flp=false
		player.direction = "right"
	elseif btn(2) then
		player.y-=1
		player.walking=true
		player.direction = "up"
	elseif btn(3) then
		player.y+=1
		player.walking=true
		player.direction = "down"
	end
end
------- player.animate --------------
player.animate=function()
	if player.walking then
		if player.direction == "left" or player.direction == "right" then
			player.sprite=1
			if time()-player.anim_time>player.anim_wait then
				player.sprite+=1
				player.anim_time=time()
				if player.sprite>4 then player.sprite=1 end
			end
		elseif player.direction == "up" then
			player.sprite=33
			if time()-player.anim_time>player.anim_wait then
				player.sprite+=1
				player.anim_time=time()
				if player.sprite>36 then player.sprite=33 end
			end
		elseif player.direction == "down" then
			player.sprite=17
			if time()-player.anim_time>player.anim_wait then
				player.sprite+=1
				player.anim_time=time()
				if player.sprite>20 then player.sprite=17 end
			end
		end
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
--================ DUNGEONS ======================================
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
--================ MISC FUNCTIONS ======================================
function draw_north_door()
	rectfill(127/2-door_size/2,
											door_size/2,
											127/2+door_size/2,
											14,
											1)
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
00000000000303300003033000030330000303308000000800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003bbdbb003bbdbb003bbdbb003bbdbb0800008000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000bbbbb000bbbbb000bbbbb000bbbbb0080080000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000330000003300000033000000330000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b00333000b033300b00333000b0333000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000bb990b00bb990b00bb990b00bb990b00080080000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000940000009400000049000000490000800008000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b3000000b30000003b0000003b0008000000800000000000000000000000000000000000000000000000000000000000000000000000000000000
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
