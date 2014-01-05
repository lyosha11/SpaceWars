#include "eth_util.angelscript"
void initHud(){
	vector2 vc_2 = GetScreenSize() * vector2(0.08f, 0.50f);
	vector3 vc(vc_2.x,vc_2.y,0);
	AddEntity("bg_left.ent",vc,"bg_left");
}