import 'package:flutter/material.dart';

/// A custom widget to display information about a GitHub repository.
class UserDetailsTile extends StatelessWidget {
  final String repoName;
  final String repodescription;
  final int stars;
  final String userName;
  final String userAvatar;

  /// Creates a [UserTile] widget.
  ///
  /// The widget takes the following parameters:
  ///
  /// - [repoName]: The name of the GitHub repository.
  /// - [repodescription]: The description of the GitHub repository.
  /// - [stars]: The number of stars the GitHub repository has.
  /// - [userName]: The username of the owner of the GitHub repository.
  /// - [userAvatar]: The URL of the user's avatar image.
  const UserDetailsTile(
      {super.key,
      required this.repoName,
      required this.repodescription,
      required this.stars,
      required this.userName,
      required this.userAvatar});

  @override
  Widget build(BuildContext context) {
    // The widget's UI code here...
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 23, 48),
              Color.fromARGB(255, 0, 12, 48),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color.fromARGB(255, 1, 61, 213),
            width: 3.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userAvatar),
                    radius: 50,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        repoName,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 25,
                          color: Colors.yellow,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          " $stars Stars",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    repodescription,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
