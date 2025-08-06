import { http } from '../../utils/http';
import { PromptAction } from '@kit.ArkUI';
import { TreeView,TreeController,NodeParam } from '@kit.ArkUI';

interface TypeTree {
  id?: number;
  name?: string;
  text?: string;
  value?:string;
  childList?: Array<TypeTree>
  children?:Array<TypeTree>
}
interface QueryParams {
  name: string;
  parentId:string;
}
function addTextProperty(data: TypeTree[]) {
  return data.map(item => {
    const newItem: TypeTree = JSON.parse(JSON.stringify(item))
    newItem.value = item.name
    // 递归处理子级
    if (newItem.childList && newItem.childList.length) {
      newItem.childList = addTextProperty(newItem.childList);
    }
    return newItem;
  });
}
@Builder
export function ProductTypeListBuilder() {
  ProductTypeListPage()
}
// 新增分类弹窗
@CustomDialog
struct AddTypeDialog {
  @State typeList: TypeTree[] = [];
  @State secTypeList: TypeTree[] = [];
  @State parentId:number = 0
  @State name:string = ''
  @State firstValue:string = '请选择一级分类'
  @State secValue:string = '请选择二级分类'
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  controllerTwo?: CustomDialogController;

  async getTypeTree() {
    try {
      http.get<TypeTree[]>("/product/type/tree-list").then(res => {
        if (res.code == 0 && res.data) {
          const list = addTextProperty(JSON.parse(JSON.stringify(res.data)))
          this.typeList = JSON.parse(JSON.stringify(list))
          this.secTypeList = [{text:'请选择分类'}]
          console.info(JSON.stringify(this.typeList))
        }
      })
    } catch (error) {
      console.error("获取数据失败:", error);
    }
  }
  // addTextProperty(data: TypeTree[]) {
  //   return data.map(item => {
  //     const newItem: TypeTree = JSON.parse(JSON.stringify(item))
  //     newItem.value = item.name
  //     // 递归处理子级
  //     if (newItem.childList && newItem.childList.length) {
  //       newItem.childList = this.addTextProperty(newItem.childList);
  //     }
  //     return newItem;
  //   });
  // }
  build() {
    Column() {
      Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}){
        Select(this.typeList as SelectOption[]).width('90%').onAppear(()=>{
          this.getTypeTree()
        }).value(this.firstValue).onSelect((index:number,value:string)=>{
          const row = this.typeList[index]
          this.secTypeList = row.childList as TypeTree[] || []
          this.parentId = row.id as number
          this.firstValue = value
          this.secValue = '请选择二级分类'
          console.info('parentId',this.parentId, JSON.stringify(row))
        })
        Text('清除').lineHeight(18).fontSize(12).onClick(()=>{
          this.firstValue = '请选择一级分类'
          this.secValue = '请选择二级分类'
          this.secTypeList = []
        })
      }.margin({bottom:20})
      Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}) {
        Select(this.secTypeList as SelectOption[])
          .width('90%')
          .value(this.secValue)
          .onSelect((index: number,value:string) => {
            const row = this.secTypeList[index]
            this.parentId = row.id as number
            this.secValue = value
            console.info('parentId', this.parentId)
          })
        Text('清除').lineHeight(18).fontSize(12).onClick(()=>{
          this.secValue = '请选择二级分类'
        })
      }.margin({ bottom: 20 })


      TextInput({ placeholder: '请输入分类名称（必填）',text:this.name }).id('name').onChange((value: string) => {
        this.name = value
      })
      Row(){
        Button('取消',{buttonStyle: ButtonStyleMode.NORMAL}).onClick(()=>{
          this.controllerTwo?.close()
        }).margin({right:20})
        Button('确认')
          .onClick(() => {
            if(this.name === ''){
              this.promptAction.showToast({
                message: '请填写分类名称',
                duration: 2000
              })
            }else{
              console.info('QueryParams',JSON.stringify({name:this.name,parentId:this.parentId}))
              http.post<QueryParams>("/product/type/create", {name:this.name,parentId:this.parentId || '0'} as QueryParams).then(res => {
                console.info(JSON.stringify(res))
                if (res.code == 0 && res.data) {
                  this.promptAction.showToast({
                    message: '提交成功',
                    duration: 2000
                  })
                  this.controllerTwo?.close()
                  // this.getUIContext().getRouter().back({ url: "pages/Home" });
                } else {
                  this.promptAction.showToast({
                    message: res.msg,
                    duration: 2000
                  })
                }
              }).catch((err: Error) => {
                console.error("异常1:" + JSON.stringify(err))
              })
            }
          })
      }.margin({top:20})


    }.padding(20)
  }
}
@Component
struct ProductTypeListPage {
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: AddTypeDialog(),
  })
  private treeController: TreeController = new TreeController();
  async getTypeTree() {
    try {
      http.get<TypeTree[]>("/product/type/tree-list").then(res => {
        if (res.code == 0 && res.data) {
          // const list = addTextProperty(JSON.parse(JSON.stringify(res.data)))
          res.data.map(item=>{
            this.treeController.addNode({
              parentNodeId:-1, currentNodeId: item.id, isFolder: true, primaryTitle: item.name
            })
            if(item.childList?.length){
              this.handleChild(item.childList, item.id as number)
            }
          })
          this.treeController.buildDone();
        }
      })
    } catch (error) {
      console.error("获取数据失败:", error);
    }
  }
  handleChild(list:TypeTree[],parentId:number){
    list.map(item=>{
      this.treeController.addNode({
        parentNodeId:parentId, currentNodeId: item.id, isFolder: false, primaryTitle: item.name
      })
      if(item.childList?.length){
        this.handleChild(item.childList, item.id as number)
      }
    })
  }
  aboutToAppear(): void {
    this.getTypeTree()
  }

  build() {
    NavDestination() {
      Column() {
        Text('分类列表')
        Button('+', { type: ButtonType.Circle}).fontSize(20).onClick(()=>{
          this.dialogController?.open()
        })
        TreeView({ treeController: this.treeController })
      }
    }
  }
}
