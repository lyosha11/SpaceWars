#include "eth_util.angelscript"
#include "main.angelscript"
#include "pause.angelscript"

//DEBUG
bool debug = true;
//

bool collision(ETHEntity@ obj1, ETHEntity@ obj2){
	float pos = sqrt(pow(obj1.GetPositionX()-obj2.GetPositionX(),2)+pow(obj1.GetPositionY()-obj2.GetPositionY(),2));
	if(obj1.GetFloat("radius")+obj2.GetFloat("radius") >= pos){
		return true;
	}
	return false;
}

bool ai_tmp_fire;

bool fireAI(ETHEntity@ obj){
	int rnd = rand(1,100);
	if(rnd==1){
		if(obj.GetInt("type")>4 && obj.GetInt("type")<9){
			vector3 tmp = obj.GetPosition();
			if(ai_tmp_fire){
				tmp.x = tmp.x - 60;
			}else{
				tmp.x = tmp.x + 60;
			}
			int id = AddEntity("shot2.ent",tmp);
			PlaySample("soundfx/shoot2.mp3");
			insertBullet(SeekEntity(id));
			if(ai_tmp_fire)
				ai_tmp_fire = false;
			else
				ai_tmp_fire = true;
			return true;
		}
		vector3 tmp = obj.GetPosition();
		int id = AddEntity("shot2.ent",tmp);
		PlaySample("soundfx/shoot2.mp3");
		insertBullet(SeekEntity(id));
		return true;
	}
	return false;
}

ETHEntityArray enemys , bullets , eff, bonus;
bool alivePlayer = true;
int counter = 0;

void insertBullet(ETHEntity@ obj){
	bullets.Insert(obj);
}

void init(int level){
	//Delete bullets and effects
	if(bullets.Size()>0){
		for(uint i=0;i<bullets.Size();i++){
			DeleteEntity(bullets[i]);
		}
	}
	if(eff.Size()>0){
		for(uint i=0;i<eff.Size();i++){
			DeleteEntity(eff[i]);
		}
	}
	//
	
	//Start (1-level)
	if(level==1){
		ETHEntity@ pl = SeekEntity("player.ent");
		pl.SetFloat("hp",500);
		pl.SetFloat("shield",100);
		alivePlayer = true;
		//LOAD SOUNDS
		LoadSoundEffect("soundfx/shoot.mp3");
		LoadSoundEffect("soundfx/shoot2.mp3");
		LoadSoundEffect("soundfx/shootRocket1.mp3");
		LoadSoundEffect("soundfx/bonusPickUp.mp3");
		//
		//Random background
		vector2 vc2 = GetScreenSize() * vector2(0.5f, 0.5f);
		vector3 center(vc2.x,vc2.y,0);
		AddEntity("background"+rand(1,4)+".ent",center,"background");
		//
	}
	//
	
	int size = changeLevel(level);
	for(int i=0;i<size;i++){
		ETHEntity@ obj = SeekEntity("enemy"+i);
		enemys.Insert(obj);
	}
}

void loop(int level){
	if(!pause){
		//Sizes
		const uint numEnemys = enemys.Size();
		const uint numBullets = bullets.Size();
		const uint numEff = eff.Size();
		const uint numBonus = bonus.Size();
		//
		//Text
		DrawText(GetScreenSize() * vector2(0.02f, 0.84f), "Level: "+level, "Verdana20_shadow.fnt", 0xFFFFFFFF);
		DrawText(GetScreenSize() * vector2(0.02f, 0.80f), "Rockets: "+rockets, "Verdana20_shadow.fnt", 0xFFFFFFFF);
		if(debug){
			DrawText(vector2(0, 0), "FPS: "+GetFPSRate(), "Verdana20.fnt", 0xFFFFFFFF);
			DrawText(vector2(0,15), "enemys.Size(): "+numEnemys, "Verdana20.fnt", 0xFFFFFFFF);
			DrawText(vector2(0,30), "bullets.Size(): "+numBullets, "Verdana20.fnt", 0xFFFFFFFF);
			DrawText(vector2(0,45), "eff.Size(): "+numEff, "Verdana20.fnt", 0xFFFFFFFF);
		}
		//
		//collision bullets
		for (uint i = 0; i < numEnemys; i++){
			for (uint i2 = 0; i2 < numBullets; i2++){
				if(bullets[i2].GetInt("type")!=1 && bullets[i2].GetInt("type")!=3)
					continue;
				if(collision(@enemys[i],@bullets[i2])){
						if(bullets[i2].GetInt("type")==1){
							enemys[i].SetFloat("hp",enemys[i].GetFloat("hp")-rand(8,16));
						}
						if(bullets[i2].GetInt("type")==3){
							enemys[i].SetFloat("hp",enemys[i].GetFloat("hp")-rand(16,32));
						}
						if(enemys[i].GetFloat("hp")<=0){
							int id = AddEntity("eff2.ent",enemys[i].GetPosition());
							eff.Insert(SeekEntity(id));
							DeleteEntity(enemys[i]);
							DeleteEntity(bullets[i2]);
							break;
						}else{
							int id = AddEntity("eff1.ent",bullets[i2].GetPosition());
							eff.Insert(SeekEntity(id));
							DeleteEntity(bullets[i2]);
							break;
						}
				}
			}
			//Показ хп врагов
			if(debug && enemys[i].GetFloat("hp")>0){
				vector3 vc3 = enemys[i].GetPosition();
				vector2 vc(vc3.x,vc3.y);
				vc.y = vc.y - enemys[i].GetFloat("radius");
				vc.x = vc.x - enemys[i].GetFloat("radius");
				DrawText(vc,"hp:"+enemys[i].GetFloat("hp"), "Verdana20.fnt", 0xFFFFFFFF);
			}
		}
		//
		
		//Player colision
		if(alivePlayer){
			ETHEntity@ pl = SeekEntity("player.ent");
			//SHIELD REGEN
			if(pl.GetFloat("shield")<100){
				if(counter%100==0){
					pl.SetFloat("shield",pl.GetFloat("shield")+1);
				}
			}
			//
			DrawText(vector2(20,100), "hp: "+pl.GetFloat("hp"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
			DrawText(vector2(20,115), "sh: "+pl.GetFloat("shield"), "Verdana20_shadow.fnt", 0xFFFFFFFF);
			for (uint i2 = 0; i2 < numBullets; i2++){
				if(bullets[i2].GetInt("type")!=2)
					continue;
					if(collision(@pl,@bullets[i2]) && !bullets[i2].IsHidden() && bullets[i2].GetInt("type")==2){
							float damage = rand(8,16);
							if(pl.GetFloat("shield")>=damage){
								pl.SetFloat("shield",pl.GetFloat("shield")-damage);
								int id = AddEntity("shPlayerEff.ent",bullets[i2].GetPosition());
								eff.Insert(SeekEntity(id));
								DeleteEntity(bullets[i2]);
								break;
							}else{
								pl.SetFloat("hp",pl.GetFloat("hp")-damage);
								if(pl.GetFloat("hp")<=0){
									int id = AddEntity("eff2.ent",pl.GetPosition());
									eff.Insert(SeekEntity(id));
									pl.Hide(true);
									alivePlayer = false;
									DeleteEntity(bullets[i2]);
									break;
								}else{
									int id = AddEntity("eff1.ent",bullets[i2].GetPosition());
									eff.Insert(SeekEntity(id));
									DeleteEntity(bullets[i2]);
									break;
								}
							}
					}
			}
			//Bonus collision
			if(numBonus>0){
				for(uint i=0;i<numBonus;i++){
					if(collision(pl,bonus[i])){
						rockets = rockets + 20;
						DeleteEntity(bonus[i]);
						PlaySample("soundfx/bonusPickUp.mp3");
					}
				}
			}
			//
		}else{
			DrawText(vector2(20,100), "hp: DEAD", "Verdana20.fnt", 0xFFFFFFFF);
		}
		//Refresh effects
		for (uint i = 0; i < numEff; i++){
			if(eff[i].GetInt("eff")==1){
				if(eff[i].GetInt("out")<=0){
					switch(eff[i].GetInt("status")){
						case 1:
						eff[i].SetSprite("2b.png");
						break;
						case 2:
						eff[i].SetSprite("3b.png");
						break;
						case 3:
						eff[i].SetSprite("4b.png");
						break;
						case 4:
						eff[i].SetSprite("5b.png");
						break;
						case 5:
						eff[i].SetSprite("6b.png");
						break;
						default:
						DeleteEntity(eff[i]);
					}
					eff[i].SetInt("out",5);
					eff[i].SetInt("status",eff[i].GetInt("status")+1);
				}
			}
			if(eff[i].GetInt("eff")==2){
				if(eff[i].GetInt("out")<=0){
					switch(eff[i].GetInt("status")){
						case 1:
						eff[i].SetSprite("2d.png");
						break;
						case 2:
						eff[i].SetSprite("3d.png");
						break;
						case 3:
						eff[i].SetSprite("4d.png");
						break;
						case 4:
						eff[i].SetSprite("5d.png");
						break;
						case 5:
						eff[i].SetSprite("6d.png");
						break;
						case 6:
						eff[i].SetSprite("7d.png");
						break;
						case 7:
						eff[i].SetSprite("8d.png");
						break;
						case 8:
						eff[i].SetSprite("9d.png");
						break;
						default:
						DeleteEntity(eff[i]);
					}
					eff[i].SetInt("out",4);
					eff[i].SetInt("status",eff[i].GetInt("status")+1);
				}
			}
			if(eff[i].GetInt("eff")==99){
				if(eff[i].GetInt("status")<=0){
					DeleteEntity(eff[i]);
				}else{
					eff[i].SetInt("status",eff[i].GetInt("status")-1);
				}
				break;
			}
			eff[i].SetInt("out",eff[i].GetInt("out")-1);
		}
		//
		//ai
		for (uint i = 0; i < numEnemys; i++){
			if(enemys[i].IsAlive()){
				if(debug)
					DrawText(vector2(0,90+i*15), "ai_move_count("+i+"): "+enemys[i].GetInt("ai_move_count"), "Verdana20.fnt", 0xFFFFFFFF);
				if(enemys[i].GetInt("ai_move_count") >= enemys[i].GetInt("ai_max_move_count")){
					enemys[i].SetInt("ai_move_type",rand(1,8));
					enemys[i].SetInt("ai_min_long",rand(1,2));
					enemys[i].SetInt("ai_max_long",rand(2,6));
					enemys[i].SetInt("ai_move_count",0);
				}else{
					float long = rand(enemys[i].GetInt("ai_min_long") , enemys[i].GetInt("ai_max_long"));
					switch(enemys[i].GetInt("ai_move_type")){
						case 1:
						if(enemys[i].GetPositionX()<=950){
							enemys[i].AddToPositionXY(vector2(long,0.0f));
						}else{
							enemys[i].SetInt("ai_move_type",2);
							enemys[i].AddToPositionXY(vector2(-long,0.0f));
						}
						break;
						case 2:
						if(enemys[i].GetPositionX()>=240){
							enemys[i].AddToPositionXY(vector2(-long,0.0f));
						}else{
							enemys[i].SetInt("ai_move_type",1);
							enemys[i].AddToPositionXY(vector2(long,0.0f));
						}
						break;
						case 3:
						if(enemys[i].GetPositionY()<=610){
							enemys[i].AddToPositionXY(vector2(0.0f,long));
						}else{
							enemys[i].SetInt("ai_move_type",4);
							enemys[i].AddToPositionXY(vector2(0.0f,-long));
						}
						break;
						case 4:
						if(enemys[i].GetPositionY()>=70){
							enemys[i].AddToPositionXY(vector2(0.0f,-long));
						}else{
							enemys[i].SetInt("ai_move_type",3);
							enemys[i].AddToPositionXY(vector2(0.0f,long));
						}
						break;
						case 5:
						if(enemys[i].GetPositionX()<=950 && enemys[i].GetPositionX()>=240 && enemys[i].GetPositionY()<=610 && enemys[i].GetPositionY()>=70){
							enemys[i].SetPositionXY(vector2(enemys[i].GetPositionX() - tan(enemys[i].GetPositionY())/4000 + long,enemys[i].GetPositionY() - tan(enemys[i].GetPositionX())/4000 + long));
						}
						break;
						case 6:
						if(enemys[i].GetPositionX()<=950 && enemys[i].GetPositionX()>=240 && enemys[i].GetPositionY()<=610 && enemys[i].GetPositionY()>=70){
							enemys[i].SetPositionXY(vector2(enemys[i].GetPositionX() - tan(enemys[i].GetPositionY())/4000 - long,enemys[i].GetPositionY() - tan(enemys[i].GetPositionX())/4000 - long));
						}
						break;
						case 7:
						if(enemys[i].GetPositionX()<=950 && enemys[i].GetPositionX()>=240 && enemys[i].GetPositionY()<=610 && enemys[i].GetPositionY()>=70){
							enemys[i].SetPositionXY(vector2(enemys[i].GetPositionX() - tan(enemys[i].GetPositionY())/4000 + long,enemys[i].GetPositionY() - tan(enemys[i].GetPositionX())/4000 - long));
						}
						break;
						case 8:
						if(enemys[i].GetPositionX()<=950 && enemys[i].GetPositionX()>=240 && enemys[i].GetPositionY()<=610 && enemys[i].GetPositionY()>=70){
							enemys[i].SetPositionXY(vector2(enemys[i].GetPositionX() - tan(enemys[i].GetPositionY())/4000 - long,enemys[i].GetPositionY() - tan(enemys[i].GetPositionX())/4000 + long));
						}
						break;
					}
				}
				enemys[i].SetInt("ai_move_count",enemys[i].GetInt("ai_move_count")+1);
			}
			fireAI(enemys[i]);
		}
		//RemoveDead
		enemys.RemoveDeadEntities();
		bullets.RemoveDeadEntities();
		eff.RemoveDeadEntities();
		bonus.RemoveDeadEntities();
		//
		if(debug){
			DrawText(vector2(0,60), "RemoveDeadEntities(): true", "Verdana20.fnt", 0xFFFFFFFF);
		}
		//CHANGE LEVEL
		if(numEnemys<=0){
			startPause();
			addLevel();
			init(++level);
		}
		//
		
		//Random bonus
		uint rnd = rand(1,1000);
		if(rnd==1){
			rnd = rand(1,1);
			if(rnd==1){
				uint id = AddEntity("bonus_rocket.ent",vector3(rand(10,760),-10,0));
				bonus.Insert(SeekEntity(id));
			}else{
				//Bonus2
			}
		}
		//
		
		//COUNTER
		counter++;
		if(counter>999999)
			counter = 0;
		//
	}else{
		loopPause();
	}
}

