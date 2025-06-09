@Entry
@Component
export struct ListPage {
  @State isRefreshing: boolean = false
  @State arr: String[] = ['0', '1', '2', '3', '4','5','6','7']

  @Builder
  itemHead(){
    Column(){
      Text("顶部内容")
    }.width('100%')
    .height('50px')
    .backgroundColor('#999999')
  }


  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing}) {
        List() {
          ListItemGroup({ header: this.itemHead()}){
            ForEach(this.arr, (item: string) => {
              ListItem() {
                Text('' + item)
                  .width('100%').height(100).fontSize(16)
                  .textAlign(TextAlign.Center).borderRadius(10).backgroundColor(0xFFFFFF)
                  .margin({top:10,bottom:10})
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
      .backgroundColor(0x89CFF0)
    }
  }
}
