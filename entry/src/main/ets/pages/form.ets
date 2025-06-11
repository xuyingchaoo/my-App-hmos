
@Entry
@Component
struct Home {
  @State message: string = 'Hello World';
  build() {
    Column({ space: 20 }) {
      Text('space: 20').fontSize(15).fontColor(Color.Gray).width('90%')
      Row().width('90%').height(50).backgroundColor(0xF5DEB3)
      Row().width('90%').height(50).backgroundColor(0xD2B48C)
    }.width('100%')
    .height('100%')
    .width('100%')



  }
}