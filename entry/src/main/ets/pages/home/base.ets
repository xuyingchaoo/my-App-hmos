// fit_content_test.ets
import { webview } from '@kit.ArkWeb';
import { http } from '../../utils/http';

interface icon {
  icon: string;
  url:string;
  text: string;
}
interface UserInfo{
  id?:string;
  mobile?:string;
  username?:string;
  roleNameList?:Array<string>
}

@Component
export struct BasePage {
  @State icons:icon[] = [
    { icon: 'images/setting.png',url:'pages/login/index', text: '基础资料' },
    { icon: 'images/buy.png',url:'images/list-active.png', text: '购买实施' },
  ]
  @State userInfo:UserInfo = {
    id: '',
    mobile: '',
    username: ''
  }
  getUserInfo(){
    http.get<UserInfo>("/sys/user/info").then(res=>{
      if(res.code == 0 && res.data){
        this.userInfo.id = res.data?.id
        this.userInfo.mobile =  res.data?.mobile
        this.userInfo.username = res.data?.username
        this.userInfo.roleNameList = res.data?.roleNameList
      }
    })
  }

  build() {
    Flex({direction:FlexDirection.Column}) {
      Row(){
        Row(){
          Image('images/avatar.png').width(80).height(80).borderRadius(50).margin({right:10})
        }
        Row(){
          Column() {
            Row(){
              ForEach(this.userInfo.roleNameList,(item:string,index:number)=>{
                Text(item).margin({bottom:10,right:10}).backgroundColor('#0091ff').fontColor('white').padding(2).borderRadius(5)
              })
            }

            Text(this.userInfo.mobile)
          }.alignItems(HorizontalAlign.Start)
        }
      }.width('100%').height(150).alignItems(VerticalAlign.Center).padding(20).linearGradient({
        angle: 90,
        colors: [[0xdef5e3, 0.0], [0xd9edfc, 1.0]]
      }).onAppear(()=>{
        this.getUserInfo()
      })
      Row(){
        Column(){
          ForEach(this.icons,(item:icon,index:number)=>{
            Row(){
              Image(item.icon).width(30).height(30).margin({right:10})
              Text(item.text)
            }.justifyContent(FlexAlign.Start).width('100%').height(50).border({
              width:{bottom:1},color:{bottom:'#eaebed'}
            })
          })
        }.padding(10)
      }
    }
  }
}