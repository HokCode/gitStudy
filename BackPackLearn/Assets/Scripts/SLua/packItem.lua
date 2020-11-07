--物品数据类
packItem = {
	itemName = nil,
	itemImage = nil,
}

packItem.__index = packItem

function packItem:new(name, image)
	local o = {}
	setmetatable(o, packItem)
	o.itemName = name
	o.itemImage = image
	return o
end

function packItem.Ready()
	print("packItem is ready")
end



--格子属性类
Class_cellStatus = {
	cellImage = nil,
	cellRect = nil,
	cellBtn = nil,
	packIndex = nil
}

Class_cellStatus.__index = Class_cellStatus

function Class_cellStatus:new(Image)
	local o = {}
	setmetatable(o, Class_cellStatus)
	o.cellImage = Image
	--o.cellPos = pos
	return o
end

function Class_cellStatus:SetItem(key, Val)
	classItemObj[key] = Val
end

--行囊实际状态类
Class_packStatus = {
	isEmpty = false,
	cellPackItem = nil
}

Class_packStatus.__index = Class_packStatus

function Class_packStatus:new(isempyt, item)
	local o = {}
	setmetatable(o, Class_packStatus)
	o.isEmpty = isempyt
	o.cellPackItem = item
	return o
end