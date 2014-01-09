#include "eth_util.angelscript"
#include "Button.angelscript"
#include "game.angelscript"
#include "levels.angelscript"
#include "hud.angelscript"
#include "shop.angelscript"
#include "ship.angelscript"

int level , rockets;
bool pause = false;
bool shop = false;
bool ship = false;

void loadStartScene(){
	HideCursor(false);
	level=0;
	LoadScene("scenes/menu.esc", "createStartScene", "updateStartScene");
}

void loadOptionsScene(){
	HideCursor(false);
	LoadScene("scenes/options.esc", "createOptionsScene", "updateOptionsScene");
}

void loadGameScene(string name_scene){
	HideCursor(true);
	level++;
	rockets = 100;
	LoadScene("scenes/"+name_scene+".esc", "createGameScene", "updateGameScene");
}
/*****************************************************
        Starting scene
*****************************************************/
void main(){
	loadStartScene();
	SetWindowProperties(
        "Space Wars", // window title
         1024, 768,       // screen size
         false,            // true=windowed / false=fullscreen
         true,            // true=enable vsync false=disable vsync
         PF32BIT);        // color format
}

Button@ g_startGameButton , g_exitGameButton , g_optionsGameButton;

void createStartScene(){
	vector2 startButtonPos(GetScreenSize() * vector2(0.5f, 0.50f));
	vector2 optionsButtonPos(GetScreenSize() * vector2(0.5f, 0.70f));
	vector2 exitButtonPos(GetScreenSize() * vector2(0.5f, 0.90f));
	@g_startGameButton = Button("sprites/start_game.png", startButtonPos);
	@g_optionsGameButton = Button("sprites/options_game.png", optionsButtonPos);
	@g_exitGameButton = Button("sprites/exit_game.png", exitButtonPos);
	//LOADING MUSIC
	
	//LoadMusic("soundfx/soundtrack.mp3");
	//LoopSample("soundfx/soundtrack.mp3",true);
	//PlaySample("soundfx/soundtrack.mp3");
	
	//
}

void updateStartScene(){
	// draw and check button
	g_startGameButton.putButton();
	g_optionsGameButton.putButton();
	g_exitGameButton.putButton();
	if (g_startGameButton.isPressed()){
		loadGameScene("level");
	}
	if (g_optionsGameButton.isPressed()){
		loadOptionsScene();
	}
	if (g_exitGameButton.isPressed()){
		Exit();
	}
	// draw centered game title sprite
	SetSpriteOrigin("sprites/main_logo.png", vector2(0.5f, 0.5f));
	DrawSprite("sprites/main_logo.png", GetScreenSize() * vector2(0.5f, 0.25f));
}

/*****************************************************
        Options scene
*****************************************************/
Button@ g_return;

void createOptionsScene(){
	vector2 returnPos(GetScreenSize() * vector2(0.5f, 0.70f));
	@g_return = Button("sprites/return_game.png", returnPos);
}

void updateOptionsScene(){
	// draw and check button
	g_return.putButton();
	if (g_return.isPressed()){
		loadStartScene();
	}
	// draw centered game title sprite
	SetSpriteOrigin("sprites/main_logo.png", vector2(0.5f, 0.5f));
	DrawSprite("sprites/main_logo.png", GetScreenSize() * vector2(0.5f, 0.25f));
	DrawText(GetScreenSize() * vector2(0.4f, 0.35f),"Options","Verdana30_shadow.fnt",ARGB(250,255,255,255));
}

/*****************************************************
        Game scene
*****************************************************/

void createGameScene(){
	initHud();
	initPause();
	initShop();
	initShip();
	init(level);
}

void updateGameScene(){
	loop(level);
}

bool tmp_fire = true;

void ETHCallback_player(ETHEntity@ thisEntity){
	if(!pause){
		ETHInput@ input = GetInputHandle();
		if(debug){
			if(input.GetKeyState(K_Q) == KS_HIT){
				pause = true;
				initPause();
				startPause();
			}
			if(input.GetKeyState(K_W) == KS_HIT){
				addLevel();
			}
		}
		if(alivePlayer){
			float speed = thisEntity.GetFloat("speed");
			if (input.KeyDown(K_RIGHT) && thisEntity.GetPosition().x < 950)
				thisEntity.AddToPositionXY(vector2(speed, 0.0f));

			if (input.KeyDown(K_LEFT) && thisEntity.GetPosition().x > 230)
				thisEntity.AddToPositionXY(vector2(-speed, 0.0f));

			if (input.KeyDown(K_UP) && thisEntity.GetPosition().y > 60)
				thisEntity.AddToPositionXY(vector2(0.0f,-speed));

			if (input.KeyDown(K_DOWN) && thisEntity.GetPosition().y < 720)
				thisEntity.AddToPositionXY(vector2(0.0f, speed));
				
			if (input.GetKeyState(K_SPACE) == KS_HIT){
				if(thisEntity.GetFloat("en")>0){
					vector3 tmp = thisEntity.GetPosition();
					tmp.y = tmp.y-35;
					if(tmp_fire)
						tmp.x = tmp.x+33;
					else
						tmp.x = tmp.x-33;
					string bullet = "shot.ent";
					for(uint i=0;i<count_slot;i++){
						if(slotShip[i].getType()==3){
							Module@ mod = slotShip[i].getMod();
							if(mod.getType()==3){
								bullet = mod.getBullet();
								break;
							}
						}
					}
					int id = AddEntity(bullet,tmp);
					PlaySample("soundfx/shoot.mp3");
					if(tmp_fire)
						tmp_fire = false;
					else
						tmp_fire = true;
					insertBullet(SeekEntity(id));
					thisEntity.SetFloat("en",thisEntity.GetFloat("en")-1);
				}
			}
			
			if (input.GetKeyState(K_CTRL) == KS_HIT){
				if(rockets>0){
					vector3 tmp = thisEntity.GetPosition();
					tmp.y = tmp.y-35;
					if(tmp_fire)
						tmp.x = tmp.x+33;
					else
						tmp.x = tmp.x-33;
					int id = AddEntity("shotRocket1.ent",tmp);
					PlaySample("soundfx/shootRocket1.mp3");
					if(tmp_fire)
						tmp_fire = false;
					else
						tmp_fire = true;
					insertBullet(SeekEntity(id));
					rockets--;
				}
			}
		}
		if (input.GetKeyState(K_ESC) == KS_HIT){
			loadStartScene();
		}
	}
}

void addLevel(){
	level++;
}

void ETHCallback_shot(ETHEntity@ thisEntity)
{
		if(!pause){
			float speed = UnitsPerSecond(360.0f);
			thisEntity.AddToPositionXY(vector2(0.0f,-1.0f) * speed);

			// if the projectile goes out of the screen view, delete it
			if (thisEntity.GetPosition().y < 0.0f)
			{
					DeleteEntity(thisEntity);
					if(debug)
						print("projectile removed because it is no longer visible: ID " + thisEntity.GetID());
			}
		}
}

void ETHCallback_shot3(ETHEntity@ thisEntity)
{
		if(!pause){
			float speed = UnitsPerSecond(360.0f);
			thisEntity.AddToPositionXY(vector2(0.0f,-1.0f) * speed);

			// if the projectile goes out of the screen view, delete it
			if (thisEntity.GetPosition().y < 0.0f)
			{
					DeleteEntity(thisEntity);
					if(debug)
						print("projectile removed because it is no longer visible: ID " + thisEntity.GetID());
			}
		}
}

void ETHCallback_shotRocket1(ETHEntity@ thisEntity)
{
		if(!pause){
			float speed = UnitsPerSecond(360.0f);
			thisEntity.AddToPositionXY(vector2(0.0f,-1.0f) * speed);

			// if the projectile goes out of the screen view, delete it
			if (thisEntity.GetPosition().y < 0.0f)
			{
					DeleteEntity(thisEntity);
					if(debug)
						print("projectile removed because it is no longer visible: ID " + thisEntity.GetID());
			}
		}
}

void ETHCallback_shot2(ETHEntity@ thisEntity)
{
		if(!pause){
			float speed = UnitsPerSecond(360.0f);
			thisEntity.AddToPositionXY(vector2(0.0f,1.0f) * speed);

			// if the projectile goes out of the screen view, delete it
			if (thisEntity.GetPosition().y > 768.0f)
			{
					DeleteEntity(thisEntity);
					if(debug)
						print("projectile removed because it is no longer visible: ID " + thisEntity.GetID());
			}
		}
}

void ETHCallback_bonus_rocket(ETHEntity@ thisEntity)
{
		if(!pause){
			float speed = UnitsPerSecond(250.0f);
			thisEntity.AddToPositionXY(vector2(0.0f,1.0f) * speed);

			// if the projectile goes out of the screen view, delete it
			if (thisEntity.GetPosition().y > 768.0f)
			{
					DeleteEntity(thisEntity);
					if(debug)
						print("projectile removed because it is no longer visible: ID " + thisEntity.GetID());
			}
		}
}

void ETHCallback_bonus_energy(ETHEntity@ thisEntity)
{
		if(!pause){
			float speed = UnitsPerSecond(250.0f);
			thisEntity.AddToPositionXY(vector2(0.0f,1.0f) * speed);

			// if the projectile goes out of the screen view, delete it
			if (thisEntity.GetPosition().y > 768.0f)
			{
					DeleteEntity(thisEntity);
					if(debug)
						print("projectile removed because it is no longer visible: ID " + thisEntity.GetID());
			}
		}
}