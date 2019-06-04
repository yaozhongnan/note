# React-Component

## Checkbox

```jsx
import React from 'react';
import PropTypes from 'prop-types';
import PureRenderMixin from 'rc-util/lib/PureRenderMixin';
import classNames from 'classnames';

export default class Checkbox extends React.Component {
  // 定义了 Input 的原生属性
  static propTypes = {
    prefixCls: PropTypes.string,
    className: PropTypes.string,
    style: PropTypes.object,
    name: PropTypes.string,
    id: PropTypes.string,
    type: PropTypes.string,
    defaultChecked: PropTypes.oneOfType([PropTypes.number, PropTypes.bool]),
    checked: PropTypes.oneOfType([PropTypes.number, PropTypes.bool]),
    disabled: PropTypes.bool,
    onFocus: PropTypes.func,
    onBlur: PropTypes.func,
    onChange: PropTypes.func,
    onClick: PropTypes.func,
    tabIndex: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
    readOnly: PropTypes.bool,
    autoFocus: PropTypes.bool,
    value: PropTypes.any,
  };
  // 默认属性，即使用户什么都不传，也会存在下列默认属性
  static defaultProps = {
    prefixCls: 'rc-checkbox',
    className: '',
    style: {},
    type: 'checkbox',
    defaultChecked: false,
    onFocus() {},
    onBlur() {},
    onChange() {},
  };
  constructor(props) {
    super(props);

    const checked = 'checked' in props ? props.checked : props.defaultChecked;

    this.state = {
      checked,
    };
  }

  componentWillReceiveProps(nextProps) {
    if ('checked' in nextProps) {
      this.setState({
        checked: nextProps.checked,
      });
    }
  }

  shouldComponentUpdate(...args) {
    return PureRenderMixin.shouldComponentUpdate.apply(this, args);
  }

  focus() {
    this.input.focus();
  }

  blur() {
    this.input.blur();
  }
  
  // checkbox 的 onchange 事件走的该方法
  handleChange = (e) => {
    // 获取用户传递的 props 属性
    const { props } = this;
    // 判断该 checkbox 是否被禁用
    if (props.disabled) {
      return;
    }
    
    if (!('checked' in props)) {
      this.setState({
        checked: e.target.checked,
      });
    }
    // 调用用户传递的 onChange 方法，并传递参数
    props.onChange({
      target: {
        ...props,
        checked: e.target.checked,
      },
      stopPropagation() {
        e.stopPropagation();
      },
      preventDefault() {
        e.preventDefault();
      },
      nativeEvent: e.nativeEvent,
    });
  };

  saveInput = (node) => {
    this.input = node;
  }

  render() {
    const {
      prefixCls,
      className,
      style,
      name,
      id,
      type,
      disabled,
      readOnly,
      tabIndex,
      onClick,
      onFocus,
      onBlur,
      autoFocus,
      value,
      ...others,
    } = this.props;

	// 过滤出自定义属性
    const globalProps = Object.keys(others).reduce((prev, key) => {
      if (key.substr(0, 5) === 'aria-' || key.substr(0, 5) === 'data-' || key === 'role') {
        prev[key] = others[key];
      }
      return prev;
    }, {});

    const { checked } = this.state;
    // 设置 className
    const classString = classNames(prefixCls, className, {
      // 该 classname 的添加与否取决于 checked 的值
      [`${prefixCls}-checked`]: checked,
      [`${prefixCls}-disabled`]: disabled,
    });

    return (
      <span className={classString} style={style}>
        <input
          name={name}
          id={id}
          type={type}
          readOnly={readOnly}
          disabled={disabled}
          tabIndex={tabIndex}
          className={`${prefixCls}-input`}
          checked={!!checked}
          onClick={onClick}
          onFocus={onFocus}
          onBlur={onBlur}
          onChange={this.handleChange}
          autoFocus={autoFocus}
          ref={this.saveInput}	{/* react 中的 ref，获取 dom 对象 */}
          value={value}
          {...globalProps}
        />
        <span className={`${prefixCls}-inner`} />
      </span>
    );
  }
}

```

