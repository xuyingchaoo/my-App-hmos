import { http } from '../../utils/http';

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
}

interface customerResult {
  total:number;
  size:string;
  current: string;
  pages:number
  records:Array<customer>
}


@Entry
@Component
export struct ListPage {
  @State isRefreshing: boolean = false
  @State arr: String[] = ['0', '1', '2', '3', '4','5','6','7']
  @State list:customer[] = []
  private page:number = 1
  private limit:number = 15
  private total:number = 0

  async getCustomerList(){
    this.isRefreshing = true
    console.info(JSON.stringify({ page:this.page,limit:this.limit,orderField:'create_date',order:'desc'}))
    try {
      http.get<customerResult>("/sales/customer/page",{ page:this.page,limit:this.limit,orderField:'create_date',order:'desc'} as listParams).then(res=>{
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
  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing}) {
        List() {
          ListItemGroup(){
            ForEach(this.list, (item: customer,index:number) => {
              ListItem() {
                Flex({direction:FlexDirection.Column}){
                  Row(){
                    Text(index+"")
                    Text(item.status == 1? "可用":"禁用").margin({right:5}).fontSize(12).backgroundColor('#eafbec').fontColor('#24d341').padding({left:4,right:4,top:2,bottom:2}).borderRadius(5)
                    Text(item.name)
                  }.width('100%').margin({bottom:10,top:5})
                  Row() {
                    Text(item.createDate).fontSize(12).fontColor('#8c8c8c')
                  }
                }.margin({bottom:10}).padding({left:10,right:10,bottom:10}).border({
                  width:{bottom:1},color:{bottom:'#f5f6fa'}
                })
              }
            })
          }
        }.onScrollIndex((start: number, end: number)=>{
          console.info(start+"----",end)
          if(end == this.list.length - 1){
            console.info('触底')
          }
        }).onReachEnd(()=>{
          this.getCustomerList()
          console.info('onReachEnd')
        })
        .sticky(StickyStyle.Header) // 切换是否吸顶
        .width('100%')
        .height('100%')
      }

      .onStateChange((refreshStatus: RefreshStatus) => {
        if(refreshStatus == RefreshStatus.OverDrag){
          this.page = 1
          this.getCustomerList()
        }
      }).onRefreshing(()=>{
        console.info('刷新')
      })
    }
  }
}
