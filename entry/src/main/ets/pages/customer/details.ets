import { http } from '../../utils/http';
import { PromptAction } from '@kit.ArkUI';

interface QueryParams {
  id?:string;
}
interface DeleteParams {
  data:Array<string>
}
interface Details {
  id:string
  name:string
  simpleName:string
  remarks:string
  status:number
  contact:string
  mobile:string
  addr:string
}
@Builder
export function CustomerDetailsBuilder() {
  CustomerDetails()
}
@Component
struct CustomerDetails {
  @State customerInfo:Details = {} as Details
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  pathStack: NavPathStack = new NavPathStack()

  async getCustomerInfo(id:string){
    try {
      http.get<Details>("/sales/customer/info",{id} as QueryParams).then(res=>{
        console.info("获取用户数据:", JSON.stringify(res));
        if(res.code == 0 && res.data){
          this.customerInfo = res.data
        }
      })
    } catch (error){
      console.error("获取用户数据失败:", error);
    }
  }
  aboutToAppear(){
    console.info('CustomerDetails----------------',JSON.stringify(this.pathStack.getParamByName('id')))

  }
  // onPageShow(): void {
  //   const params = router.getParams() as QueryParams
  //   if(params.id){
  //     this.getCustomerInfo(params.id)
  //   }
  // }

  build() {
    NavDestination(){
      Column(){
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text('客户名称')
          Text(this.customerInfo.name).fontColor('#595959')
        }.width('100%').border({
          width:{bottom:1},color:{bottom:'#f5f6fa'}
        }).padding({bottom:15,top:15})
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text('客户简称')
          Text(this.customerInfo.simpleName).fontColor('#595959')
        }.width('100%').border({
          width:{bottom:1},color:{bottom:'#f5f6fa'}
        }).padding({bottom:15,top:15})
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text('状态')
          Text(this.customerInfo.status == 1 ? '启用' : '禁用').fontColor('#595959')
        }.width('100%').border({
          width:{bottom:1},color:{bottom:'#f5f6fa'}
        }).padding({bottom:15,top:15})
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text('备注')
          Text(this.customerInfo.remarks).fontColor('#595959')
        }.width('100%').border({
          width:{bottom:1},color:{bottom:'#f5f6fa'}
        }).padding({bottom:15,top:15})
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text('联系人')
          Text(this.customerInfo.contact).fontColor('#595959')
        }.width('100%').border({
          width:{bottom:1},color:{bottom:'#f5f6fa'}
        }).padding({bottom:15,top:15})
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text('联系方式')
          Text(this.customerInfo.mobile).fontColor('#595959')
        }.width('100%').border({
          width:{bottom:1},color:{bottom:'#f5f6fa'}
        }).padding({bottom:15,top:15})
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text('联系地址')
          Text(this.customerInfo.addr).width('70%').fontColor('#595959')
        }.width('100%').border({
          width:{bottom:1},color:{bottom:'#f5f6fa'}
        }).padding({bottom:15,top:15})
        Row(){
          Button('删除').borderRadius(50).backgroundColor('#FA3131').fontSize(18).width('46%').margin({left:'2%',right:'2%'}).height(50).onClick(()=>{
            this.promptAction.showDialog({
              title: '提示',
              message: '是否确认删除？',
              buttons: [
                {
                  text: '取消',
                  color: '#999'
                },
                {
                  text: '删除',
                  color: '#FA3131'
                }
              ]
            }, (err, data) => {
              if (err) {
                console.error('showDialog err: ' + err);
                return;
              }
              console.info('showDialog success callback, click button: ' + data.index);
              if(data.index == 1){
                http.delete<Details>("/sales/customer/delete",{data:[this.customerInfo.id]} as DeleteParams).then(res=>{
                  if(res.code == 0){
                    console.info("删除成功:", JSON.stringify(res));
                    this.promptAction.showToast({
                      message: '删除成功！',
                      duration: 2000
                    })
                    this.pathStack.pop(1)
                    // this.getUIContext().getRouter().back()
                  }
                })
              }

            });
          })
          Button('编辑').borderRadius(50).fontSize(18).width('46%').margin({left:'2%',right:'2%'}).height(50).onClick(()=>{
            this.pathStack.pushPathByName('CustomerForm',{id:this.customerInfo.id} as QueryParams)
          })
        }.margin({top:40})
      }.padding(10)
    }.title('客户详情').onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      const query = this.pathStack.getParamByName("CustomerDetails") as QueryParams[]
      console.info(JSON.stringify(query))
      if(query.length && query[0].id){
        this.getCustomerInfo(query[0].id)
      }
    })
  }
}