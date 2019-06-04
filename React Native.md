# React Native

## React Navigation

[官网]: https://reactnavigation.org/docs/en/getting-started.html

### Getting started

+ yarn add react-navigation

+ yarn add react-native-gesture-handler
+ react-native link react-native-gesture-handler
+ 修改 MainActivity.java 文件

操作完以上步骤后执行 react-native run-android，项目报错

原因：android 目录下的 settings.gradle 文件中的一行代码 “\” 使用错误，应修改为 “/”

```js
// 错误代码
project(':react-native-gesture-handler').projectDir = new File(rootProject.projectDir, '..\node_modules\react-native-gesture-handler\android')

// 正确代码
project(':react-native-gesture-handler').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-gesture-handler/android')
```

修改完成后再次执行 react-native run-android 命令，依然报错：

``Execution failed for task ':app:processDebugResources'...等错误信息``

百度后知道了需要重新 build，因此我删除了 android/app/ 目录中的 build 文件夹，并重新重新打开 Android Studio 进行 build，在 build 完成后，会重新生成一个 build 文件夹。

之后再次执行 react-native run-android 后，项目成功跑起

### Moving between screens

下面这个例子定义了两个 stack 类型的页面， Home 和 Details，这两个组件都在 ``createStackNavigator `` 方法中进行注册，页面跳转可以使用 ``this.props.navigation``  对象中的 navigate 或者 push 方法。

至于它们两者的区别可以看例子中的注释

```jsx
import React from "react";
import { View, Text, Button } from "react-native";
import { createStackNavigator, createAppContainer } from "react-navigation";

// 定义一个 Home 页面
class HomeScreen extends React.Component {
  render() {
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
        <Text>Home Screen</Text>
         {/* 点击这个按钮会跳转到 Home 页面 */}
        <Button
          title="Go to Details"
          {/* navigation 属性被传递到 stackNavigation 中的每个屏幕组件 */}
          onPress={() => this.props.navigation.navigate('Details')}
        />
      </View>
    );
  }
}

// 定义一个 Details 页面
class DetailsScreen extends React.Component {
  render() {
    return (
      <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
        <Text>Details Screen</Text>
         {/* 在 Details 页面中放置了一个按钮，该按钮的作用是点击仍然跳转到 Details 页面，也就是自身。那么在自身跳转到自身会怎么样呢？*/}
         {/* 如果调用 navigate 方法调转到自身页面，则什么事情都不会发生，因为已经在本页面了 */}
         {/* 如果调用 push 方法调转到自身页面，则会进行跳转动作，且这个动作会加入到跳转历史里，也就是当点击返回上一页时，会仍然返回该页面 */}
         <Button
          title="Go to Details... again"
          onPress={() => this.props.navigation.push('Details')}
        />
      </View>
    );
  }
}

// createStackNavigator 是一个返回 React 组件的方法，它接收两个参数
// 参数1：route 配置对象
// 参数2：可选的 options 对象
const AppNavigator = createStackNavigator(
  {
    Home: HomeScreen,
    Details: DetailsScreen
  },
  {
    initialRouteName: "Home"
  }
);

const AppContainer = createAppContainer(AppNavigator);

export default class App extends React.Component {
  render() {
    return <AppContainer />;
  }
}
```

```
this.props.navigation.goBack()	// 返回上一页

this.props.navigation.poptotop()	// 返回 stack 中的第一个
```

### Navigation lifecycle

在真实的手机场景中，从页面 A 跳转到页面 B，页面 A 仍然存活并没有销毁，正式这样的机制导致我们按下返回键时会迅速切换回上一页而无需加载。但从 B 返回 A 时，B 被销毁。

在 stack navigator 路由 A 和 B 中，默认首页是 A，进入 A 时，A 的 `componentDidMount` 将会被触发，在 A 中跳转至 B 时，B 的`componentDidMount` 触发，但 A 不会触发`componentWillUnmount` ，当从 B 中返回至 A 时，B 的 `componentWillUnmount` 被触发，但 A 不会再次触发 `componentDidMount` 

### 知识点

#### 导航的生命周期



#### 向路由传递参数

传递：this.props.navigation.navigate('RouteName', { /* params go here */ })

获取：this.props.navigation.getParam(paramName, defaultValue)

#### 配置页面 Header

```jsx
// 在自己的组件内部添加一个静态对象 navigationOptions
class AskScreen extends React.Component {
  static navigationOptions = {
    title: '问答',			   // 标题
    headerStyle: {	 			// 头部样式
      backgroundColor: '#f4511e',
    },
    headerTintColor: '#fff',	// 文字颜色
    headerTitleStyle: {			// 文字样式
      fontWeight: 'bold',	
    },
    headerTitle: <LogoTitle />，			// 该属性值可以是一个组件，现在还不清楚使用规则
    headerLeft: <LeftComponent />,		// 左侧按钮
    headerRight: <RightComponent />,	// 右侧按钮
  };
}
```

但为每一个页面单独配置主题色会非常繁琐，因为通常一款 App 的主题色都一致，因此可以配置全局默认的 navigationOptions，在根组件 App.js 中进行配置

```jsx
import HomeScreen from './src/pages/Home'
import AskScreen from './src/pages/Ask'
import { createAppContainer, createStackNavigator } from 'react-navigation';

const AppNavigator = createStackNavigator({
  Home: {
    screen: HomeScreen,
  },
  Ask: {
    screen: AskScreen,
  },
}, {
    initialRouteName: 'Home',
    // 此处配置默认的全局 Header 样式
    defaultNavigationOptions: {
      headerStyle: {
        backgroundColor: '#f4511e',
      },
      headerTintColor: '#fff',
      headerTitleStyle: {
        fontWeight: 'bold',
      },
    },
});

export default createAppContainer(AppNavigator);

```















