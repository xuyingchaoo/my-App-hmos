import router from '@ohos.router'
import Logger from '../../model/Logger'
import { AccountData } from '../../model/AccountData'
import { AccountModel } from '../../model/AccountModel'
import { http } from '../../utils/http';
import apiConfig from '../../../resources/base/profile/api_config.json';
import { util } from '@kit.ArkTS';
import { AegAesCbc } from '@hw-agconnect/petal-aegis';
import { buffer } from '@kit.ArkTS';

const TAG: string = '[LoginInfo]'
interface FormData{
  mobile:string;
  password:string|number;
  uuid:string
  imageCode:string
}
interface ApiResponse { //根据项目实际项目修改
  code?: number;
  data: object | null;
  message?: string;
}
function doLogin(data:FormData){
  Logger.info(JSON.stringify(data))
  return http.post<ApiResponse>("ucenter/auth/login/password", data)
}
async function doAesCbc(plainText:string): Promise<string> {
  let key = '1234567891234567'; //长度16，实际使用时建议使用安全随机数生成，不能硬编码在代码中
  let iv = '9876543217654321'; //长度16，实际使用时建议使用安全随机数生成，不能硬编码在代码中
  let keyUint8 = new Uint8Array(buffer.from(key, 'utf-8').buffer);
  let ivUint8 = new Uint8Array(buffer.from(iv, 'utf-8').buffer);

  try {
    let encryptText = await AegAesCbc.ohAegAesCbcEncTextHex(plainText, keyUint8, ivUint8);
    Logger.info("aescbc2 ", 'encryptText: ' + encryptText);

    let decryptText = await AegAesCbc.ohAegAesCbcDecTextHex(encryptText, keyUint8);
    if (plainText === decryptText) {
      Logger.info('aescbc2 decrypt ok');
      return encryptText
    }
    Logger.info("aescbc2 ", 'decryptText: ' + decryptText);

    return ''
  } catch (err) {
    Logger.info("aescbc2 ", 'err: ' + err);
    return ''
  }
}

@Component
export struct LoginInfo {
  @State mobile: string = '13612345678'
  @State password: string = 'admin'
  @State imageCode: string = ''
  @State resultJson: string = ''
  @State uuid: string = util.generateRandomUUID(true)
  @Prop bundleName: string
  private storage: AccountData = AccountData.getInstance()
  private accountModel: AccountModel = new AccountModel()
  private codeImg = apiConfig['dev'].baseUrl+`ucenter/captcha.jpg?uuid=${this.uuid}`

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
          .id('mobile')
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
        Image(this.codeImg).width('30%')
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
            // const psd = await doAesCbc(this.password)
            // const data:FormData = {
            //   mobile: this.mobile,
            //   password: psd,
            //   uuid:this.uuid,
            //   imageCode:this.imageCode,
            // }
            //
            // Logger.info(data)
            router.replaceUrl({ url: 'pages/Home' });

            // const result = await doLogin(data)
            // Logger.info(JSON.stringify(result.data))
            // this.resultJson = JSON.stringify(result.data)
          }
        })
        Text(this.resultJson)

    }
  }
}