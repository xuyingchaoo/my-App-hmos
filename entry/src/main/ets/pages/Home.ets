import { webview } from '@kit.ArkWeb';
import { TabBarBottom } from '../components/tabBar'

@Entry
@Component
struct Home {
  @State message: string = 'Hello World';
  controller: webview.WebviewController = new webview.WebviewController();
  build() {
    Column(){
      TabBarBottom()
    }
    .height('100%')
    .width('100%')

    // RelativeContainer() {
    //   Text(this.message)
    //     .id('HelloWorld')
    //     .fontSize($r('app.float.page_text_font_size'))
    //     .fontWeight(FontWeight.Bold)
    //     .alignRules({
    //       center: { anchor: '__container__', align: VerticalAlign.Center },
    //       middle: { anchor: '__container__', align: HorizontalAlign.Center }
    //     })
    //     .onClick(() => {
    //       this.message = 'Welcome';
    //     })
    // }

  }
}