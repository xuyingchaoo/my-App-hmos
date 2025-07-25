interface icon {
  icon: string;
  name:string;
  text: string;
}
@Component
export struct ListPage {
  @State isRefreshing: boolean = false
  @State icons:icon[] = [
    { icon: 'images/icon03.png',name:'CustomerList', text: '客户列表' },
    { icon: 'images/icon01.png',name:'', text: '销售单列表' },
    { icon: 'images/icon02.png',name:'', text: '销售退货单列表' },
    { icon: 'images/icon04.png',name:'', text: '新增入库单' },
    { icon: 'images/icon01.png',name:'', text: '新增销售单' },
    { icon: 'images/icon02.png',name:'', text:  '新增采购单' },
    { icon: 'images/icon03.png',name:'', text: '新增客户' },
    { icon: 'images/icon04.png',name:'', text: '新增入库单' },
  ]
  toPage?: (name:string) => void;

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
              }.onClick(()=>{
                if (this.toPage !== undefined && item.name) {
                  this.toPage(item.name);
                }
              })
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
