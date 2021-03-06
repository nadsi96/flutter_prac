
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/data/news_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'news_detail.dart';

/// 주식현재가 - 뉴스
class News extends StatelessWidget {
  News({Key? key}) : super(key: key) {
    controller.newsPage_topBtn.value = controller.newsPage_topBtns.first;

    pd.setNewsData(controller.getSelectedStock());
  }

  final controller = Get.find<MainController>();
  final scrollController = ScrollController();
  final pd = ProduceNewsData();

  /// ["전체", "뉴스", "공시"]
  Widget topBtns() {
    return SizedBox(
      height: 40,
      child: Row(
        children: List.generate(
          controller.newsPage_topBtns.length,
          (index) {
            final text = controller.newsPage_topBtns[index];

            return Expanded(
              child: InkWell(
                onTap: () {
                  controller.newsPage_topBtnClick(text);
                },
                child: GetX<MainController>(
                  builder: (_) {
                    return BlueGrayButton(
                        text: text,
                        isSelected: controller.newsPage_topBtn.value == text);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget newsList() {
    return GetX<MainController>(
      builder: (_) {
        // pd.setNewsData(controller.getSelectedStock());

        // 현재 선택된 버튼 확인
        // type - 전체 = -1
        //        뉴스 =  0
        //        공시 =  1
        final type = (controller.newsPage_topBtn.value == "전체")
            ? -1
            : (controller.newsPage_topBtn.value == "뉴스")
                ? 0
                : 1;

        // 해당하는 데이터 가져옴
        var listItem = pd.getNewsData(type);

        // 끌올
        if (scrollController.hasClients) {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 1),
              curve: Curves.elasticOut);
        }

        return ListView(
          controller: scrollController,
          children: List.generate(
            listItem.length,
            (idx) => _newsListTile(
              listItem[idx],
            ),
          ),
        );
      },
    );
  }

  /// Col - 뉴스제목
  ///  ㄴ Row (날짜, 시간, 언론사)
  Widget _newsListTile(NewsData nd) {
    const titleFont = 18.0;
    const smallFont = 12.0;

    return InkWell(
      onTap: () {
        Get.dialog(
          NewsDetail(newsData: nd),
          transitionDuration: const Duration(microseconds: 1),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: WHITE,
          border: Border(
            bottom: BorderSide(color: LLIGHTGRAY),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nd.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: BLACK, fontSize: titleFont),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    "${formatIntToStringLen2(nd.dt!.year % 100)}/${formatIntToStringLen2(nd.dt!.month)}/${formatIntToStringLen2(nd.dt!.day)}",
                    style: const TextStyle(color: BLUE, fontSize: smallFont),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    "${formatIntToStringLen2(nd.dt!.hour)}:${formatIntToStringLen2(nd.dt!.minute)}",
                    style: const TextStyle(color: GRAY, fontSize: smallFont),
                  ),
                ),
                Text(
                  nd.company,
                  style: const TextStyle(color: GRAY, fontSize: smallFont),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          color: WHITE,
          child: topBtns(),
        ),
        Expanded(child: newsList()),
      ],
    );
  }
}

