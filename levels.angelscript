#include "game.angelscript"

void newEnemy(int id, string enemy,float hp, vector3 pos){
	id = AddEntity(enemy, pos,"enemy"+id);
	ETHEntity @en = SeekEntity(id);
	en.SetFloat("hp", hp);
}

int changeLevel(int level){
	float x, y;
	int size=0 , rnd=0;
	switch(level){
		case 1:
			newEnemy(0,"enemy2.ent",100,vector3(200,50,0));
			newEnemy(1,"enemy1.ent",100,vector3(300,50,0));
			newEnemy(2,"enemy1.ent",100,vector3(400,50,0));
			newEnemy(3,"enemy1.ent",100,vector3(500,50,0));
			newEnemy(4,"enemy1.ent",100,vector3(600,50,0));
			newEnemy(5,"enemy2.ent",100,vector3(700,50,0));
			size = 6;
		break;
		case 2:
			newEnemy(0,"enemy3.ent",100,vector3(200,50,0));
			newEnemy(1,"enemy3.ent",100,vector3(300,50,0));
			newEnemy(2,"enemy3.ent",100,vector3(400,50,0));
			newEnemy(3,"enemy4.ent",100,vector3(500,50,0));
			newEnemy(4,"enemy4.ent",100,vector3(600,50,0));
			newEnemy(5,"enemy4.ent",100,vector3(700,50,0));
			size = 6;
		break;
		case 3:
			newEnemy(0,"enemy2.ent",100,vector3(300,50,0));
			newEnemy(1,"enemyBig1.ent",500,vector3(400,50,0));
			newEnemy(2,"enemy4.ent",100,vector3(500,50,0));
			size = 3;
		break;
		case 4:
			newEnemy(0,"enemy2.ent",100,vector3(200,50,0));
			newEnemy(1,"enemy1.ent",100,vector3(300,50,0));
			newEnemy(2,"enemy1.ent",100,vector3(400,50,0));
			newEnemy(3,"enemy1.ent",100,vector3(500,50,0));
			newEnemy(4,"enemy1.ent",100,vector3(600,50,0));
			newEnemy(5,"enemy2.ent",100,vector3(700,50,0));
			size = 6;
		break;
		case 5:
			newEnemy(0,"enemy3.ent",100,vector3(200,50,0));
			newEnemy(1,"enemy3.ent",100,vector3(300,50,0));
			newEnemy(2,"enemy3.ent",100,vector3(400,50,0));
			newEnemy(3,"enemy4.ent",100,vector3(500,50,0));
			newEnemy(4,"enemy4.ent",100,vector3(600,50,0));
			newEnemy(5,"enemy4.ent",100,vector3(700,50,0));
			size = 6;
		break;
		case 6:
			newEnemy(0,"enemy1.ent",100,vector3(300,50,0));
			newEnemy(1,"enemyBig2.ent",500,vector3(400,50,0));
			newEnemy(2,"enemy3.ent",100,vector3(500,50,0));
			size = 3;
		break;
		case 7:
			newEnemy(0,"enemy1.ent",100,vector3(200,50,0));
			newEnemy(1,"enemy1.ent",100,vector3(300,50,0));
			newEnemy(2,"enemy1.ent",100,vector3(400,50,0));
			newEnemy(3,"enemy1.ent",100,vector3(500,50,0));
			newEnemy(4,"enemy1.ent",100,vector3(600,50,0));
			newEnemy(5,"enemy3.ent",100,vector3(200,150,0));
			newEnemy(6,"enemy3.ent",100,vector3(300,150,0));
			newEnemy(7,"enemy3.ent",100,vector3(400,150,0));
			newEnemy(8,"enemy3.ent",100,vector3(500,150,0));
			newEnemy(9,"enemy3.ent",100,vector3(600,150,0));
			size = 10;
		break;
		case 8:
			newEnemy(0,"enemy3.ent",100,vector3(200,50,0));
			newEnemy(1,"enemy3.ent",100,vector3(300,50,0));
			newEnemy(2,"enemy3.ent",100,vector3(400,50,0));
			newEnemy(3,"enemy4.ent",100,vector3(500,50,0));
			newEnemy(4,"enemy4.ent",100,vector3(600,50,0));
			newEnemy(5,"enemy4.ent",100,vector3(700,50,0));
			newEnemy(6,"enemy3.ent",100,vector3(200,150,0));
			newEnemy(7,"enemy3.ent",100,vector3(300,150,0));
			newEnemy(8,"enemy3.ent",100,vector3(400,150,0));
			newEnemy(9,"enemy4.ent",100,vector3(500,150,0));
			newEnemy(10,"enemy4.ent",100,vector3(600,150,0));
			newEnemy(11,"enemy4.ent",100,vector3(700,150,0));
			size = 12;
		break;
		case 9:
			newEnemy(0,"enemy1.ent",100,vector3(200,50,0));
			newEnemy(1,"enemy1.ent",100,vector3(300,50,0));
			newEnemy(2,"enemy1.ent",100,vector3(400,50,0));
			newEnemy(3,"enemy2.ent",100,vector3(500,50,0));
			newEnemy(4,"enemy2.ent",100,vector3(600,50,0));
			newEnemy(5,"enemy2.ent",100,vector3(700,50,0));
			newEnemy(6,"enemy1.ent",100,vector3(200,150,0));
			newEnemy(7,"enemy1.ent",100,vector3(300,150,0));
			newEnemy(8,"enemy1.ent",100,vector3(400,150,0));
			newEnemy(9,"enemy2.ent",100,vector3(500,150,0));
			newEnemy(10,"enemy2.ent",100,vector3(600,150,0));
			newEnemy(11,"enemy2.ent",100,vector3(700,150,0));
			size = 12;
		break;
		case 10:
			newEnemy(0,"enemyBig1.ent",500,vector3(400,100,0));
			newEnemy(1,"enemyBig1.ent",500,vector3(500,100,0));
			newEnemy(2,"enemyBig2.ent",500,vector3(600,100,0));
			newEnemy(3,"enemyBig2.ent",500,vector3(700,100,0));
			newEnemy(4,"enemyBig1.ent",500,vector3(400,200,0));
			newEnemy(5,"enemyBig1.ent",500,vector3(500,200,0));
			newEnemy(6,"enemyBig2.ent",500,vector3(600,200,0));
			newEnemy(7,"enemyBig2.ent",500,vector3(700,200,0));
			size = 8;
		break;
		default:
			x = GetScreenSize().x/2;
			y = 80;
			rnd = rand(1,8);
			if(rnd<=4){
				int id = AddEntity("enemy"+rnd+".ent", vector3(x, y, 0.0f),"enemy0");
				ETHEntity @enemy = SeekEntity(id);
				enemy.SetFloat("hp", 100.0f+enemyMaxDamage+enemyMinDamage);
			}
			if(rnd<=8 && rnd>=5){
				rnd = rnd-4;
				int id = AddEntity("enemyBig"+rnd+".ent", vector3(x, y, 0.0f),"enemy0");
				ETHEntity @enemy = SeekEntity(id);
				enemy.SetFloat("hp", 500.0f+enemyMaxDamage+enemyMinDamage);
			}
			size = 1;
	}
	return size;
}