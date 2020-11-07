packUI = {}

packUI.cell_UI_status_List = {}	--保存格子状态

packUI.content = nil
packUI.cell_default_UI = nil
packUI.Btn_WareHouse = nil
packUI.Btn_TidyUp = nil
packUI.SrollRect = nil

packUI.AmountText = nil

--格子每行数目、大小、gap
packUI.each_line_num = 5
packUI.cell_Width = 100
packUI.cell_Height = 100
packUI.cell_Hgap = 10
packUI.cell_Vgap = 10


function packUI.init(obj_List, parent)
	
	--拿到obj列表，把其排版
	for index, obj in ipairs( obj_List ) do
		obj.transform:SetParent(parent)

		local rect = obj:GetComponent("RectTransform")
		rect.anchorMin = Vector2(0, 1);
    	rect.anchorMax = Vector2(0, 1);
    	rect.pivot = Vector2(0, 1);

    	rect.localPosition = packUI:getCellPosition(index)

		--这里缓存格子状态。如代表index，RectTransform。
		packUI.cell_UI_status_List[index].packIndex = index
		packUI.cell_UI_status_List[index].cellRect = rect
		packUI.cell_UI_status_List[index].cellBtn = rect:GetComponent("Button")

		--绑定测试
		packUI.cell_UI_status_List[index].cellBtn.onClick:AddListener(function() print("点了物品") end)
	end	

	--根据容量设置content长度
	local itemAmount = packMgr.packCapacity
	packUI:updateContent(itemAmount)
end

--传入index，每行个数，格子宽度+横向gap，格子高度+纵向gap。返回格子对应坐标。
--这里的index从0开始算
function packUI:getCellPosition(index)
	local num = self.each_line_num
	local cell_Width_and_Hgap = self.cell_Width + self.cell_Hgap
	local cell_Height_and_Vgap = self.cell_Height + self.cell_Vgap
	return Vector2( ((index - 1) % num)*(cell_Width_and_Hgap), math.floor((index - 1) / num) * cell_Height_and_Vgap * -1 )
end

--物品长宽、每行个数先写死
function packUI:updateContent(amount)
	local size = self.content.sizeDelta
	self.content.sizeDelta = Vector2(size.x, (math.ceil(amount / self.each_line_num)) * (self.cell_Height + self.cell_Vgap))
	self.content.localPosition.y = 0
end


--更新格子显示图片
function packUI:updateCell(cellStatus)	
	local packItem = nil

	if cellStatus and next(cellStatus) then
		packItem = cellStatus.cellPackItem
	end

	if(packItem == nil) then
		cellStatus.cellImage.sprite = self.cell_default_UI
	else
		cellStatus.cellImage.sprite = packItem.itemImage
	end
end

function packUI:refeshCell(cellStatus, packStatus)
	local packIndex = cellStatus.packIndex

	--更新图片
	if(packStatus.isEmpty == false and packStatus.cellPackItem ~= nil) then
		local packItem = packStatus.cellPackItem
		cellStatus.cellImage.sprite = packItem.itemImage
	else
		cellStatus.cellImage.sprite = self.cell_default_UI
	end

	--更新位置
	local rect = cellStatus.cellRect
	rect.localPosition = packUI:getCellPosition(packIndex)
end

function packUI:refesh_AllCell()
	for i = 1, packMgr.cellNum do
		local cellStatus = self.cell_UI_status_List[i]
		local packIndex = cellStatus.packIndex
		local packStatus = packMgr.pack_status_List[packIndex]
		packUI:refeshCell(cellStatus, packStatus)
	end
end

--更新文字
function packUI:updateText(haveAmount, totalAmount)
	self.AmountText.text = haveAmount.."/"..totalAmount
end

--处理滚动框移动时格子反应
function packUI.onScroll(value)

	--遍历所有cell，检查他们位置
	for index, cellStatus in pairs( packUI.cell_UI_status_List ) do
		local rect = cellStatus.cellRect
		cellPos_Y = rect.localPosition.y	

		--处理越上界
		if( packUI.isCross_up_Border(cellPos_Y, packUI.content.localPosition.y) ) then

			--越上界，虚拟坐标 加 6 * 5。比如第1行第1个就跳到第7行第1个
			local packIndex = cellStatus.packIndex
			packIndex = packIndex + 6 * 5

			if(packIndex <= packMgr.packCapacity) then
				cellStatus.packIndex = packIndex
				packUI:refeshCell(cellStatus, packMgr.pack_status_List[packIndex])
			end


		--处理越下界
		elseif( packUI.isCross_down_Border(cellPos_Y, packUI.content.localPosition.y) ) then
			
			--越下界，虚拟坐标 减 6 * 5。比如第1行第1个就跳到第7行第1个
			local packIndex = cellStatus.packIndex
			packIndex = packIndex - 6 * 5

			if(packIndex >= 1) then
				cellStatus.packIndex = packIndex
				packUI:refeshCell(cellStatus, packMgr.pack_status_List[packIndex])
			end

		end

	end
end

function packUI.isCross_up_Border(cellPos_Y, content_Y)
	local cell_Height = 100
	local cell_Vgap = 10

	--这里边界设成mask上面 两个 格子+gap 的位置
	local border = content_Y
	local cellPos_Abs_Y = math.abs(cellPos_Y) + (cell_Height + cell_Vgap) * 2

	if( cellPos_Abs_Y < border ) then
		return true
	else
		return false
	end
end

--这里mask高度先直接写，之后看需不需要动态get
function packUI.isCross_down_Border(cellPos_Y, content_Y)
	local cell_Height = 100
	local cell_Vgap = 10 
	local mask_Height = 450

	--这里边界设成mask下面 两个 格子+gap 的位置
	local border = content_Y + mask_Height + (cell_Height + cell_Vgap) * 2
	local cellPos_Abs_Y = math.abs(cellPos_Y)
	if( cellPos_Abs_Y > border ) then 
		return true
	else
		return false
	end
end

--绑定滚动框监听函数
function packUI:blindScroll()
	self.SrollRect.onValueChanged:AddListener(self.onScroll)
end

--实现整理功能
function packUI.tidyUp()

	print(packMgr)
	print("整理前", packMgr.pack_status_List[5].isEmpty)

	--pack_status_List里物品向前整合，这个可以让packMgr做
	--所有cell重新根据自己index显示，refresh
	packMgr:tidyUp_pack_status_list()
	packUI:refesh_AllCell()

	print("整理后", packMgr.pack_status_List[5].isEmpty)
end

--按钮绑定事件接口 TODO



--测试代码
function packUI.Ready()
	print("packUI is ready")
end