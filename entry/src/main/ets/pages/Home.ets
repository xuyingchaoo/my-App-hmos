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
  }
}