#include "main.angelscript"
#include "shop.angelscript"
#include "Slot.angelscript"
#include "Module.angelscript"
#include "Button.angelscript"
void showShipSlots(){
	DrawText(GetScreenSize() * vector2(0.11f, 0.58f), "Ship storage:", "Verdana20_shadow.fnt", 0xFFFFFFFF);
	//Show ship slots
	for(uint i=0;i<8;i++){
		sl[i].put();
		showDesc(sl[i]);
		if(sl[i].isPressed() && sl[i].isMod() && !ship){
			sl[i].deleteMod();
			sl[i].setPressed(false);
		}else{
			//Ship
			if(sl[i].isPressed()){
				Module@ mod = sl[i].getMod();
				for(int i2=0;i2<6;i2++){
					if(!slotShip[i2].isMod() && slotShip[i2].getType() == mod.getType()){
						slotShip[i2].setMod(mod);
						if(mod.getSprite()!=""){
							ETHEntity@ pl = SeekEntity("player.ent");
							if(mod.getEffect()=="hp"){
								pl.SetFloat("hp",pl.GetFloat("hp")+mod.getEffectCount());
								pl.SetFloat("max_hp",pl.GetFloat("max_hp")+mod.getEffectCount());
							}
							if(mod.getEffect()=="sh"){
								pl.SetFloat("shield",pl.GetFloat("shield")+mod.getEffectCount());
								pl.SetFloat("max_sh",pl.GetFloat("max_sh")+mod.getEffectCount());
							}
							if(mod.getEffect()=="dmg"){
								pl.SetFloat("min_damage",pl.GetFloat("min_damage")+mod.getEffectCount());
								pl.SetFloat("max_damage",pl.GetFloat("max_damage")+mod.getEffectCount());
							}
						}
						sl[i].deleteMod();
						break;
					}
				}
				sl[i].setPressed(false);
			}
			//
		}
	}
	//
}

Button@ retShip;
ETHEntity@ pl;
array<SlotShip@> slotShip(6);

void initShip(){
	int type = 1;
	for(uint i=0;i<6;i++){
		float x = 0.4f , y = 0.2f;
		if(i==1){
			x = 0.4f;
			y = 0.3f;
		}
		if(i==2){
			x = 0.5f;
			y = 0.2f;
			type++;
		}
		if(i==3){
			x = 0.5f;
			y = 0.3f;
		}
		if(i==4){
			x = 0.6f;
			y = 0.2f;
			type++;
		}
		if(i==5){
			x = 0.6f;
			y = 0.3f;
		}
		vector2 Pos(GetScreenSize() * vector2(x, y));
		@slotShip[i] = SlotShip(type, Pos);
	}
}

void startShip(){
	vector2 retShipButtonPos(GetScreenSize() * vector2(0.75f, 0.8f));
	@retShip = Button("sprites/shop.png", retShipButtonPos);
}

void loopShip(){
	//Show ship slots
	for(uint i=0;i<6;i++){
		slotShip[i].put();
		showDesc(slotShip[i]);
		if(slotShip[i].isPressed()){
			int smod = -1;
			for(uint i2=0;i2<8;i2++){
				if(!sl[i2].isMod()){
					smod = i2;
					break;
				}
			}
			if(smod!=-1){
				sl[smod].setMod(slotShip[i].getMod());
			}else{
				print("smod = -1");
			}
			Module@ mod = slotShip[i].getMod();
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
			slotShip[i].deleteMod();
			slotShip[i].setPressed(false);
		}
	}
	//
	@pl = SeekEntity("player.ent");
	DrawText(GetScreenSize() * vector2(0.10f, 0.15f), "Ship stats:", "Verdana24_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.20f), "Max_hp:"+pl.GetFloat("max_hp"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.25f), "Max_sh:"+pl.GetFloat("max_sh"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.30f), "Min_damage:"+pl.GetFloat("min_damage"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.35f), "Max_damage:"+pl.GetFloat("max_damage"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	showShipSlots();
	retShip.putButton();
	if(retShip.isPressed()){
		ship = false;
		shop = true;
	}
}