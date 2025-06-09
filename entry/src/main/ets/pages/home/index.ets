import router from '@ohos.router';

// Tab配置数据
interface icon {
  icon: string;
  url:string;
  text: string;
}
@Entry
@Component
export struct homeIndex {
  @State showEye: boolean = false
  @State icons:icon[] = [
    { icon: 'images/icon01.png',url:'pages/login/index', text: '登录' },
    { icon: 'images/icon02.png',url:'images/list-active.png', text: '新增采购单' },
    { icon: 'images/icon03.png',url:'images/statistics-active.png', text: '新增客户' },
    { icon: 'images/icon04.png',url:'images/base-active.png', text: '新增入库单' },
    { icon: 'images/icon01.png',url:'images/home-active.png', text: '新增销售单' },
    { icon: 'images/icon02.png',url:'images/list-active.png', text: '新增采购单' },
    { icon: 'images/icon03.png',url:'images/statistics-active.png', text: '新增客户' },
    { icon: 'images/icon04.png',url:'images/base-active.png', text: '新增入库单' },
  ]
  build() {
    Column() {
      // 头部统计
      Column(){
        Row(){
          Row(){
            Text("库存总数").fontSize(14).margin({right:10}).fontColor('white')
            Image( this.showEye ? 'images/eye-open.png' : 'images/eye-close.png').width(18).height(18).margin({right:10}).onClick(()=>{
              this.showEye = !this.showEye
            })
            Text('123213').fontSize(14).fontColor('white').visibility(this.showEye ? Visibility.Visible : Visibility.None)
          }
          Image('images/edit.png').width(20).height(20)
        }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding(10)
        Row(){
          Text('0').fontColor('white').fontWeight(400).fontSize(22).margin({right:5})
          Text('种').fontColor('white')
        }.width('100%').justifyContent(FlexAlign.Start).padding(10)
        Row(){
          Flex({direction:FlexDirection.Row}){
            Text("本月出库").fontColor('white').margin({right:5})
            Text("500种").fontColor('white')
          }.width('50%')
          Flex(){
            Text("本月入库").fontColor('white').margin({right:5})
            Text("500种").fontColor('white')
          }.width('50%')
        }.width('100%').justifyContent(FlexAlign.Start).padding(10)
      }
      // Flex({direction:FlexDirection.Row,wrap:FlexWrap.Wrap}){
      //
      // }
      GridRow({
        columns:4
      }){
        ForEach(this.icons,(item:icon,index:number)=>{
          GridCol(){
            Column(){
              Image(item.icon).width(40).height(40).margin({bottom:10})
              Text(item.text).fontSize(12)
            }
          }.margin({bottom:10}).onClick(()=>{
            router.push({url:item.url})
          })
        })

      }.backgroundColor('white').margin(10).borderRadius(10).padding({top:20,right:20,bottom:10,left:20})
    }.width('100%').height('100%').justifyContent(FlexAlign.Start).backgroundImage('images/bg.png').backgroundColor('#F4F6FA')
  }
}
