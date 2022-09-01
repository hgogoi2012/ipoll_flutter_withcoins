import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ipoll_application/mainscreens/category_screen/inner_category_screen.dart';
import 'package:ipoll_application/models/category_model.dart';
import 'package:provider/provider.dart';

import 'category_arg.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryModel = Provider.of<CategoryModel>(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          InnerCategoryScreen.routeName,
          (Route<dynamic> route) => false,
          arguments: CategoryArguments(
              categoryname: categoryModel.name,
              coverImage: categoryModel.coverimage!),
        );
        // Navigator.pushNamed(
        //   context,
        //   InnerCategoryScreen.routeName,
        //   arguments: categoryModel.name,
        // );
      },
      child: Column(children: [
        ClipOval(
            child: SizedBox.fromSize(
          size: const Size.fromRadius(40),
          child: CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: categoryModel.image ??
                  'https://firebasestorage.googleapis.com/v0/b/groceryapp-50684.appspot.com/o/crypto.png?alt=media&token=c5cfb152-44a1-40b4-95e4-1ad4d93a773e',
              fit: BoxFit.cover,
              placeholder: (context, url) => const SpinKitFadingCube(
                    color: Colors.black,
                    size: 10,
                  )),
        )),
        const SizedBox(
          height: 8,
        ),
        Text(categoryModel.name,
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 16,
            ))
      ]),
    );
  }
}
