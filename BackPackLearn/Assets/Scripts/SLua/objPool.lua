--对象池逻辑
objPool = {}


objPool.loopObj = nil
objPool.objPool_add_num = 10
objPool.objPool_List = {}


--loopObj = GameObject.Find("Canvas/Item")

	--初始化对象池
function objPool.ObjPool_Init(ObjNum)
	for i = 1, ObjNum do
		local obj = GameObject.Instantiate(objPool.loopObj)
		table.insert(objPool.objPool_List, obj)
	end
end

	--对象池拿元素
function objPool.ObjPool_CreatObj()
	if( table.getn(objPool.objPool_List) <= 0 ) then
		ObjPool_AddObj()
	end

	local obj = objPool.objPool_List[1]
	table.remove(objPool.objPool_List, 1)
	obj.gameObject:SetActive(true)
	return obj
end

	--对象池补充元素
function objPool.ObjPool_AddObj()
	for i = 1, objPool_add_num do
		local obj = GameObject.Instantiate(objPool.loopObj)
		table.insert(objPool.objPool_List, obj)
	end
	objPool_total_amount = objPool_total_amount + objPool_add_num
end

	--对象池回收元素
function objPool.ObjPool_DestroyObj(obj)
	obj.gameObject:SetActive(false)
	table.insert(objPool.objPool_List, obj)

	Obj_amount = Obj_amount - 1
end

function objPool.Ready()
	print("objPool is ready")
end