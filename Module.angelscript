class Module{
	private string m_spriteName;
	private string effectAdd;
	private uint effectCount;
	Module(){
		m_spriteName = "";
		effectAdd = "";
		effectCount = 0;
	}
	Module(string spriteName, string effAdd, uint effCount){
		m_spriteName = spriteName;
		effectAdd = effAdd;
		effectCount = effCount;
	}
	void setAll(string spriteName, string effAdd, uint effCount){
		m_spriteName = spriteName;
		effectAdd = effAdd;
		effectCount = effCount;
	}
	string getSprite(){
		return m_spriteName;
	}
	string getEffect(){
		return effectAdd;
	}
	uint getEffectCount(){
		return effectCount;
	}
}