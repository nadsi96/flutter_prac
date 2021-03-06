import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/commons.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/news/page_news.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'tabPage/hoga/page_hoga.dart';
import 'tabPage/investor/page_investor.dart';
import 'tabPage/stock_info/page_stock_info.dart';
import 'tabPage/time/time.dart';
import 'tabPage/trade_company/page_trade_company.dart';
import 'tabPage/unit_price/page_unit_price.dart';

/// 주식 현재가
class PresentPrice extends StatelessWidget {
  final controller = Get.find<MainController>();
  final pageController = Get.find<TabPageController>();

  PresentPrice({Key? key}) : super(key: key);

  List<Widget> topBarActions() {
    return [
      Container(
          padding: const EdgeInsets.all(15),
          child: Image.asset("assets/images/bell.png")),
      Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Icon(Icons.menu, color: BLACK))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(title: '주식현재가', actions: topBarActions()),
      backgroundColor: WHITE,
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          return searchStock(controller.getSelectedStock());
                        }),
                      ),
                      Container(
                        height: 40,
                        width: 60,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: LLIGHTGRAY),
                            color: LLLIGHTGRAY),
                        child: const Text('매수',
                            style: TextStyle(
                                color: RED,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ), // 매수버튼
                      Container(
                        height: 40,
                        width: 60,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: LLIGHTGRAY),
                            color: LLLIGHTGRAY),
                        child: const Text('매도',
                            style: TextStyle(
                                color: BLUE,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ), // 매도버튼
                    ],
                  ),
                  Obx(() {
                    // 주식 정보
                    // 그래프, 현재가, 등락비율 등
                    return stockInfo(controller.getSelectedStockData());
                  }),
                ],
              ),
            ),
            tabMenu(), // 테이블에 보여줄 내용 선택할 탭메뉴
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: LLLIGHTGRAY),
                  ),
                ),
                padding: const EdgeInsets.only(top: 5),
                child: Obx(
                  () {
                    print("페이지 확인");
                    switch (controller.stockPriceTab.value) {
                      case "투자자":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return InvestorPage();
                      case "거래원":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return TradeCompany();
                      case "뉴스":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return News();
                      case "시간":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        print("시간");
                        return Time();
                      case "종목정보":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return StockInfo();
                      case "호가":
                        controller.hogaPage_tradDataUpdateFlag = true;
                        print("호가");
                        return Hoga();
                      case "단일가":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return UnitPrice();
                      default:
                        return Container(color: BLUE);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }

  /// 탭메뉴
  /// 호가,차트,투자자,거래원,뉴스,토론,일자,시간,1분선,재무,기타수급,리포트,종목정보,단일가
  Widget tabMenu() {
    final taps = List.generate(
      controller.stockPriceTabTexts.length,
      (index) => InkWell(
        onTap: () {
          controller.stockPriceTab.value = controller.stockPriceTabTexts[index];
        },
        child: Container(
          width: 80,
          alignment: Alignment.center,
          child: Obx(
            () => UnderLineButton(
              text: controller.stockPriceTabTexts[index],
              isSelected: controller.stockPriceTab.value ==
                  controller.stockPriceTabTexts[index],
              paddingV: 10,
            ),
          ),
        ),
      ),
    );
    return SizedBox(
        height: 40,
        child: Row(children: [
          Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification notification) {
                    notification.disallowGlow(); // 오버스코롤 되는 경우, 효과 없애기
                    return false;
                  },
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: taps,
                  ))),
          Builder(
            builder: (context) {
              return InkWell(
                  onTap: () {
                    /// 탭메뉴 펼치기
                    // showAlignedDialog(
                    //     followerAnchor: Alignment.topRight, // 자신 시작점
                    //     targetAnchor: Alignment.topRight, // 시작 기준점
                    //     context: context,
                    //     builder: (context) {
                    //       return Container(
                    //         padding: const EdgeInsets.all(20),
                    //         decoration: const BoxDecoration(color: WHITE, border: Border(bottom: BorderSide(color: GRAY))),
                    //         child: GridView.count(
                    //           crossAxisCount: 3,
                    //           mainAxisSpacing: 10,
                    //           crossAxisSpacing: 10,
                    //           children: List.generate(),
                    //         )
                    //       );
                    //     });
                  },
                  child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: const Center(
                          child: Icon(
                        Icons.keyboard_arrow_down,
                        color: BLACK,
                      ))));
            },
          )
        ]));
  }
}
