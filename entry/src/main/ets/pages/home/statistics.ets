@Entry
@Component
export struct StatisticsPage {
  build() {
    Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Start}){
      Column() {
        Text('销售统计').width('100%').textAlign(TextAlign.Start).fontSize(18).fontWeight(500).padding(20)
        GridRow({
          columns: 4,
          gutter: { x: 5,y: 0 },
          breakpoints: {
            value: ["500vp", "500vp"],
            reference: BreakpointsReference.WindowSize
          },
          direction: GridRowDirection.Row
        }){
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
        }.height(100)
      }.height(180).border({
        width:{bottom:10},color:{bottom:'#eaebed'}
      })
      Column() {
        Text('采购统计').width('100%').textAlign(TextAlign.Start).fontSize(18).fontWeight(500).padding(20)
        GridRow({
          columns: 4,
          gutter: { x: 5,y: 0 },
          breakpoints: {
            value: ["500vp", "500vp"],
            reference: BreakpointsReference.WindowSize
          },
          direction: GridRowDirection.Row
        }){
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
          GridCol() {
            Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
              Image('images/icon01.png').width(50).height(50)
              Text('销售汇总').width('100%').margin({top:10}).fontWeight('500').textAlign(TextAlign.Center).fontSize(14)
            }.width('100%').height(100)
          }.width('100%')
        }.height(100)
      }.height(180).border({
        width:{bottom:10},color:{bottom:'#eaebed'}
      })
    }
  }
}