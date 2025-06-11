import { homeIndex } from '../pages/home/index'
import { ListPage } from '../pages/home/list'
import { BasePage } from '../pages/home/base'

// Tab配置数据
interface tab {
  icon: string;
  selectIcon:string;
  text: string;
}

@Component
struct TabBarBottom {
  @State tabsIndex: number = 0

  @State tabs:tab[] = [
    { icon: 'images/home.png',selectIcon:'images/home-active.png', text: '首页' },
    { icon: 'images/list.png',selectIcon:'images/list-active.png', text: '列表' },
    { icon: 'images/statistics.png',selectIcon:'images/statistics-active.png', text: '统计' },
    { icon: 'images/base.png',selectIcon:'images/base-active.png', text: '基础' },
  ]
  private pages = [homeIndex];
  build() {
    Column() {  // 垂直布局容器
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
        this.tabsIndex = index
      })
    }
  }
  @Builder
  currentPage() {
    if (this.tabsIndex === 0) {
      homeIndex()
    } else if (this.tabsIndex === 1) {
      ListPage()
    } else if (this.tabsIndex === 2) {
      // ProfilePage
    } else if (this.tabsIndex === 3) {
      BasePage()
    }
  }
  @Builder TabBarBuilder(index: number, selectedImage: string, unselectedImage: string, tabBarName: string) {
    Column() {
      Image(this.tabsIndex === index ? selectedImage : unselectedImage)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })

      Text(tabBarName)
        .fontSize(10)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor(this.tabsIndex === index ? '#0091FF' : '#8C8C8C')
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
    .alignItems(HorizontalAlign.Center)
    .id(`tabBar${index}`)
  }
}
export {TabBarBottom};