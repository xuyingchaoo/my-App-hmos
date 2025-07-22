import router from '@ohos.router'
import Logger from '../../model/Logger'
import { AccountData } from '../../model/AccountData'
import { AccountModel } from '../../model/AccountModel'
import { http } from '../../utils/http';
import apiConfig from '../../../resources/base/profile/api_config.json';
import { util } from '@kit.ArkTS';
import { AegAesCbc } from '@hw-agconnect/petal-aegis';
import { buffer } from '@kit.ArkTS';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

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
  return http.post<ApiResponse>("/ruiz/auth/login/password", data)
}
async function doAesCbc(plainText:string): Promise<string> {
  let key = '1234567891234567'; //长度16，实际使用时建议使用安全随机数生成，不能硬编码在代码中
  let iv = '1234567891234567'; //长度16，实际使用时建议使用安全随机数生成，不能硬编码在代码中
  let keyUint8 = new Uint8Array(buffer.from(key, 'utf-8').buffer);
  let ivUint8 = new Uint8Array(buffer.from(iv, 'utf-8').buffer);
  Logger.info('ivUint8',ivUint8);
  Logger.info('keyUint8',keyUint8);
  try {
    let encryptText = await AegAesCbc.ohAegAesCbcEncTextHex(plainText, keyUint8, ivUint8);
    Logger.info("aescbc2 ", 'encryptText: ' + encryptText);
    let decryptText = await AegAesCbc.ohAegAesCbcDecTextHex(encryptText, keyUint8);
    if (plainText === decryptText) {
      Logger.info('aescbc2 decrypt ok');
      return ''
    }
    Logger.info("aescbc2 ", 'decryptText: ' + decryptText);

    return ''
  } catch (err) {
    Logger.info("aescbc2 ", 'err: ' + err);
    return ''
  }
}

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genIvParamsSpec() {
  let ivBlob = generateRandom(16);
  console.info('ivBlob',ivBlob)
  let ivParamsSpec: cryptoFramework.IvParamsSpec = {
    algName: "IvParamsSpec",
    iv: ivBlob
  };
  return ivParamsSpec;
}
let iv = genIvParamsSpec();
// 加密消息。
async function encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES128|CBC|PKCS7');
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, iv);
  let cipherData = await cipher.doFinal(plainText);
  return cipherData;
}
// 解密消息。
async function decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES128|CBC|PKCS7');
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, iv);
  let decryptData = await decoder.doFinal(cipherText);
  return decryptData;
}

async function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
  let symKey = await aesGenerator.convertKey(symKeyBlob);
  console.info('convertKey success');
  return symKey;
}

async function aesCBC(): Promise<string> {
  try {
    let keyData = new Uint8Array([7, 154, 52, 176, 4, 236, 150, 43, 237, 9, 145, 166, 141, 174, 224, 131]);
    let symKey = await genSymKeyByData(keyData);
    let message = "This is a test";
    let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
    let encryptText = await encryptMessagePromise(symKey, plainText);
    let decryptText = await decryptMessagePromise(symKey, encryptText);
    if (plainText.data.toString() === decryptText.data.toString()) {
      console.info('decrypt ok');
      console.info('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));
    } else {
      console.error('decrypt failed',buffer.from(encryptText.data).toString('base64'), plainText.data.toString() ,decryptText.data.toString());
    }
    return 'encryptText'
  } catch (error) {
    console.error(`AES CBC "${error}", error code: ${error.code}`);
    return 'encryptText'
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
  private codeImg = apiConfig['dev'].baseUrl+`/captcha.jpg?uuid=${this.uuid}`

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
            // const psd = await aesCBC()
            const data:FormData = {
              mobile: this.mobile,
              password: this.password,
              uuid:this.uuid,
              imageCode:this.imageCode,
            }

            // router.replaceUrl({ url: 'pages/Home' });

            const result = await doLogin(data)
            Logger.info(JSON.stringify(result.data))
            // this.resultJson = JSON.stringify(result.data)
          }
        })
    }
  }
}