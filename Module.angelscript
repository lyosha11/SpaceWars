class Module{
	private string name;
	private string desc;
	private string m_spriteName;
	private string effectAdd;
	private int effectCount;
	private int type;
	private float status;
	private float price;
	private int max_price;
	
	private string bullet;
	Module(){
		name = "";
		desc = "";
		m_spriteName = "";
		type = -1;
		effectAdd = "";
		effectCount = 0;
		price = 0;
		bullet = "";
	}
	Module(string _name, string _desc, int _type, string spriteName, string effAdd, uint effCount, int _price){
		name = _name;
		desc = _desc;
		type = _type;
		price = _price;
		max_price = price;
		m_spriteName = spriteName;
		effectAdd = effAdd;
		effectCount = effCount;
		status = effectCount;
		bullet = "";
	}
	Module(string _name, string _desc, int _type, string spriteName, string effAdd, uint effCount, int _price, string _bullet){
		name = _name;
		desc = _desc;
		type = _type;
		price = _price;
		max_price = price;
		m_spriteName = spriteName;
		effectAdd = effAdd;
		effectCount = effCount;
		status = effectCount;
		bullet = _bullet;
	}
	void setAll(string spriteName, string effAdd, uint effCount){
		m_spriteName = spriteName;
		effectAdd = effAdd;
		effectCount = effCount;
	}
	void setStatus(float s){
		status = s;
	}
	void setPrice(float s){
		price = s;
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
	float getStatus(){
		return status;
	}
	int getType(){
		return type;
	}
	float getPrice(){
		return price;
	}
	int getMaxPrice(){
		return max_price;
	}
	string getTypeString(){
		switch(type){
			case 1:
			return "Armor";
			case 2:
			return "Shield";
			case 3:
			return "Weapon";
			case 4:
			return "Battery";
			case 5:
			return "Engine";
			default:
			return "Non-type";
		}
		return "Non-type";
	}
	string getBullet(){
		return bullet;
	}
};