#include "main.angelscript"
#include "pause.angelscript"
#include "Slot.angelscript"
#include "Module.angelscript"

array<Slot@> sl(8);
array<Slot@> sl_shop(24);
Button@ ret;

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
	sl_shop[0].setMod(Module("sprites/modules/mod_50hp.png","hp",50));
	sl_shop[1].setMod(Module("sprites/modules/mod_50sh.png","sh",50));
	sl_shop[2].setMod(Module("sprites/modules/mod_4dmg.png","dmg",4));
	//
}

void startShop(){
	vector2 retButtonPos(GetScreenSize() * vector2(0.5f, 0.8f));
	@ret = Button("sprites/return_game.png", retButtonPos);
}

void loopShop(){
	DrawText(GetScreenSize() * vector2(0.11f, 0.58f), "Ship slots:", "Verdana20_shadow.fnt", 0xFFFFFFFF);
	//Show ship slots
	for(uint i=0;i<8;i++){
		sl[i].put();
		if(sl[i].isPressed() && sl[i].isMod()){
			Module@ mod = sl[i].getMod();
			if(mod.getSprite()!=""){
					if(mod.getEffect()=="hp"){
						ETHEntity@ pl = SeekEntity("player.ent");
						if(pl.GetFloat("hp")>mod.getEffectCount()){
							pl.SetFloat("hp",pl.GetFloat("hp")-mod.getEffectCount());
						}
						pl.SetFloat("max_hp",pl.GetFloat("max_hp")-mod.getEffectCount());
					}
					if(mod.getEffect()=="sh"){
						ETHEntity@ pl = SeekEntity("player.ent");
						if(pl.GetFloat("shield")>mod.getEffectCount()){
							pl.SetFloat("shield",pl.GetFloat("shield")-mod.getEffectCount());
						}
						pl.SetFloat("max_sh",pl.GetFloat("max_sh")-mod.getEffectCount());
					}
					if(mod.getEffect()=="dmg"){
						ETHEntity@ pl = SeekEntity("player.ent");
						pl.SetFloat("min_damage",pl.GetFloat("min_damage")-mod.getEffectCount());
						pl.SetFloat("max_damage",pl.GetFloat("max_damage")-mod.getEffectCount());
					}
			}
			sl[i].deleteMod();
			sl[i].setPressed(false);
		}
	}
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
				sl[smod].setMod(sl_shop[i].getMod());
				Module mod = sl[smod].getMod();
				if(mod.getSprite()!=""){
						if(mod.getEffect()=="hp"){
							ETHEntity@ pl = SeekEntity("player.ent");
							pl.SetFloat("hp",pl.GetFloat("hp")+mod.getEffectCount());
							pl.SetFloat("max_hp",pl.GetFloat("max_hp")+mod.getEffectCount());
						}
						if(mod.getEffect()=="sh"){
							ETHEntity@ pl = SeekEntity("player.ent");
							pl.SetFloat("shield",pl.GetFloat("shield")+mod.getEffectCount());
							pl.SetFloat("max_sh",pl.GetFloat("max_sh")+mod.getEffectCount());
						}
						if(mod.getEffect()=="dmg"){
							ETHEntity@ pl = SeekEntity("player.ent");
							pl.SetFloat("min_damage",pl.GetFloat("min_damage")+mod.getEffectCount());
							pl.SetFloat("max_damage",pl.GetFloat("max_damage")+mod.getEffectCount());
						}
				}
			}else{
				print("smod = -1");
			}
			sl_shop[i].setPressed(false);
		}
	}
	//
	ret.putButton();
	if(ret.isPressed()){
		shop = false;
		pause = true;
	}
}