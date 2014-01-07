#include "main.angelscript"
#include "pause.angelscript"
#include "Slot.angelscript"
#include "Module.angelscript"
#include "ship.angelscript"

array<Slot@> sl(8);
array<Slot@> sl_shop(24);
Button@ ret, shp;

void initShop(){
	//init sl
	for(uint i=0;i<8;i++){
		float x = 0.135f;
		for(uint i2=0;i2<i;i2++){
			x = x + 0.1f;
		}
		vector2 Pos(GetScreenSize() * vector2(x, 0.66f));
		@sl[i] = Slot("sprites/modules/slot.png", Pos);
	}
	//init sl_shop
	uint s = 0;
	for(uint i1=0;i1<3;i1++){
		float y = 0.17f;
		for(uint i2=0;i2<i1;i2++){
			y = y + 0.15f;
		}
		for(uint i=0;i<8;i++){
			float x = 0.135f;
			for(uint i2=0;i2<i;i2++){
				x = x + 0.1f;
			}
			vector2 Pos(GetScreenSize() * vector2(x, y));
			@sl_shop[s] = Slot("sprites/modules/slot.png", Pos);
			s++;
		}
	}
	//Add module to shop
	sl_shop[0].setMod(Module("+50hp","Increase hp",1,"sprites/modules/mod_50hp.png","hp",50));
	sl_shop[1].setMod(Module("+50sh","Increase shield",2,"sprites/modules/mod_50sh.png","sh",50));
	sl_shop[2].setMod(Module("+4dmg","Increase damage",3,"sprites/modules/mod_4dmg.png","dmg",4));
	//
}

void startShop(){
	vector2 retButtonPos(GetScreenSize() * vector2(0.5f, 0.8f));
	@ret = Button("sprites/return_game.png", retButtonPos);
	vector2 shpButtonPos(GetScreenSize() * vector2(0.75f, 0.8f));
	@shp = Button("sprites/ship.png", shpButtonPos);
}

void showDesc(Slot@ s){
	if(s.isMouse()){
		ETHInput@ input = GetInputHandle();
		vector2 vc2 = input.GetCursorPos();
		Module@ mod = s.getMod();
		DrawText(vector2(vc2.x+20, vc2.y+20),mod.getName() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
		DrawText(vector2(vc2.x+20, vc2.y+40),mod.getDesc() , "Verdana20_shadow.fnt", 0xFFFFFFFF);
	}
}

void loopShop(){
	showShipSlots();
	//Show shop slots
	for(uint i=0;i<24;i++){
		sl_shop[i].put();
		showDesc(sl_shop[i]);
		if(sl_shop[i].isPressed()){
			int smod = -1;
			for(uint i2=0;i2<8;i2++){
				if(!sl[i2].isMod()){
					smod = i2;
					break;
				}
			}
			if(smod!=-1){
				sl[smod].setMod(sl_shop[i].getMod());
			}else{
				print("smod = -1");
			}
			sl_shop[i].setPressed(false);
		}
	}
	//Put buttons
	ret.putButton();
	shp.putButton();
	//
	if(ret.isPressed()){
		shop = false;
		pause = true;
	}
	if(shp.isPressed()){
		startShip();
		ship = true;
		shp.setPressed(false);
	}
}