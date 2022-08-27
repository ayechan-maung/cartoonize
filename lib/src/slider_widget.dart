import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SliderWidget extends HookWidget {
  SliderWidget({Key? key, this.imgList}) : super(key: key);

  final CarouselController _controller = CarouselController();

  final List<Widget>? imgList;

  @override
  Widget build(BuildContext context) {
    var current = useState(0);
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
                aspectRatio: 9 / 16,
                autoPlay: true,
                initialPage: 0,
                height: 400,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                viewportFraction: .65,
                autoPlayAnimationDuration: Duration(milliseconds: 1500),
                onPageChanged: (i, reason) {
                  current.value = i;
                }),
            items: imgList,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList!.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                        .withOpacity(current.value == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
