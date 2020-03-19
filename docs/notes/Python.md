# Python

## 数据类型

+ 列表：[ ]
+ 元组：( )，如果一个元组内只有一个元素，则必须这样书写：( 22, )
+ 字典：{ }

## 函数

### 局部变量

局部变量，就是在函数内部定义的变量。假如局部变量中定义了一个变量，但这个变量与全局变量中的冲突。

```python
count = 0
def func():
    count = 1
    print(count)	# 1

print(count)	# 0
```

```python
count = 0
def func():
    # 假如在函数内部想修改全局变量的值，需要先使用 global 定义
    global count
    count = 1
func()
print(count)	# 1
```

### 参数

函数中指定的非缺省参数必须传递，否则会报错

#### 缺省参数

设置参数的默认值。缺省参数只能放在后面。

```python
def test(a, b = 22):
    return a + b
```

#### 命名参数

```python
def test(a, b = 22, c = 33)
	return a + b + c

test(11, c = 22)	# 此时 test() 中的参数为 11 22 22
```

#### 不定长参数

```python
# args 内保存所有不带命名的参数，以元组形式保存
def test(a, b, *args):
    print(args)	# (3, 4, 5, 6)

test(1, 2, 3, 4, 5, 6)
```

```python
# kwargs 内保存所有带命名的参数，并以字典形式保存
def test(a, b, *args, **kwargs):
    print(args)	# (4,)
    print(kwargs) # {'age': 5, 'name': 'yzn'}

test(2, 3, 4, age = 5, name = 'yzn')
```

#### 拆包

```python
# 未拆包
def test(a, b, *args, **kwargs):
    print(args)		# ((1, 2, 3), {'age': 5, 'name': 'yzn'})
    print(kwargs)	# {}
    
A = (1, 2, 3)
B = {'age': 5, 'name': 'yzn'}

test(11, 22, A, B)
```

```python
# 拆包后
def test(a, b, *args, **kwargs):
    print(args)		# (1, 2, 3)
    print(kwargs)	# {'age': 5, 'name': 'yzn'}
    
A = (1, 2, 3)
B = {'age': 5, 'name': 'yzn'}

test(11, 22, *A, **B)
```

### 引用

```python
a = 100
b = a	# b 引用了 a 的地址
```

数字、字符串、元组是不可变类型，其它都是可变类型

### 匿名函数

```python
# 定义一个匿名函数
func = lambda a,b:a+b
# 调用方式
func(1, 2)
```

匿名函数的特点是使用 lambda 定义，区别与普通函数的 def。匿名函数冒号后跟表达式，并默认返回该表达式的值。匿名函数可以用来实现一些简单功能，复杂功能还是得使用普通函数。

**应用场景**

```python
infos = [{'age': 20}, {'age': 18}, {'age': 19}]
# 排序
infos.sort(key=lambda x:x['age'])
```



















