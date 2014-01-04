#include "game.angelscript"

int changeLevel(int level){
	array<int> id(6);
	float x, y;
	int size=0;
	switch(level){
		case 1:
			x=180;
			y=50;
			for(int i=0;i<6;i++){
				x=x+100;
				if(i==0 || i==5){
					id[i] = AddEntity("enemy2.ent", vector3(x, y, 0.0f),"enemy"+i);
				}else{
					id[i] = AddEntity("enemy1.ent", vector3(x, y, 0.0f),"enemy"+i);
				}
				ETHEntity @enemy = SeekEntity(id[i]);
				enemy.SetFloat("hp", 100.0f);
			}
			size = 6;
		break;
		case 2:
			x=180;
			y=50;
			for(int i=0;i<6;i++){
				x=x+100;
				if(i<3){
					id[i] = AddEntity("enemy3.ent", vector3(x, y, 0.0f),"enemy"+i);
					ETHEntity @enemy = SeekEntity(id[i]);
					enemy.SetFloat("hp", 100.0f);
				}else{
					id[i] = AddEntity("enemy4.ent", vector3(x, y, 0.0f),"enemy"+i);
					ETHEntity @enemy = SeekEntity(id[i]);
					enemy.SetFloat("hp", 100.0f);
				}	
			}
			size = 6;
		break;
		case 3:
			x=280;
			y=50;
			x=x+100;
			for(int i=0;i<3;i++){
				x=x+100;
				if(i==0){
					id[i] = AddEntity("enemy2.ent", vector3(x, y, 0.0f),"enemy"+i);
					ETHEntity @enemy = SeekEntity(id[0]);
					enemy.SetFloat("hp", 100.0f);
				}if(i==1){
					id[i] = AddEntity("enemyBig1.ent", vector3(x, y, 0.0f),"enemy"+i);
					ETHEntity @enemy = SeekEntity(id[1]);
					enemy.SetFloat("hp", 500.0f);
				}if(i==2){
				x=x+100;
					id[i] = AddEntity("enemy4.ent", vector3(x, y, 0.0f),"enemy"+i);
					ETHEntity @enemy = SeekEntity(id[2]);
					enemy.SetFloat("hp", 100.0f);
				}
			}
			size = 3;
		break;
		default:
			print("level not found");
	}
	return size;
}