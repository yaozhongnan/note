# Java

## 环境变量的配置

![](..\images\java\环境变量01.png)

![](..\images\java\环境变量02.png)



## 类

+ 类中的属性必须被封装，访问和设置属性通过相应的 set 和 get 方法
+ 一个类中可以拥有至少一个构造函数
+ 构造函数的名称必须与类名一致
+ 构造函数中可以通过 this() 的方式调用其它构造函数，以参数来区分调用的是哪个构造函数
+ this() 必须写在首行
+ 构造函数可以被私有化，也就是使用 private 修饰，被私有化构造函数的类无法在外部使用 new 实例对象
+ 当 new 出一个类的实例对象时，根据传入的参数不同指定执行哪一个构造函数
+ 当 new 出一个类的实例对象时，如果没有使用变量接收，则创建出来的对象称为匿名对象

```java
class Person {
    private String name;
    private int age;

    public Person() {
        System.out.print("无参构造函数");
    }

    public Person(String name, int age) {
        this();
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String n) {
        name = n;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int a) {
        age = a;
    }

    public void sayName() {
        System.out.print("姓名：" + name + " 年龄：" + age);
    }
}
```



## 继承

+ 子类中可以利用 super() 调用父类的构造函数
+ 子类允许覆写父类的属性和方法，但需要注意权限
+ 子类覆写的方法不能拥有比父类方法更加严格的访问权限，即 子类中方法权限应 > 父类中方法权限
+ 从 private 变为 default 不算方法覆写

```java
public class HelloWorld {
    public static void main(String args[]) {
        Student stu = new Student("yzn", 18, "清华");
        stu.sayInfo();
        stu.sayName();
    }
}

class Person {
    private String name;
    private int age;

    public Person() {
        System.out.println("无参构造函数");
    }

    public Person(String name, int age) {
        this();
        this.name = name;
        this.age = age;
        System.out.println("有参构造函数");
    }

    public String getName() {
        return name;
    }

    public void setName(String n) {
        name = n;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int a) {
        age = a;
    }

    public void sayName() {
        System.out.println("姓名：" + name);
    }
}

class Student extends Person {
    String school;

    public Student(String name, int age, String school) {
        super(name, age);
        this.school = school;
    }

    public void sayInfo() {
        System.out.println("姓名：" + this.getName() + " 年龄：" + this.getAge() + " 学校：" + school);
    }
}
```



## 代码块

代码块是指用 {} 括起来的一段代码，根据位置不同，代码块分为普通、构造、静态和同步四中代码块

+ 下面的代码在创建 new 出一个实例对象时，输出的结果先后顺序为：静态代码块 > 构造块 > 构造方法
+ 且静态代码块先于主方法执行

```java
class Demo {
    {
        System.out.println('构造块')
    }
    static {
        System.out.println('静态代码块')
    }
    public Demo() {
        System.out.println('构造方法')
    }
}
```



## static

**使用 static 声明属性**

使用 static 关键字描述的属性被称为全局属性，也称为静态属性。

```java
// Person 类中有一个 City 属性，被 static 修饰，则该属性就是一个全局属性
// 也就是每一个 Person 实例的值都是 A 城，当其中一个实例修改了这个属性，则所有实例的该属性均被修改了
class Person {
    static String city = 'A 城'
}
```

**使用 static 声明方法**

使用 static 声明从方法被称为类方法

```java
// 使用 static 修饰的方法可以使用类名调用：Person.setCity()
// 非 static 声明的方法中可以去调用 static 声明的方法或者属性，但反之不行
class Person {
    static String city = 'A 城'
    public static void setCity(String c) {
        city = c
    } 
}
```



## final

+ 使用 final 声明的类不能有子类
+ 使用 final 声明的方法不能被子类覆写
+ 使用 final 声明的变量即为常量，常量不可以被修改



## 内部类

+ 如果在类 Outer 的内部再定义一个类 Inner，此时 Inner 就称为内部类，而 Outer 就称为外部类
+ **内部类的唯一好处就是可以方便的访问外部类中的私有属性**
+ 使用 static 声明的内部类不能访问非 static 的外部类属性
+ 在外部访问内部类
  + Outer out = new Outer()
  + Outer.Inner in = out.new Inner()
+ 在方法中也可以定义内部类



## 抽象类

在 Java 中，可以创建一个类专门用来当作父类，这种类称为抽象类。抽象类的作用类似于“模板”，其目的是要设计者根据它的格式来修改并创建新类。但是并不能直接由抽象类创建对象，只能由抽象类派生出新的类，再由这个新的类来创建对象。

抽象类的定义与使用规则：

+ 包含一个抽象方法的类必须是抽象类
+ 抽象类和抽象方法都要使用 abstract 关键字声明
+ 抽象方法只需要声明而不需要实现
+ 抽象类必须被子继承，子类（如果不是抽象类）则必须覆写抽象类中的全部抽象方法

```java
abstract class A {
    public A() {
        System.out.println('A 抽象类构造方法')
    }
}

class B extends A {
    public B() {
        System.out.println('B 子类构造方法')
    }
}

public class Demo {
    public static void main(String args[]) {
        B b = new B()
    }
}
```

输出：A 抽象类构造方法 > B 子类构造方法

**之所以调用了 A 类中的无参构造方法，是因为再 B 的无参构造方法中隐含了 super() 语句**



## 接口

接口是一种特殊的类，由全局常量和公共的抽象方法组成

```java
// 接口定义格式
interface 接口名称 {
    全局常量 ;
    抽象方法 ;
}
```

注意：

+ 接口中的抽象方法必须定义为 public 访问权限，这是绝对不可改变的
+ 在接口中如果不写 public 则也是 public 访问权限，并不是 default

**与抽象类一样，接口若要使用也必须通过子类，子类通过 implements 关键字实现接口**

```java
// 实现接口格式，注意：子类可实现多个接口
class 子类 implements 接口A, 接口B, ... {
}
```

如果一个子类既要实现接口又要继承抽象类呢？

```java
// 子类既实现接口又继承抽象类
class 子类 extends 抽象类 implements 接口A, 接口B, ... {
}
```



## 对象的多态性

多态在 java 中有两种体现：方法的重载和覆写以及对象的多态性

对象的多态性主要分为以下两种：

+ 向上转型：子类对象 => 父类对象
+ 向下转型：父类对象 => 子类对象



## 泛型

有时候当定义一个类时，类中属性的类型可能是不确定的，这时候可以使用泛型，由外部指定类型

```java
public class Demo {
    public static void main(String args[]) {
        // 指定 x 属性为 String 类型
        Info i<String> = new Info<String>("北纬20°")；
        // 指定 x 属性为整型
        Info i<Integer> = new Info<Integer>(20)
    }
}

class Info<T> {
    private T x;
    
    public Info(T x) {
        this.x = x;
    }
    
    public T getX() {
        return x;
    }
    
    public setX(T x) {
        this.x = x;
    }
}
```

