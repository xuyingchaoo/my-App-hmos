@Entry
@Component
struct CustomerForm {
  @State message: string = 'Hello World';
  build() {
    Column({ space: 20 }) {
      TextInput({ placeholder: '客户名称' })
      TextInput({ placeholder: '客户简称' })
      Row({}){
        Text('性别：')
        Radio({ value: 'Radio1', group: 'radioGroup' }).checked(false)
        Text('男').margin({right:20})
        Radio({ value: 'Radio2', group: 'radioGroup' }).checked(true)
        Text('女')
      }.width('100%').justifyContent(FlexAlign.Start)
      Row({}){
        Text('是否禁用：')
        Toggle({ type: ToggleType.Switch, isOn: false })
      }.width('100%').justifyContent(FlexAlign.Start)
    }.width('100%').padding(20)

    .height('100%')
    .width('100%')
  }
}