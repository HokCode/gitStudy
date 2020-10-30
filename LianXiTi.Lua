--运行阶乘的实例。
function func(x)
	if( x < -1 ) then
		return nil
	end
	if(x == 1 or x == -1) then
		return 1
	else
		return func(x - 1) * x
	end
end


--请编写一个函数，使之实现在某个字符串的指定位置插入另一个字符串
function insert(string1, index, string2)
	if(index < 0) then
		return string1
	end
	if(index > #string1) then
		return string1..string2
	end

	return string.sub(string1, 1, index - 1)..string2..string.sub(string1, index, #string1)
end
--print(insert("hello world", 1, "start: "))
--print(insert("hello world", 7, "small "))

--请编写一个函数，用于移除指定字符串中的一部分，移除的部分使用起始位置和长度指定
function remove(string1, indexS, nums)
	len = #string1
	if(indexS < 1) then
		indexS = 1
	end
	if(indexS == 1 and nums >= len) then
		return ""
	end

	return string.sub(string1, 1, indexS-1)..string.sub(string1, indexS+nums, len)
end
--print(remove("hello world", 1, 9))

--判断字符串是否为回文字符串
function ispali(string1)
	len = #string1 + 1
	for i= 1, len do
		if(string.sub(string1,i,i) ~= string.sub(string1,len - i,len - i)) then
			return false
		end
		if(i*2 >= len-1) then
			break
		end
	end

	return true
end


--下列代码输出
sunday = "monday" ; monday = "sunday"
t = {sunday = "monday", [sunday] = monday}
--print(t.sunday, t[sunday], t[t.sunday])
--monday
--sunday
--sunday

--考虑如下代码：
x = {}
a = {}; a.a = a
--print(a.a)
-- a = { a = 自己}
--a.a.a.a = 4

--创建一个以转义序列为值，以转义序列对应字符串为键的表
t = { ['\a'] = "bell", ['\b'] = "back space" }
--print(t['\a'])

--请编写一个函数，该函数以多项式（使用表表示）和值 为参数，返回结果为对应多项式的值
function getListSum(t, x)
	sum = 0
	for i = 1, #t do
		sum = sum + t[i]*x^(i-1)
	end

	return sum
end
--print(getListSum({1, 1, 1}, 2))


--改写上述函数，使之最多使用n个加法和n个乘法（且没有指数）
function getListSum(t, x)
	sum = 0
	for i = 1, #t do
		sum = sum + t[i]*x
	end

	return sum
end



--请编写一个函数，该函数用于测试指定的表是否为有效的序列
function checkTable(t)
	for i = 1, #t do
		if(t[i] == nil) then
			return false
		end
	end

	return true
end

t1 = {1, 2, 3, 4}
--print(checkTable(t1))

--请编写一个函数，该函数将指定列表的所有元素插入 另一个列表的指定位置
function moveTable(t1, t2, pos)
	len1 = #t1
	len2 = #t2
	if(pos < 1) then
		pos = 1
	end
	if(pos > len2) then
		pos = len2 + 1
	end

	table.move(t1, 1, len1, pos, t2)

	return t2
end

t1 = {1, 2, 3}
t2 = {4, 5, 6}
--print(moveTable(t1, t2, 20))

--表标准库中提供了函数 table.concat ，该函数将指定表的字符串元素连接在起：
--结论：标准库提供的table.concat性能很顶。

function tableConcat(t)
	str = ""
	for i = 1, #t do
		str = str..t[i]
	end
	--return str
end

function func58()
	t = {}
	for i = 1, 10000000 do
		t[i] = "1"
	end

	table.concat(t)
end

function funcText()
	print("funcText")
end

function getTime(func)
	curTime = os.time()
	func()
	return os.time() - curTime
end

--print(table.concat({"hello", " ", "world"}))
--print(tableConcat({"hello", " ", "world"}))

--print(getTime(func58))


--请编写一个函数，该函数的参数为一个数组，打印出该数组的所有元素.
function func61(t)
	for i = 1, #t do
		print(t[i])
	end
end

--请编写一个函数，该函数的参数为可变数量的一组值，返回值为除第一个元素之外的其他所有值.
function func62(...)
	t = {...}
	for i = 2, #t do
		print(t[i])
	end
end

--请编写一个函数，该函数的参数为可变数量的一组值，返回值为除最后一个元素之外的其他所有值
function func63(...)
	t = {...}
	for i = 1, #t-1 do
		print(t[i])
	end
end

--请编写一个函数，该函数用于打乱（ shuffle ）一个指定的数组 请保证所有的排列都是等概率的
function fun64(t)

end


--请编写一个程序，该程序读取一个文本文件然后将每行的内容按照字母表顺序排序后重写该文件
--如果在调用时不带参数，则从标准输入读取并向标准输出写入；
--如果在调用时传入一个文件名作为参数，则从该文件中读取并向标准输出写入；
--如果在调用时传人两个文件名作为参数，则从第个文件读取并将结果写入到第二个文件中
filePath = "luaInOut.txt"
outPutPath = "luaOutput.txt"
function func71(InputFile, OutputFile)

	f = nil
	if( InputFile ~= nil) then
		f = io.open(InputFile, "r")
		io.input(f)
	end

	local dir = {}
	for line in io.lines() do
		dir[#dir + 1] = line
	end

	if( f ~= nil) then
		f:close()
	end


	table.sort(dir)
	f = nil
	if( OutputFile ~= nil) then
		f = io.open(OutputFile , "w")
		io.output(f)
	end

	for i = 1, #dir do
		io.write(dir[i]..'\n')
	end

	if( f ~= nil) then
		f:close()
	end
end










