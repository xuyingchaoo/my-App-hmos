import { http } from '../../utils/http';
interface customerParams {
  id:number;
}
interface customer {
  id: number;
  createDate:string;
  name: string;
  status?:number
}

interface listParams {
  page:number;
  limit:number;
  orderField: string;
  order:string
  keys:string
}

interface customerResult {
  total:number;
  size:string;
  current: string;
  pages:number
  records:Array<customer>
}
interface PopInfo{
  refresh:number
}
@Builder
export function CustomerListBuilder() {
  CustomerListPage()
}

@Component
struct CustomerListPage {
  @State isRefreshing: boolean = false
  @State arr: String[] = ['0', '1', '2', '3', '4','5','6','7']
  @State list:customer[] = []
  @State keys:string = ''
  private page:number = 1
  private limit:number = 15
  private total:number = 0
  pageStack: NavPathStack = new NavPathStack()

  async getCustomerList(){
    this.isRefreshing = true
    console.info('---',JSON.stringify({ page:this.page,limit:this.limit,orderField:'create_date',order:'desc',keys:this.keys}))
    try {
      http.get<customerResult>("/sales/customer/page",{ page:this.page,limit:this.limit,orderField:'create_date',order:'desc',keys:this.keys} as listParams).then(res=>{
        if(res.code == 0 && res.data){
          this.total = res.data.total
          console.info(this.page+"",res.data.pages)
          if(this.page > res.data.pages){
            console.info('最后一页')
            this.isRefreshing = false
            return
          }
          console.info(JSON.stringify(res.data.records))
          this.list = this.page == 1 ? res.data.records : [...this.list,...res.data.records]
          this.isRefreshing = false
          this.page++
        }
      })
    } catch (error){
      console.error("获取客户列表:", error);
    }
  }
  onPageShow(): void {

  }
  build() {
    NavDestination() {
      Column() {
        TextInput({ placeholder: '请输入客户名称/客户简称进行搜索' }).id('keys').onChange((value: string) => {
          this.keys = value
        }).margin(10).onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
          // 按下输入法回车键时触发该回调
          console.info('onSubmit is triggering: ', enterKey, event.text);
          this.page = 1
          this.list = []
          this.getCustomerList()
        })
        if (this.list.length == 0){
          Column(){
            Image('images/empty.png').width(100).height(100)
            Text('暂无数据').fontColor('#999')
          }.margin({top:'200px'})
        }

        Refresh({ refreshing: $$this.isRefreshing }) {
          List() {
            ListItemGroup() {
              ForEach(this.list, (item: customer, index: number) => {
                ListItem() {
                    Column() {
                      Flex({ direction: FlexDirection.Row }) {
                        Text(item.status == 1 ? "可用" : "禁用")
                          .margin({ right: 5,bottom:5 })
                          .fontSize(12)
                          .backgroundColor(item.status == 1 ? '#eafbec' : '#f9cdd3')
                          .fontColor(item.status == 1 ?'#24d341': '#FE2D46')
                          .padding({
                            left: 4,
                            right: 4,
                            top: 2,
                            bottom: 2
                          })
                          .borderRadius(5)
                        Text(item.name).margin({ bottom:5 })

                      }
                      .width('100%').margin({ top: 5 })

                    Row() {
                      Text(item.createDate).fontSize(12).fontColor('#8c8c8c').textAlign(TextAlign.Start)
                    }.width('100%')
                  }.padding({ left: 10, right: 10, bottom: 10 }).border({
                    width: { bottom: 1 }, color: { bottom: '#f5f6fa' }
                  })


                }.onClick(() => {
                  this.pageStack.pushPathByName("CustomerDetails", {id:item.id} as customerParams, (popInfo)=>{
                    if(popInfo.result == 1){
                      this.page = 1
                      this.getCustomerList()
                    }
                  })
                })
                  // this.pageStack.pushPath({name:"CustomerDetails",param:{id:item.id}as customerParams})
                  // this.getUIContext().getRouter().pushUrl({ url: 'pages/customer/details', params: { id: item.id } });
              })
            }
          }.onReachEnd(() => {
            this.getCustomerList()
            console.info('onReachEnd')
          })
          .sticky(StickyStyle.Header) // 切换是否吸顶
          .width('100%')
          .height('100%')
        }
        .onStateChange((refreshStatus: RefreshStatus) => {
          if (refreshStatus == RefreshStatus.OverDrag) {
            this.page = 1
            this.getCustomerList()
          }
        })
      }
    }.title("客户列表").onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack
    })
  }
}
