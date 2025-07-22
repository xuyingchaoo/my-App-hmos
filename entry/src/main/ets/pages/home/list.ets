interface icon {
  icon: string;
  url:string;
  text: string;
}
@Entry
@Component
export struct ListPage {
  @State isRefreshing: boolean = false
  @State arr: String[] = ['0', '1', '2', '3', '4','5','6','7']
  @State icons:icon[] = [
    { icon: 'images/icon01.png',url:'pages/login/index', text: '销售单列表' },
    { icon: 'images/icon02.png',url:'images/list-active.png', text: '销售退货单列表' },
    { icon: 'images/icon03.png',url:'images/statistics-active.png', text: '客户列表' },
    { icon: 'images/icon04.png',url:'images/base-active.png', text: '新增入库单' },
    { icon: 'images/icon01.png',url:'images/home-active.png', text: '新增销售单' },
    { icon: 'images/icon02.png',url:'images/list-active.png', text:  '新增采购单' },
    { icon: 'images/icon03.png',url:'images/statistics-active.png', text: '新增客户' },
    { icon: 'images/icon04.png',url:'images/base-active.png', text: '新增入库单' },
  ]
  @Builder
  // itemHead(){
  //   Column(){
  //     Text("顶部内容")
  //   }.width('100%')
  //   .height('50px')
  //   .backgroundColor('#999999')
  // }


  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing}) {
        List() {
          ListItemGroup(){
            ForEach(this.icons, (item: icon) => {
              ListItem() {
                Row(){
                  Image(item.icon).width(40).height(40).margin({right:10})
                  Text(item.text)
                }.alignItems(VerticalAlign.Center).padding(10).width('100%').border({
                  width:{bottom:1},color:{bottom:'#eaebed'}
                })
              }
            })
          }
        }
        .onReachEnd(() => {
          console.info("触发加载")
        })
        // .sticky(StickyStyle.None)
        .sticky(StickyStyle.Header) // 切换是否吸顶
        .width('100%')
        .height('100%')
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('状态变化' + refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 2000)
        console.log('进入刷新')
      })
    }
  }
}
