# TypeScript

TypeScript 是 JavaScript 的超集，它可以编译成纯 JavaScript 



## 类型注解

类型注解是 TypeScript 里为函数或变量添加约束的方式，例：

```typescript
// 声明一个变量，且约束该变量的类型为布尔类型
let bool: boolean = false;

// 为函数参数约束类型，这里约束为字符串类型
function greeter(person: string) {
    return "Hello, " + person;
}
```

