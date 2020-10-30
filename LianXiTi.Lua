--���н׳˵�ʵ����
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


--���дһ��������ʹ֮ʵ����ĳ���ַ�����ָ��λ�ò�����һ���ַ���
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

--���дһ�������������Ƴ�ָ���ַ����е�һ���֣��Ƴ��Ĳ���ʹ����ʼλ�úͳ���ָ��
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

--�ж��ַ����Ƿ�Ϊ�����ַ���
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


--���д������
sunday = "monday" ; monday = "sunday"
t = {sunday = "monday", [sunday] = monday}
--print(t.sunday, t[sunday], t[t.sunday])
--monday
--sunday
--sunday

--�������´��룺
x = {}
a = {}; a.a = a
--print(a.a)
-- a = { a = �Լ�}
--a.a.a.a = 4

--����һ����ת������Ϊֵ����ת�����ж�Ӧ�ַ���Ϊ���ı�
t = { ['\a'] = "bell", ['\b'] = "back space" }
--print(t['\a'])

--���дһ���������ú����Զ���ʽ��ʹ�ñ���ʾ����ֵ Ϊ���������ؽ��Ϊ��Ӧ����ʽ��ֵ
function getListSum(t, x)
	sum = 0
	for i = 1, #t do
		sum = sum + t[i]*x^(i-1)
	end

	return sum
end
--print(getListSum({1, 1, 1}, 2))


--��д����������ʹ֮���ʹ��n���ӷ���n���˷�����û��ָ����
function getListSum(t, x)
	sum = 0
	for i = 1, #t do
		sum = sum + t[i]*x
	end

	return sum
end



--���дһ���������ú������ڲ���ָ���ı��Ƿ�Ϊ��Ч������
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

--���дһ���������ú�����ָ���б�������Ԫ�ز��� ��һ���б���ָ��λ��
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

--����׼�����ṩ�˺��� table.concat ���ú�����ָ�������ַ���Ԫ����������
--���ۣ���׼���ṩ��table.concat���ܺܶ���

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


--���дһ���������ú����Ĳ���Ϊһ�����飬��ӡ�������������Ԫ��.
function func61(t)
	for i = 1, #t do
		print(t[i])
	end
end

--���дһ���������ú����Ĳ���Ϊ�ɱ�������һ��ֵ������ֵΪ����һ��Ԫ��֮�����������ֵ.
function func62(...)
	t = {...}
	for i = 2, #t do
		print(t[i])
	end
end

--���дһ���������ú����Ĳ���Ϊ�ɱ�������һ��ֵ������ֵΪ�����һ��Ԫ��֮�����������ֵ
function func63(...)
	t = {...}
	for i = 1, #t-1 do
		print(t[i])
	end
end

--���дһ���������ú������ڴ��ң� shuffle ��һ��ָ�������� �뱣֤���е����ж��ǵȸ��ʵ�
function fun64(t)

end


--���дһ�����򣬸ó����ȡһ���ı��ļ�Ȼ��ÿ�е����ݰ�����ĸ��˳���������д���ļ�
--����ڵ���ʱ������������ӱ�׼�����ȡ�����׼���д�룻
--����ڵ���ʱ����һ���ļ�����Ϊ��������Ӹ��ļ��ж�ȡ�����׼���д�룻
--����ڵ���ʱ���������ļ�����Ϊ��������ӵڸ��ļ���ȡ�������д�뵽�ڶ����ļ���
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









