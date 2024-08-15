import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:six_pos/util/dimensions.dart';

class AccountShimmerWidget extends StatelessWidget {
  const AccountShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: double.infinity,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: double.infinity,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 100.0,
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ],
                    ),),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0)),

                ],
              ),
            ),
            itemCount: 12,
          )),
    );
  }
}
