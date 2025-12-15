@Entry
@Component
struct TodoApp {
  // 1. 定义状态
  @State newTaskName: string = ''; // 输入框的内容
  @State todoList: Array<TodoItem> = []; // 待办列表数据

  build() {
    Column() {
      // --- 标题栏 ---
      Text('我的待办清单')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({ left: 20 })

      // --- 输入区域 ---
      Row() {
        TextInput({ placeholder: '输入待办事项...', text: this.newTaskName })
          .layoutWeight(1) // 占据剩余空间
          .height(45)
          .onChange((value: string) => {
            this.newTaskName = value; // 双向绑定输入框内容
          })
          .onSubmit(() => {
            this.addTodo(); // 回车键提交
          })

        Button('添加')
          .height(45)
          .width(80)
          .margin({ left: 10 })
          .onClick(() => {
            this.addTodo();
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ bottom: 20 })

      // --- 列表区域 ---
      List({ space: 10 }) {
        // 使用 ForEach 渲染列表
        ForEach(this.todoList, (item: TodoItem, index: number) => {
          ListItem() {
            Row() {
              // 完成状态勾选框
              Checkbox({ name: 'checkbox', group: 'todos' })
                .select(item.isFinished)
                .selectedColor(0x007DFF)
                .onChange((value: boolean) => {
                  // 更新完成状态
                  this.todoList[index].isFinished = value;
                  // 强制刷新UI（ArkTS有时对于深层对象属性变化需要重新赋值触发更新）
                  this.todoList = [...this.todoList];
                })

              // 文本内容
              Text(item.content)
                .fontSize(18)
                .margin({ left: 10 })
                .layoutWeight(1)
                .decoration({
                  // 如果完成了，添加删除线
                  type: item.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None,
                  color: Color.Gray
                })
                .fontColor(item.isFinished ? Color.Gray : Color.Black)

              // 删除按钮
              Button('删除')
                .backgroundColor(Color.Red)
                .height(30)
                .fontSize(14)
                .onClick(() => {
                  this.deleteTodo(index);
                })
            }
            .width('100%')
            .padding(15)
            .backgroundColor('#F1F3F5')
            .borderRadius(10)
          }
        }, (item: TodoItem) => JSON.stringify(item)) // Key生成规则
      }
      .layoutWeight(1) // 列表占据剩余的所有高度
      .width('100%')
      .padding({ left: 20, right: 20 })
      .divider({ strokeWidth: 0 }) // 去除默认分割线，因为我们用了卡片式背景
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  // --- 逻辑方法 ---

  // 添加待办
  addTodo() {
    if (this.newTaskName.trim() === '') {
      return; // 空内容不添加
    }
    // 向数组头部添加新项
    const newItem: TodoItem = new TodoItem(this.newTaskName, false);
    this.todoList.unshift(newItem);
    this.newTaskName = ''; // 清空输入框
  }

  // 删除待办
  deleteTodo(index: number) {
    this.todoList.splice(index, 1);
  }
}

// 定义数据模型类（这不属于UI组件，所以放在 struct 外面）
class TodoItem {
  content: string;
  isFinished: boolean;

  constructor(content: string, isFinished: boolean) {
    this.content = content;
    this.isFinished = isFinished;
  }
}