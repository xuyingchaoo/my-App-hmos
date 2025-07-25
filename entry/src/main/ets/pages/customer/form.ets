import { LengthMetrics } from '@kit.ArkUI';
import { http } from '../../utils/http';
import { PromptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import window from '@ohos.window'

interface AreaTree {
  id?: string;
  name?: string;
  text?: string;
  fullName?: string;
  childList?: Array<AreaTree>
}

interface CustomerForm {
  id?: string
  name: string
  simpleName: string
  remarks: string
  status: number
  contact: string
  mobile: string
  addr: string
  regionIds:Array<string>
  statusName:string
}

interface QueryParams {
  id: string;
}

@Builder
export function CustomerFormBuilder() {
  CustomerFormPage()
}
@Entry
@Component
struct CustomerFormPage {
  @State message: string = 'Hello World';
  @State inputContent: string = '';
  @State cascade: TextPickerRangeContent[] = [];
  @State name: string = ''
  @State simpleName: string = ''
  @State remarks: string = ''
  @State status: number = 1
  @State contact: string = ''
  @State mobile: string = ''
  @State addr: string = ''
  @State customerId: string = ''

  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  pathStack: NavPathStack = new NavPathStack()


  aboutToAppear() {
    console.info(
      '-----------------',
      JSON.stringify(
        this.pathStack.getParamByName('CustomerForm')
      )
    )
    // const params = router.getParams() as QueryParams
    // if(params.id){
    //   this.getCustomerInfo(params.id as string)
    // }
  }

  async getCustomerInfo(id: string) {
    try {
      http.get<CustomerForm>("/sales/customer/info", { id } as QueryParams).then(res => {
        if (res.code == 0 && res.data) {
          console.info("获取用户数据:", JSON.stringify(res));
          const info = res.data as CustomerForm
          this.name = info.name
          this.simpleName = info.simpleName
          this.remarks = info.remarks
          this.status = info.status
          this.contact = info.contact
          this.mobile = info.mobile
          this.addr = info.addr
          this.customerId = info.id || ''

        }
      })
    } catch (error) {
      console.error("获取用户数据失败:", error);
    }
  }

  async getAreaTree() {
    try {
      http.get<TextPickerRangeContent[]>("/sys/regions/tree").then(res => {
        if (res.code == 0 && res.data) {
          const list = this.addTextProperty(JSON.parse(JSON.stringify(res.data)))
          this.cascade = JSON.parse(JSON.stringify(list))
        }
      })
    } catch (error) {
      console.error("获取地区数据失败:", error);
    }
  }

  addTextProperty(data: AreaTree[]) {
    return data.map(item => {
      const newItem: AreaTree = JSON.parse(JSON.stringify(item))
      newItem.text = item.name
      // 递归处理子级
      if (newItem.childList && newItem.childList.length) {
        newItem.childList = this.addTextProperty(newItem.childList);
      }
      return newItem;
    });
  }


  submitForm() {
    try {
      const form: CustomerForm = {
        id:this.customerId || '',
        name: this.name,
        simpleName: this.simpleName,
        remarks: this.remarks,
        status: this.status,
        contact: this.contact,
        mobile: this.mobile,
        addr: this.addr,
        regionIds:[],
        statusName:''
      }
      console.info(JSON.stringify(form),form.id ? '/sales/customer/update':"/sales/customer/create")
      if(form.id){
        http.put<QueryParams>('/sales/customer/update', form).then(res => {
          console.info(JSON.stringify(res))
          if (res.code == 0 && res.data) {
            this.promptAction.showToast({
              message: '提交成功',
              duration: 2000
            })
            this.getUIContext().getRouter().back();
          } else {
            this.promptAction.showToast({
              message: res.msg,
              duration: 2000
            })
          }
        }).catch((err: Error) => {
          console.error("异常1:" + JSON.stringify(err))
        })
      }else{
        http.post<QueryParams>("/sales/customer/create", form).then(res => {
          console.info(JSON.stringify(res))
          if (res.code == 0 && res.data) {
            this.promptAction.showToast({
              message: '提交成功',
              duration: 2000
            })
            this.pathStack.pop()
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


    } catch (e) {
      console.error("异常2:" + JSON.stringify(e))
    }
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        TextInput({ placeholder: '客户名称', text: this.name }).onChange((value: string) => {
          this.name = value
        })
        TextInput({ placeholder: '客户简称', text: this.simpleName }).id('simpleName').onChange((value: string) => {
          this.simpleName = value
        })
        Row({}) {
          Radio({ value: '1', group: 'radioGroup' }).checked(true).onChange((value: boolean) => {
            console.info(JSON.stringify(value))
            this.status = value ? 1 : 0
          })
          Text('启用').margin({ right: 20 })
          Radio({ value: '0', group: 'radioGroup' }).checked(false)
          Text('禁用')
        }.width('100%').justifyContent(FlexAlign.Start).id('status')

        TextArea({ placeholder: '备注', text: this.remarks }).height(100).id('remarks').onChange((value: string) => {
          this.remarks = value
        })
        TextInput({ placeholder: '联系人', text: this.contact }).id('contact').onChange((value: string) => {
          this.contact = value
        })
        TextInput({ placeholder: '联系方式', text: this.mobile }).id('contactMobile').onChange((value: string) => {
          this.mobile = value
        })
        TextArea({ placeholder: '详细地址', text: this.addr }).height(100).id('addr').onChange((value: string) => {
          this.addr = value
        })
        Row() {
          Button('取消', { buttonStyle: ButtonStyleMode.NORMAL })
            .borderRadius(50)
            .fontSize(18)
            .width('46%')
            .margin({ left: '2%', right: '2%' })
            .height(50)
            .onClick(() => {
              router.back()
            })
          Button('提交')
            .borderRadius(50)
            .fontSize(18)
            .width('46%')
            .margin({ left: '2%', right: '2%' })
            .height(50)
            .onClick(() => {
              if (this.name === '') {
                AlertDialog.show(
                  {
                    message: "请填写客户姓名",
                    confirm: {
                      value: "确定",
                      action: () => {
                      }
                    },
                    cancel: () => {
                    }
                  })
              } else {
                this.submitForm()
              }
            })
        }

        // TextPicker({ range: this.cascade })
        //   .onChange((value: string | string[], index: number | number[]) => {
        //     console.info('TextPicker 多列联动:onChange ' + JSON.stringify(value) + ', ' + 'index: ' + JSON.stringify(index));
        //   })
        //   .onScrollStop((value: string | string[], index: number | number[]) => {
        //     console.info('TextPicker 多列联动:onScrollStop ' + JSON.stringify(value) + ', ' + 'index: ' + JSON.stringify(index));
        //   }).onAppear(()=>{
        //     this.getAreaTree()
        //   })

      }.width('100%').padding(20)

      .height('100%')
      .width('100%')
    }.title('客户新增').onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}