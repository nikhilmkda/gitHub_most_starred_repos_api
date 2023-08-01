import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String repoName;
  final String repodescription;
  final int stars;
  final String userName;
  final String userAvatar;
  const UserTile(
      {super.key,
      required this.repoName,
      required this.repodescription,
      required this.stars,
      required this.userName,
      required this.userAvatar});

  @override
  Widget build(BuildContext context) {
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
              offset:
                  const Offset(0, 2), 
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xFF66A9F2),
              Color(0xFF5367A4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                        offset:const Offset(
                            0, 2), 
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userAvatar),
                    radius: 50,
                  ),
                ),
             const   SizedBox(
                  width: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 200,
                      child: Text(
                        repoName,
                        style:const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                 const   SizedBox(
                      height: 5,
                    ),
                    Text(
                      userName,
                      style:const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                const    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                  const      Icon(
                          Icons.star,
                          size: 25,
                          color: Colors.yellow,
                        ),
                     const   SizedBox(
                          height: 5,
                        ),
                        Text(
                          " $stars Stars",
                          style:const TextStyle(
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
       const     SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                boxShadow:const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    repodescription,
                    style:const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
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
