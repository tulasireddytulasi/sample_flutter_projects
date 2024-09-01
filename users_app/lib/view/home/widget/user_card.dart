import 'package:flutter/material.dart';
import 'package:users_app/core/utils/custom_colors.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.picUrl,
    required this.name,
    required this.dob,
    required this.location,
    required this.info,
    required this.gender,
  });

  final String picUrl;
  final String name;
  final String dob;
  final String gender;
  final String location;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.pickledBlueWood,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: picUrl.isEmpty
                    ? Container(
                        width: 100,
                        height: 100,
                        color: CustomColors.white,
                      )
                    : Hero(
                        tag: name,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            picUrl,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        color: CustomColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.white,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(text: "$dob, "),
                          TextSpan(text: gender),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CustomColors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(color: CustomColors.grey, height: 1, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 5,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.white,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  const TextSpan(text: "Biography: "),
                  TextSpan(text: info),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
