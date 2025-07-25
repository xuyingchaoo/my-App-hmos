import { webview } from '@kit.ArkWeb';
import { TabBarBottom } from '../components/tabBar'
import { homeIndex } from './home/index'
import { ListPage } from './home/list'
import { BasePage } from './home/base'
import { StatisticsPage } from './home/statistics'
// Tab配置数据
interface tab {
  icon: string;
  selectIcon:string;
  text: string;
}
@Entry
@Component
struct Home {
  pageStack: NavPathStack = new NavPathStack()
  @State message: string = 'Hello World';
  @State pageIndex: number = 0
  controller: webview.WebviewController = new webview.WebviewController();
  handleTabChange(index:number){
    this.pageIndex = index
    console.info(JSON.stringify(index))
  }
  returnTabStatus(index:number){
    return this.pageIndex === index ? ToolbarItemStatus.ACTIVE : ToolbarItemStatus.NORMAL
  }
  @State tabs:tab[] = [
    { icon: 'images/home.png',selectIcon:'images/home-active.png', text: '首页' },
    { icon: 'images/list.png',selectIcon:'images/list-active.png', text: '列表' },
    { icon: 'images/statistics.png',selectIcon:'images/statistics-active.png', text: '统计' },
    { icon: 'images/base.png',selectIcon:'images/base-active.png', text: '基础' },
  ]

  @Builder
  TabBarBuilder(index: number, selectedImage: string, unselectedImage: string, tabBarName: string) {
    Column() {
      Image(this.pageIndex === index ? selectedImage : unselectedImage)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })

      Text(tabBarName)
        .fontSize(10)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor(this.pageIndex === index ? '#0091FF' : '#8C8C8C')
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
    .alignItems(HorizontalAlign.Center)
    .id(`tabBar${index}`)
  }
  handleRouter(){

  }
  @Builder
  currentPage() {
    if (this.pageIndex === 0) {
      homeIndex(
        {
          toPage: (name:string): void => {
            this.pageStack.pushPathByName(name,null)
          }
        }
      )
    } else if (this.pageIndex === 1) {
      ListPage({
        toPage: (name:string): void => {
          this.pageStack.pushPathByName(name,null)
        }
      })
    } else if (this.pageIndex === 2) {
      StatisticsPage()
    } else if (this.pageIndex === 3) {
      BasePage()
    }
  }
  build() {
    Navigation(this.pageStack) {
      Column() {
        Tabs({ barPosition: BarPosition.End }) {
          ForEach(this.tabs,(item:tab,index:number)=>{
            TabContent() {
              this.currentPage()
            }
            .tabBar(this.TabBarBuilder(index,item.selectIcon,item.icon,item.text))
          })
        }
        .animationDuration(0)
        .scrollable(false)
        .onChange((index: number) => {
          this.pageIndex = index
        })
      }.height('100%').width('100%')
    }.hideTitleBar(true)
  }
}