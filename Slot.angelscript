#include "Module.angelscript"
bool isPointInRectSlot(const vector2 &in p, const vector2 &in pos, const vector2 &in size, const vector2 &in origin)
{        
        vector2 posRelative = vector2(pos.x - size.x * origin.x, pos.y - size.y * origin.y);
        if (p.x < posRelative.x || p.x > posRelative.x + size.x || p.y < posRelative.y || p.y > posRelative.y + size.y)
                return false;
        else
                return true;
}


class Slot
{
	private string m_spriteName;
	private vector2 m_pos;
	private vector2 m_origin;
	private vector2 m_size;
	private bool m_isPressed;
	private Module mod;
	Slot(){
		m_spriteName = "sprites/modules/slot.png";
		m_pos = vector2(0,0);
		LoadSprite(m_spriteName);
		m_size = GetSpriteFrameSize(m_spriteName);
		m_origin = vector2(0.5f, 0.5f);
		m_isPressed = false;
		mod = Module();
	}
	Slot(const vector2 &in _pos, const vector2 &in _origin = vector2(0.5f, 0.5f)){
		m_origin = _origin;
		m_spriteName = "sprites/modules/slot.png";
		m_pos = _pos;
		LoadSprite(m_spriteName);
		m_size = GetSpriteFrameSize(m_spriteName);
		m_isPressed = false;
		mod = Module();
	}
	Slot(const string _spriteName, const vector2 &in _pos, const vector2 &in _origin = vector2(0.5f, 0.5f)){
		m_origin = _origin;
		m_spriteName = _spriteName;
		m_pos = _pos;
		LoadSprite(m_spriteName);
		m_size = GetSpriteFrameSize(m_spriteName);
		m_isPressed = false;
		mod = Module();
	}
	void setStatusMod(int st){
		mod.setStatus(st);
	}
	void setMod(Module@ obj){
		mod = obj;
	}
	void deleteMod(){
		mod = Module();
	}
	bool isMod(){
		string str = mod.getSprite();
		if(str!=""){
			return true;
		}else{
			return false;
		}
	}
	Module@ getMod(){
		return @mod;
	}
	
	//Graphic and pressed
	bool isMouse()
	{
		ETHInput@ input = GetInputHandle();
		if (isPointInButton(input.GetCursorPos()))
		{
			return true;
		}
		return false;
	}
	vector2 getPos()
	{
		return m_pos;
	}

	void setPos(const vector2 _pos)
	{
		m_pos = _pos;
	}

	void setBitmap(const string &in _spriteName)
	{
		m_spriteName = _spriteName;
	}

	string getButtonBitmap()
	{
		return m_spriteName;
	}

	void put()
	{
		put(vector2(0,0));
	}

	void put(const vector2 &in offset)
	{
		update();
		draw(offset);
	}

	void draw()
	{
		draw(vector2(0,0));
	}

	void draw(const vector2 &in offset)
	{
		//Slot sprite
		SetSpriteOrigin(m_spriteName, m_origin);
		DrawSprite(m_spriteName, m_pos + offset);
		//
		//Module sprite
		if(mod.getSprite()!=""){
		SetSpriteOrigin(mod.getSprite(), m_origin);
		DrawSprite(mod.getSprite(), m_pos + offset);
		}
		//
	}

	vector2 getSize() const
	{
		return m_size;
	}

	bool isPointInButton(const vector2 &in p)
	{
		return isPointInRectSlot(p, m_pos, m_size, m_origin);
	}

	void update()
	{
		ETHInput@ input = GetInputHandle();

		// check if any touch (or mouse) input is pressing the button
		const uint touchCount = input.GetMaxTouchCount();
		for (uint t = 0; t < touchCount; t++)
		{
			if (input.GetTouchState(t) == KS_HIT)
			{
				if (isPointInButton(input.GetTouchPos(t)))
				{
					m_isPressed = true;
				}
			}
		}
		//
	}
	bool isPressed()
	{
		return m_isPressed;
	}

	void setPressed(const bool pressed)
	{
		m_isPressed = pressed;
	}
	//
}

class SlotShip : Slot{
	private int type;
	SlotShip(){
		type = -1;
		m_spriteName = "sprites/modules/slotShip.png";
		m_pos = vector2(0,0);
		LoadSprite(m_spriteName);
		m_size = GetSpriteFrameSize(m_spriteName);
		m_origin = vector2(0.5f, 0.5f);
		m_isPressed = false;
		mod = Module();
	}
	SlotShip(int _type,const vector2 &in _pos, const vector2 &in _origin = vector2(0.5f, 0.5f)){
		type = _type;
		m_origin = _origin;
		m_spriteName = "sprites/modules/slotShip.png";
		m_pos = _pos;
		LoadSprite(m_spriteName);
		m_size = GetSpriteFrameSize(m_spriteName);
		m_isPressed = false;
		mod = Module();
	}
	SlotShip(string sprite,int _type,const vector2 &in _pos, const vector2 &in _origin = vector2(0.5f, 0.5f)){
		type = _type;
		m_origin = _origin;
		m_spriteName = sprite;
		m_pos = _pos;
		LoadSprite(m_spriteName);
		m_size = GetSpriteFrameSize(m_spriteName);
		m_isPressed = false;
		mod = Module();
	}
	int getType(){
		return type;
	}
}