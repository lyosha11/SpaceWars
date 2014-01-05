#include "eth_util.angelscript"
#include "Button.angelscript"
#include "main.angelscript"

Button@ next;
void startPause(){
	pause = true;
	vector2 vc2 = GetScreenSize() * vector2(0.5f, 0.50f);
	vector3 center(vc2.x,vc2.y,1);
	AddEntity("bg.ent",center);
	vector2 nextButtonPos(GetScreenSize() * vector2(0.5f, 0.60f));
	@next = Button("sprites/pause_next.png", nextButtonPos);
}

void loopPause(){
	DrawText(GetScreenSize() * vector2(0.40f, 0.40f), "Level "+level+" complete.", "Verdana20.fnt", 0xFFFFFFFF);
	next.putButton();
	if (next.isPressed()){
		ETHEntity@ obj = SeekEntity("bg.ent");
		DeleteEntity(obj);
		pause = false;
	}
}