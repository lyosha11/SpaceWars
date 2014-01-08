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
		if(sl[i].isPressed() && sl[i].isMod() && !ship){
			Module mod = sl[i].getMod();
			sl[i].deleteMod();
			pl.SetInt("money",pl.GetInt("money")+mod.getPrice());
			sl[i].setPressed(false);
		}else{
			//Ship
			if(sl[i].isPressed()){
				Module@ mod = @sl[i].getMod();
				for(uint i2=0;i2<count_slot;i2++){
					if(!slotShip[i2].isMod() && slotShip[i2].getType() == mod.getType()){
						slotShip[i2].setMod(mod);
						if(mod.getSprite()!=""){
							ETHEntity@ pl = SeekEntity("player.ent");
							if(mod.getEffect()=="hp"){
								pl.SetFloat("hp",pl.GetFloat("hp")+mod.getStatus());
								pl.SetFloat("max_hp",pl.GetFloat("max_hp")+mod.getEffectCount());
							}
							if(mod.getEffect()=="sh"){
								pl.SetFloat("shield",pl.GetFloat("shield")+mod.getStatus());
								pl.SetFloat("max_sh",pl.GetFloat("max_sh")+mod.getEffectCount());
							}
							if(mod.getEffect()=="dmg"){
								pl.SetFloat("min_damage",pl.GetFloat("min_damage")+mod.getEffectCount());
								pl.SetFloat("max_damage",pl.GetFloat("max_damage")+mod.getEffectCount());
							}
							if(mod.getEffect()=="en"){
								pl.SetFloat("en",pl.GetFloat("en")+mod.getStatus());
								pl.SetFloat("max_en",pl.GetFloat("max_en")+mod.getEffectCount());
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
	//Show money
	ETHEntity@ pl = SeekEntity("player.ent");
	DrawText(GetScreenSize() * vector2(0.11f, 0.76f), "Money: "+pl.GetInt("money"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	//Description
	for(uint i=0;i<8;i++)
		showDesc(sl[i]);
}

Button@ retShip, charging;
ETHEntity@ pl;
array<SlotShip@> slotShip(7);
uint count_slot = 7;

void initShip(){
	int type = 1;
	for(uint i=0;i<count_slot;i++){
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
		if(i==6){
			x = 0.5f;
			y = 0.4f;
			type++;
		}
		vector2 Pos(GetScreenSize() * vector2(x, y));
		@slotShip[i] = SlotShip("sprites/modules/slotShip"+type+".png",type, Pos);
	}
	//Standart items
	slotShip[0].setMod(Module("Corpus","Standart armor corpus.",1,"sprites/modules/std_crp.png","hp",500,0));
	slotShip[2].setMod(Module("Shield","Standart shield.",2,"sprites/modules/std_sh.png","sh",100,0));
	slotShip[4].setMod(Module("Weapon","Standart laser weapon.",3,"sprites/modules/std_dmg.png","dmg",7,0,"shot.ent"));
	slotShip[6].setMod(Module("Battery","Standart battery.",4,"sprites/modules/std_en.png","en",100,0));
	//
}

void startShip(){
	vector2 retShipButtonPos(GetScreenSize() * vector2(0.75f, 0.8f));
	@retShip = Button("sprites/shop.png", retShipButtonPos);
	vector2 chargingShipButtonPos(GetScreenSize() * vector2(0.75f, 0.5f));
	@charging = Button("sprites/charging.png", chargingShipButtonPos);
}

void loopShip(){
	//Show ship slots
	for(uint i=0;i<count_slot;i++){
		slotShip[i].put();
		if(slotShip[i].isPressed()){
			int smod = -1;
			for(uint i2=0;i2<8;i2++){
				if(!sl[i2].isMod()){
					smod = i2;
					break;
				}
			}
			if(smod!=-1){
				Module@ mod = slotShip[i].getMod();
						if(mod.getSprite()!=""){
							ETHEntity@ pl = SeekEntity("player.ent");
							if(mod.getEffect()=="hp"){
								if(pl.GetFloat("hp")<=mod.getEffectCount()){
									mod.setStatus(pl.GetFloat("hp"));
								}else{
									mod.setStatus(mod.getEffectCount());
								}
								pl.SetFloat("hp",pl.GetFloat("hp")-mod.getStatus());
								pl.SetFloat("max_hp",pl.GetFloat("max_hp")-mod.getEffectCount());
							}
							if(mod.getEffect()=="sh"){
								if(pl.GetFloat("shield")<=mod.getEffectCount()){
									mod.setStatus(pl.GetFloat("shield"));
								}else{
									mod.setStatus(mod.getEffectCount());
								}
								pl.SetFloat("shield",pl.GetFloat("shield")-mod.getStatus());
								pl.SetFloat("max_sh",pl.GetFloat("max_sh")-mod.getEffectCount());
							}
							if(mod.getEffect()=="dmg"){
								pl.SetFloat("min_damage",pl.GetFloat("min_damage")-mod.getEffectCount());
								pl.SetFloat("max_damage",pl.GetFloat("max_damage")-mod.getEffectCount());
							}
							if(mod.getEffect()=="en"){
								if(pl.GetFloat("en")<=mod.getEffectCount()){
									mod.setStatus(pl.GetFloat("en"));
								}else{
									mod.setStatus(mod.getEffectCount());
								}
								pl.SetFloat("en",pl.GetFloat("en")-mod.getStatus());
								pl.SetFloat("max_en",pl.GetFloat("max_en")-mod.getEffectCount());
							}
						}
			//Set price to status
			if(mod.getType()!=3){
				mod.setPrice((mod.getStatus() / mod.getEffectCount()) * mod.getMaxPrice());
			}
			//
			sl[smod].setMod(slotShip[i].getMod());
			slotShip[i].deleteMod();
			}else{
				print("smod = -1");
			}
			slotShip[i].setPressed(false);
		}
	}
	//
	@pl = SeekEntity("player.ent");
	DrawText(GetScreenSize() * vector2(0.10f, 0.15f), "Ship stats:", "Verdana24_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.20f), "hp:"+pl.GetFloat("hp")+"/"+pl.GetFloat("max_hp"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.25f), "sh:"+pl.GetFloat("shield")+"/"+pl.GetFloat("max_sh"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.30f), "en:"+pl.GetFloat("en")+"/"+pl.GetFloat("max_en"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.35f), "Min_damage:"+pl.GetFloat("min_damage"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	DrawText(GetScreenSize() * vector2(0.10f, 0.40f), "Max_damage:"+pl.GetFloat("max_damage"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	//Buttons
	retShip.putButton();
	charging.putButton();
	if(retShip.isPressed()){
		ship = false;
		shop = true;
	}
	Module@ mod = slotShip[6].getMod();
	int pr = (mod.getEffectCount() - pl.GetFloat("en")) * 2;
	if(charging.isPressed()){
		int slt = 6;
		if(pl.GetFloat("en")<mod.getEffectCount()){
			if(pl.GetInt("money")>=pr){
				pl.SetFloat("en",mod.getEffectCount());
				pl.SetInt("money",pl.GetInt("money")-pr);
			}
		}
		charging.setPressed(false);
	}
	DrawText(GetScreenSize() * vector2(0.75f, 0.49f), "Price:"+pr, "Verdana20_shadow.fnt", 0xFFFFFFFF);
	//
	showShipSlots();
	//Description
	for(uint i=0;i<count_slot;i++)
		showDesc(slotShip[i], false);
}