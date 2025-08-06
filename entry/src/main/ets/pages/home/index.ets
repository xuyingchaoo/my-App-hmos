import router from '@ohos.router';
import { http } from '../../utils/http';

// Tab配置数据
interface icon {
  icon: string;
  name:string;
  text: string;
}

// sys/user/info

@Component
export struct homeIndex {
  @State showEye: boolean = false
  @State icons:icon[] = [
    { icon: 'images/icon03.png',name:'CustomerForm', text: '新增客户' },
    { icon: 'images/icon02.png',name:'ProductTypeList', text: '新增分类' },
    { icon: 'images/icon03.png',name:'', text: '新增客户' },
    { icon: 'images/icon04.png',name:'', text: '新增入库单' },
    { icon: 'images/icon01.png',name:'', text: '新增销售单' },
    { icon: 'images/icon02.png',name:'', text:  '新增采购单' },
    { icon: 'images/icon03.png',name:'', text: '新增客户' },
    { icon: 'images/icon04.png',name:'', text: '新增入库单' },
  ]
  @State saleSearch:string = '今日'
  @State purchaseSearch:string = '今日'
  toPage?: (name:string) => void;

  private scrollerForScroll: Scroller = new Scroller();
  async getUserInfo(){
    try {
      http.get<TextPickerRangeContent[]>("/sys/user/info").then(res=>{
        if(res.code == 0 && res.data){
          console.info("获取用户数据:", JSON.stringify(res));
        }
      })
    } catch (error){
      console.error("获取用户数据失败:", error);
    }
  }
  aboutToAppear(){
    this.getUserInfo()
  }

  build() {
    Scroll(this.scrollerForScroll) {
      Column() {
        // 头部统计
        Column() {
          Row() {
            Row() {
              Text("库存总数").fontSize(14).margin({ right: 10 }).fontColor('white')
              Image(this.showEye ? 'images/eye-open.png' : 'images/eye-close.png')
                .width(18)
                .height(18)
                .margin({ right: 10 })
                .onClick(() => {
                  this.showEye = !this.showEye
                })
              Text('123213')
                .fontSize(14)
                .fontColor('white')
                .visibility(this.showEye ? Visibility.Visible : Visibility.None)
            }

            Image('images/edit.png').width(20).height(20)
          }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding(10)

          Row() {
            Text('0').fontColor('white').fontWeight(400).fontSize(22).margin({ right: 5 })
            Text('种').fontColor('white')
          }.width('100%').justifyContent(FlexAlign.Start).padding(10)

          Row() {
            Flex({ direction: FlexDirection.Row }) {
              Text("本月出库").fontColor('white').margin({ right: 5 })
              Text("500种").fontColor('white')
            }.width('50%')

            Flex() {
              Text("本月入库").fontColor('white').margin({ right: 5 })
              Text("500种").fontColor('white')
            }.width('50%')
          }.width('100%').justifyContent(FlexAlign.Start).padding(10)
        }

        // 入口区域
        GridRow({
          columns: 4
        }) {
          ForEach(this.icons, (item: icon, index: number) => {
            GridCol() {
              Column() {
                Image(item.icon).width(40).height(40).margin({ bottom: 10 })
                Text(item.text).fontSize(12)
              }
            }.margin({ bottom: 10 }).onClick(()=>{
              if (this.toPage !== undefined && item.name) {
                this.toPage(item.name);
              }
            })
          })

        }
        .backgroundColor('white')
        .margin(10)
        .borderRadius(10)
        .padding({
          top: 20,
          right: 20,
          bottom: 10,
          left: 20
        })

        // 列表展示
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Row() {
              Image('images/sales-board.png').width(20).height(20).margin({ right: 10 })
              Text('销售看板').fontSize(18).fontWeight(500)
            }

            Row() {
              Text('今日')
                .fontSize(14)
                .width(40)
                .textAlign(TextAlign.Center)
                .padding(3)
                .backgroundColor(this.saleSearch == '今日'?'#fff':'')
                .fontColor(this.saleSearch=='今日'?'#3296fa':"#000").onClick(()=>{
                  this.saleSearch = '今日'
              })
              Text('本月').fontSize(14).width(40).textAlign(TextAlign.Center).padding(3)
                .backgroundColor(this.saleSearch == '本月'?'#fff':'')
                .fontColor(this.saleSearch=='本月'?'#3296fa':"#000").onClick(()=>{
                this.saleSearch = '本月'
              })
            }.backgroundColor('#f5f6fa').padding(4).borderRadius(3)
          }.margin({ bottom: 10 })

          GridRow({
            columns: 2,
            gutter: { x: 10, y: 10 },
            breakpoints: {
              value: ["500vp", "500vp"],
              reference: BreakpointsReference.WindowSize
            },
            direction: GridRowDirection.Row
          }) {
            GridCol() {
              Flex({ direction: FlexDirection.Column }) {
                Text('销售金额').width('100%')
                Text('0').width('100%').margin({ top: 10 }).fontWeight('500').fontSize(20)
              }
            }.height('80').padding(15).backgroundColor('#fff8ef').borderRadius(5)

            GridCol() {
              Flex({ direction: FlexDirection.Column }) {
                Text('实际金额(销售)').width('100%')
                Text('0').width('100%').margin({ top: 10 }).fontWeight('500').fontSize(20)
              }
            }.height('80').padding(15).backgroundColor('#f3f7ff').borderRadius(5)

            GridCol() {
              Flex({ direction: FlexDirection.Column }) {
                Text('退货金额').width('100%')
                Text('0').width('100%').margin({ top: 10 }).fontWeight('500').fontSize(20)
              }
            }.height('80').padding(15).backgroundColor('#f4f4fd').borderRadius(5)

            GridCol() {
              Flex({ direction: FlexDirection.Column }) {
                Text('实际金额(退货)').width('100%')
                Text('0').width('100%').margin({ top: 10 }).fontWeight('500').fontSize(20)
              }
            }.height('80').padding(15).backgroundColor('#f4fafc').borderRadius(5)
          }.width("100%").height("100%")
        }
        .backgroundColor('#fff')
        .margin(10)
        .padding(10)
        .borderRadius(6)
        .height(250)


      }.width('100%').justifyContent(FlexAlign.Start)
    }.width('100%').backgroundColor('#F4F6FA').backgroundImage('images/bg.png').backgroundImageSize({width:"100%"}).align(Alignment.TopStart).height("100%")
  }
}
