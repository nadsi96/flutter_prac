import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/empty_page.dart';
import 'package:flutter_prac_jongmock/interest_page/getx_bottom_button_list.dart';
import 'package:flutter_prac_jongmock/interest_page/getx_page_interest.dart';
import 'package:flutter_prac_jongmock/interest_page/getx_stock_list_view.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/present_price/present_price.dart';
import 'package:flutter_prac_jongmock/register_page_with_getx/register_page.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_prac_jongmock/register_page/register_page.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:get/get.dart';

import '../divider.dart';

// import '../interest_page/bottom_button_list.dart';
import '../interest_page/bottom_text_bar.dart';
// import '../interest_page/stock_list_view.dart';
import '../interest_page/top_bar.dart';
import '../interest_page/top_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mainController = Get.put(MainController());

    // 상태바 디자인
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: WHITE// 원하는 색
    ));

    return GetMaterialApp(
      title: 'Flutter Demo',
      home: MainPage(),
      getPages: [
        GetPage(name: "/register", page: () => RegisterPage())
      ],
    );
    /*
    // Stateful
    return MaterialApp(
      title: 'Flutter Demo',
      home: JongmockPage(),
      // initialRoute: 'JongmockPage',
      // routes: {
      //   'JongmockPage' : (context) => JongmockPage(),
      //   'registerPage' : (context) => RegisterPage()
      // },
    );
    */
  }
}

/// 메인페이지
/// 프래그먼트페이지
/// 하단 텍스트바, 버튼리스트
class MainPage extends StatelessWidget {
  final controller = Get.find<MainController>();

  var bottomButtons;

  MainPage() {
    bottomButtons = BottomButtons();

    controller.updateStocks(myStocks);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
              Expanded(child: GetX<MainController>(builder: (_) {
                switch (controller.title.value) {
                  case '관심종목':
                    return JongmockPage();
                  case '주식현재가':
                    return PresentPrice();
                  default:
                    return EmptyPage();
                }
              })),
              BottomTextBar(),
              // 하단 버튼리스트 위 텍스트
              bottomButtons
              // 하단 버튼리스트
            ])));
  }
}
/*

/// 관심종목 페이지
class JongmockPage extends StatefulWidget {
  @override
  _JongmockPage createState() {
    return _JongmockPage();
  }
}

class _JongmockPage extends State<JongmockPage> {
  var title = "관심종목";

  var topButtons;
  late final StockListView stockListView;

  final controller = Get.find<MainController>();

  _JongmockPage() {
    this.topButtons = TopButtons(updateStockList, getStocks);
    this.stockListView = StockListView(myStocks);
    controller.updateStocks(myStocks);
  }

  void updateStockList(List<String> stocks) {
    print("updateStockList");
    print(stocks.toString());
    print(stockListView.toString());

    stockListView.stockListView_.updateStocks(stocks);
    print("ran?");
  }

  List<String> getStocks() {
    return this.stockListView.getStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: WHITE,
          leading: (controller.pageStack.length > 1)
              ? InkWell(
              onTap: () {
                controller.backToPage();
              },
              child: TitleBarBackButton())
              : null,
          title: Text(controller.title.value,
              style: const TextStyle(color: BLACK, fontSize: 18)),
          shadowColor: TRANSPARENT,
        ),
        body: SafeArea(
            child: Column(children: [
              topButtons, // 상단 버튼(최근조회종목, 현재가, 등록, 오늘뉴스, 그래프 버튼
              DivideLine(Colors.black45),
              Expanded(child: stockListView), // 주식 목록
            ])));
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }
}
*/
