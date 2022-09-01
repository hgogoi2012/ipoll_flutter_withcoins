import 'package:flutter/material.dart';

import 'package:ipoll_application/mainscreens/category_screen/category_widget.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(63, 88, 177, 1),
          elevation: 0,
          centerTitle: true,
          title: const Text('Explore by Categories ✨',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ))),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 40,
              ),
              GridView.count(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: 3,
                children:
                    List.generate(category.getCategoryData.length, (index) {
                  return ChangeNotifierProvider.value(
                    value: category.getCategoryData[index],
                    child: const CategoryWidget(),
                  );
                }),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
