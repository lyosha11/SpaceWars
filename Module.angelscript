class Module{
	private string name;
	private string desc;
	private string m_spriteName;
	private string effectAdd;
	private int effectCount;
	private int type;
	Module(){
		name = "";
		desc = "";
		m_spriteName = "";
		effectAdd = "";
		effectCount = 0;
	}
	Module(string _name, string _desc, int _type, string spriteName, string effAdd, uint effCount){
		name = _name;
		desc = _desc;
		type = _type;
		m_spriteName = spriteName;
		effectAdd = effAdd;
		effectCount = effCount;
	}
	void setAll(string spriteName, string effAdd, uint effCount){
		m_spriteName = spriteName;
		effectAdd = effAdd;
		effectCount = effCount;
	}
	string getName(){
		return name;
	}
	string getDesc(){
		return desc;
	}
	string getSprite(){
		return m_spriteName;
	}
	string getEffect(){
		return effectAdd;
	}
	int getEffectCount(){
		return effectCount;
	}
	int getType(){
		return type;
	}
	string getTypeString(){
		switch(type){
			case 1:
			return "Weapon";
			case 2:
			return "Armor";
			case 3:
			return "Shield";
			default:
			return "Non-type";
		}
		return "Non-type";
	}
}