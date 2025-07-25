import Logger from '../../model/Logger'
import { http } from '../../utils/http';
import apiConfig from '../../../resources/base/profile/api_config.json';
import { util } from '@kit.ArkTS';
import { CryptoJS } from '@ohos/crypto-js'
import { PromptAction } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

interface FormData{
  mobile:string;
  password:string|number;
  uuid:string
  imageCode:string
}
interface TokenInfo { //根据项目实际项目修改
  token?: string;
  tenantList:Array<tenantInfo>
}
interface tenantInfo { //根据项目实际项目修改
  corpId:string;
  id:string;
  name:string
}

function doEncryptPsd(plainText:string){
  let key = CryptoJS.enc.Utf8.parse("1234567890123456");; //长度16
  let iv =  CryptoJS.enc.Utf8.parse("1234567890123456"); //长度16
  const word = CryptoJS.enc.Utf8.parse(plainText);
  const encrypted = CryptoJS.AES.encrypt(word, key, {
    iv:iv,
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.ZeroPadding})  //传参为加密内容及秘钥
  Logger.info('doEncryptPsd encrypted',CryptoJS.enc.Base64.stringify(encrypted.ciphertext));

  return CryptoJS.enc.Base64.stringify(encrypted.ciphertext);
}

@Entry
@Component
struct LoginInfo {
  @State mobile: string = '13612345678'
  @State password: string = 'admin'
  @State imageCode: string = ''
  @State resultJson: string = ''
  @State uuid: string = util.generateRandomUUID(true)
  @State codeImg:string = apiConfig['dev'].baseUrl+`/captcha.jpg?uuid=${this.uuid}`
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  controller: webview.WebviewController = new webview.WebviewController();

  // 登录
  doLogin(data:FormData){
    Logger.info(JSON.stringify(data))
    try {
      http.post<TokenInfo>("/auth/login/password", data).then((res)=>{
        console.info('res',JSON.stringify(res))
        if(res.code != 0){
           this.doRefreshCode()
        }
        if(res.code == 0){
          this.promptAction.showToast({
            message: '登录成功!',
            duration: 2000
          })
          const tenantList = res.data?.tenantList || []
          AppStorage.setOrCreate('token',res.data?.token)
          AppStorage.setOrCreate('tenantId',tenantList.length ? tenantList[0]?.id : '')
          this.getUIContext().getRouter().pushUrl({ url: "pages/Home" });
        }
      }).catch((err:Error)=>{
        console.info('err',JSON.stringify(err))
      })
    }catch (e) {
      console.error("异常2:" + JSON.stringify(e))
    }
  }
  doRefreshCode(){
    this.uuid = util.generateRandomUUID(true)
    this.codeImg = apiConfig['dev'].baseUrl+`/captcha.jpg?uuid=${this.uuid}`
  }
  build() {
    Column() {
      Row() {
        Text($r('app.string.app_name'))
          .margin(10)
          .fontSize(18)
          .textAlign(TextAlign.End)
      }
      .margin({ top: '10%' })
      .padding({ left: 5 })

      Row() {
        TextInput({ placeholder: '请输入手机号',text:this.mobile })
          .margin(10)
          .width('75%')
          .fontSize(20)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .onChange((value: string) => {
            this.mobile = value
          })
      }
      .padding({ left: 5 })

      Row() {
        TextInput({ placeholder: '请输入密码',text:this.password })
          .id('password')
          .margin(10)
          .width('75%')
          .fontSize(20)
          .maxLength(20)
          .type(InputType.Password)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .onChange((value: string) => {
            this.password = value
          })
      }
      .padding({ left: 5 })

      Row(){
        TextInput({ placeholder: '请输入验证码' })
          .id('code')
          .margin(10)
          .width('40%')
          .fontSize(20)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .onChange((value: string) => {
            this.imageCode = value
          })
        Image(this.codeImg).width('30%').onClick(()=>{
          this.doRefreshCode()
          console.info('1111---',this.codeImg)

        })
      }

      Button("登录")
        .id('login')
        .margin(10)
        .width('60%')
        .fontSize(20)
        .fontColor(Color.White)
        .type(ButtonType.Capsule)
        .onClick(async () => {
          Logger.info(this.codeImg)
          if (this.mobile === '' || this.password === '' || this.imageCode === '') {
            AlertDialog.show(
              {
                message: "请将手机号/密码/验证码填写完整",
                confirm: {
                  value: "确定",
                  action: () => {}
                },
                cancel: () => {}
              })
          } else {
            const psd = doEncryptPsd(this.password)
            Logger.info(JSON.stringify(psd))

            const data:FormData = {
              mobile: this.mobile,
              password: psd,
              uuid:this.uuid,
              imageCode:this.imageCode,
            }
            Logger.info(JSON.stringify(data))
            this.doLogin(data)
          }
        })
    }.height('100%')
    .width('100%')
  }
}