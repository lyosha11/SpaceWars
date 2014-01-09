#include "main.angelscript"
#include "pause.angelscript"
#include "Slot.angelscript"
#include "Module.angelscript"
#include "ship.angelscript"

array<Slot@> sl(8);
array<Slot@> sl_shop(24);
int sl_shopS = 0;
Button@ ret, shp;

void initShop(){
	//init shop
	sl_shopS = 0;
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
	sl_shop[sl_shopS].setMod(Module("+50hp","Increase hp.",1,"sprites/modules/mod_50hp.png","hp",50,200));
	sl_shopS++;
	sl_shop[sl_shopS].setMod(Module("+50sh","Increase shield.",2,"sprites/modules/mod_50sh.png","sh",50,300));
	sl_shopS++;
	sl_shop[sl_shopS].setMod(Module("+4dmg","Increase damage.",3,"sprites/modules/mod_4dmg.png","dmg",4,250));
	sl_shopS++;
	//
}

void changeLevelShop(){
	if(level==3){
		sl_shop[sl_shopS].setMod(Module("Big corpus","Big corpus.Gives good armoring.",1,"sprites/modules/mod_big_crp.png","hp",650,400));
		sl_shopS++;
		sl_shop[sl_shopS].setMod(Module("Big battery","Big battery.Gives good power.",4,"sprites/modules/mod_big_en.png","en",150,500));
		sl_shopS++;
	}
	if(level==4){
		sl_shop[sl_shopS].setMod(Module("Big weapon","Big weapon.Gives good power fire.",3,"sprites/modules/mod_big_dmg.png","dmg",10,600,"shot3.ent"));
		sl_shopS++;
		sl_shop[sl_shopS].setMod(Module("Big Engine","Big engine.Gives good speed.",5,"sprites/modules/mod_big_engine.png","speed",8,600));
		sl_shopS++;
	}
}

void startShop(){
	vector2 retButtonPos(GetScreenSize() * vector2(0.5f, 0.8f));
	@ret = Button("sprites/return_game.png", retButtonPos);
	vector2 shpButtonPos(GetScreenSize() * vector2(0.75f, 0.8f));
	@shp = Button("sprites/ship.png", shpButtonPos);
}

void showDesc(Slot@ s,bool st = true){
	if(s.isMouse()){
		ETHInput@ input = GetInputHandle();
		vector2 vc2 = input.GetCursorPos();
		Module@ mod = s.getMod();
		if(mod.getType()>0){
			if(st){
				DrawText(vector2(vc2.x+20, vc2.y+20),mod.getName() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
				DrawText(vector2(vc2.x+20, vc2.y+40),"type:"+mod.getTypeString() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
				if(mod.getType()==1 || mod.getType()==2 || mod.getType()==4)
					DrawText(vector2(vc2.x+20, vc2.y+60),"status:"+mod.getStatus()+"/"+mod.getEffectCount() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
				if(mod.getType()==3)
					DrawText(vector2(vc2.x+20, vc2.y+60),"damage:"+mod.getEffectCount() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
				if(mod.getType()==5)
					DrawText(vector2(vc2.x+20, vc2.y+60),"speed:"+mod.getEffectCount() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
				DrawText(vector2(vc2.x+20, vc2.y+80),"price:"+mod.getPrice() , "Verdana20_shadow.fnt", 0xFFFFFFFF);
				DrawText(vector2(vc2.x+20, vc2.y+100),mod.getDesc() , "Verdana20_shadow.fnt", 0xFFFFFFFF);
			}else{
				DrawText(vector2(vc2.x+20, vc2.y+20),mod.getName() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
				DrawText(vector2(vc2.x+20, vc2.y+40),"type:"+mod.getTypeString() , "Verdana24_shadow.fnt", 0xFFFFFFFF);
				//DrawText(vector2(vc2.x+20, vc2.y+60),"price:"+mod.getPrice() , "Verdana20_shadow.fnt", 0xFFFFFFFF);
				DrawText(vector2(vc2.x+20, vc2.y+60),mod.getDesc() , "Verdana20_shadow.fnt", 0xFFFFFFFF);
			}
			
		}
	}
}

void loopShop(){
	//Show shop slots
	for(uint i=0;i<24;i++){
		sl_shop[i].put();
		if(sl_shop[i].isPressed()){
			int smod = -1;
			for(uint i2=0;i2<8;i2++){
				if(!sl[i2].isMod()){
					smod = i2;
					break;
				}
			}
			if(smod!=-1){
				ETHEntity@ pl = SeekEntity("player.ent");
				Module mod = sl_shop[i].getMod();
				if(pl.GetInt("money")>=mod.getPrice()){
					sl[smod].setMod(sl_shop[i].getMod());
					pl.SetInt("money",pl.GetInt("money")-mod.getPrice());
				}
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
	//
	showShipSlots();
	//Description
	for(uint i=0;i<24;i++)
		showDesc(sl_shop[i]);
}