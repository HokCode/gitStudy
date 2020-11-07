import "UnityEngine"
if not UnityEngine.GameObject then
	error("Click Make/All to generate lua wrap file")
end

packMgr = {}

--通过Canvas获取各种组件
local Canvas = GameObject.Find("Canvas")

--物品界面
local PackBg = Canvas.transform:GetChild(0)
local PanelItem = PackBg:GetChild(0)
local Mask = PanelItem:GetChild(0)
local Content = Mask:GetChild(0)

--获取两个按钮
local Btns_Text_Dowm = PackBg:GetChild(2)
local BtnWareHouse = Btns_Text_Dowm:GetChild(0)
local BtnTidyUp = Btns_Text_Dowm:GetChild(1)

--获取文字显示组件
local TextDisplay = Btns_Text_Dowm:GetChild(2)
local itemAmountText = TextDisplay:GetChild(1)

--测试用的组件
local TestUI = Canvas.transform:GetChild(1)
local TestButton = TestUI:GetChild(0)
local Testbtn = TestButton:GetComponent("Button")

--格子数目，格子定位用index
packMgr.cellNum = 30
packMgr.cellObj_List = {}
packMgr.cellObj_status_List = {}

packMgr.currentCell = 1	--当前格子游标，从1开始
packMgr.currentItemAmount = 0
packMgr.packCapacity = 120	--先把背包行囊与格子数目设为一致
packMgr.pack_status_List = {}

--先用这种方法找item的sprite
local RedItem = GameObject.Find("RedItem")
packMgr.testItem_Image = RedItem:GetComponent("Image").sprite

function main()
	require("packItem.lua")
	require("packUI.lua")
	require("objPool.lua")

	--packItem.Ready()
	--packUI.Ready()
	--objPool.Ready()
	--packMgr.Ready()

	packMgr:init()

	test_bindButton()
end

function packMgr:init()
	--初始化对象池
	objPool.loopObj = GameObject.Find("ItemObj")
	objPool.ObjPool_Init(self.cellNum)

	--根据目前格子数生成格子
	for i = 1, self.cellNum do
		local cellObj = objPool.ObjPool_CreatObj()		
		table.insert(self.cellObj_List, cellObj)	

		--保存属性，如Image
		local image = cellObj:GetComponent("Image")
		local cellStatus = Class_cellStatus:new(image)
		--table.insert(self.cellObj_status_List, cellStatus)
		--格子状态改为packUI保存，之后删除上面的
		table.insert(packUI.cell_UI_status_List, cellStatus)
	end

	--摆放好所有格子
	packUI.content = Content
	packUI.cell_default_UI = objPool.loopObj:GetComponent("Image").sprite
	packUI.init(self.cellObj_List, Content)

	--绑定按钮
	packUI.Btn_WareHouse = BtnWareHouse:GetComponent("Button")
	packUI.Btn_TidyUp = BtnTidyUp:GetComponent("Button")
	packUI.SrollRect = PanelItem:GetComponent("ScrollRect")
	packUI:blindScroll()

	--绑定文字
	packUI.AmountText = itemAmountText:GetComponent("Text")
	packUI:updateText(self.currentItemAmount, self.packCapacity)

	--初始化行囊所有格子状态table
	for i = 1, self.packCapacity do
		local packStatus = Class_packStatus:new(true, nil)
		table.insert(self.pack_status_List, packStatus)	
	end
end

function packMgr:AddItem(item)
	if(self.currentCell == nil) then
		print("背包已满")
		return
	end

	--更新背包信息packStatus
	local packStatus = self.pack_status_List[self.currentCell]
	if(packStatus.isEmpty == false) then
		error("目标位置已经有物品")
		return
	end
	packStatus.cellPackItem = item
	packStatus.isEmpty = false

	--这个self.Item_List目前构思是先用来定位物品index，再通过index操作cell_status
	--self.Item_List[self.currentCell] = item	
	self.currentItemAmount = self.currentItemAmount + 1

	packUI:refesh_AllCell()
	packUI:updateText(self.currentItemAmount, self.packCapacity)

	--每次放完物品游标移到从第一个格子开始，最近的空格子
	self.currentCell = nil
	for i = 1, self.packCapacity do
		if( self.pack_status_List[i].isEmpty == true ) then
			self.currentCell = i
			break
		end
	end
end

function packMgr:SubItem(index)	--先处理成根据index来减去，后面会改成用id来找
	if( index < 1 or index > self.packCapacity ) then
		error("参数不在范围")
	end
	if(self.currentItemAmount == 0) then
		print("没物品。不用减")
		return
	end

	--更新背包信息packStatus
	local packStatus = self.pack_status_List[index]
	if(packStatus.isEmpty == true) then
		print("目标位置没物品")
		return
	end
	packStatus.cellPackItem = nil   --目前直接吧物品置为nil，正常这里是让物品发挥效果
	packStatus.isEmpty = true

	
	--self.Item_List[index] = nil
	self.currentItemAmount = self.currentItemAmount - 1

	packUI:refesh_AllCell()
	packUI:updateText(self.currentItemAmount, self.packCapacity)

	--如果所在物品位置小于游标，就把位置赋值给游标
	if( self.currentCell == nil or index < self.currentCell ) then
		self.currentCell = index
	end
end

--pack_status_List向前整合成，填充空位
function packMgr:tidyUp_pack_status_list()
	--游戏容量一般有限，直接生成个新的替换
	local new_pack_status_List = {}

	for i = 1, self.packCapacity do
		local NewpackStatus = Class_packStatus:new(true, nil)	--空的格子给新值
		new_pack_status_List[i] = NewpackStatus
	end

	local index = 1
	for i = 1, self.packCapacity do	
		local packStatus = self.pack_status_List[i]
		if(packStatus.isEmpty == false) then	
			new_pack_status_List[index] = packStatus --对有物品的格子操作
			index = index + 1
		end			
	end

	self.pack_status_List = new_pack_status_List

	--最后游标也要动下
	self.currentCell = nil
	if( index <= self.packCapacity ) then
		self.currentCell = index
	end
end


--测试代码
--模拟加道具
function test_addItem()
	local name = "test"
	local image = packMgr.testItem_Image
	local item = packItem:new(name, image)

	packMgr:AddItem(item)
end

function test_subItem()
	packMgr:SubItem(5)
end


function test_bindButton()
	packUI.Btn_WareHouse.onClick:AddListener(test_addItem)
	packUI.Btn_TidyUp.onClick:AddListener(packUI.tidyUp)
	Testbtn.onClick:AddListener(test_subItem)
	--onScroll = packUI:onScroll
	--packUI.SrollRect.onValueChanged:AddListener(onScroll)
end

function packMgr.Ready()
	print("packMgr is ready")
end