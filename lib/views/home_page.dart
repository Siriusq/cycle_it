import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/views/components/item_card.dart';
import 'package:cycle_it/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: GetPlatform.isDesktop ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // 设置按钮
                    IconButton(
                      //style: IconButton.styleFrom(padding: EdgeInsets.only(left: 0, right: 10)),
                      onPressed: () {
                        Get.to(() => SettingsPage());
                      },
                      icon: Icon(Icons.settings),
                    ),
                    // 搜索框
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: kBgLightColor,
                          filled: true,
                          hoverColor: kBgLightColor,
                          suffixIcon: Padding(padding: const EdgeInsets.all(15), child: Icon(Icons.search)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // 排序按钮
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: kTitleTextColor,
                        iconSize: 28,
                        padding: EdgeInsets.only(left: 6, right: 10),
                        //splashFactory: NoSplash.splashFactory,
                        //overlayColor: Colors.transparent,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.expand_more),
                      label: Text('Sorted by Name', style: TextStyle(fontWeight: FontWeight.w500)),
                      iconAlignment: IconAlignment.start,
                    ),
                    Spacer(),
                    // 筛选按钮
                    IconButton(onPressed: () {}, icon: Icon(Icons.filter_list)),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: itemExamples.length,
                  itemBuilder:
                      (context, index) => ItemCard(item: itemExamples[index], isActive: index == 0, press: () {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
