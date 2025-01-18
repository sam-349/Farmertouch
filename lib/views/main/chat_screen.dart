import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/chat_model.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> chats = [
    ChatModel(
      user: "current",
      msg: "Hi",
    ),
    ChatModel(
      user: "Ramesh",
      msg: "Hello!",
    ),
    ChatModel(
      user: "current",
      msg: "I want 2kg rice",
    ),
    ChatModel(
      user: "Ramesh",
      msg: "Ok",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 30,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: ColorsUtil.onPrimary,
            )),
        backgroundColor: ColorsUtil.primaryColor,
        title: ListTile(
          // tileColor: Colors.red,
          dense: true,
          leading: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(360),
              color: Colors.grey.shade300,
            ),
          ),
          title: Text(
            "Subbaya",
            style: theme.textTheme.titleMedium,
          ),
          subtitle: Row(
            children: [
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(360),
                ),
              ),
              SizedBox(width: 5),
              Text(
                "Active now",
                style: theme.textTheme.titleSmall,
              )
            ],
          ),
        ),
        actions: [
          Container(
            height: 35,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            child: Icon(Icons.phone_outlined),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                primary: true,
                shrinkWrap: true,
                itemBuilder: (context, ind) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: (chats[ind].user != "current")
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        (chats[ind].user != "current")
                            ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(360),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(width: 10),
                        SizedBox(
                          width: width / 2,
                          child: Row(
                            mainAxisAlignment: (chats[ind].user != "current")
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Container(
                                  // width: width - 100,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (chats[ind].user == "current")
                                        ? const Color.fromARGB(
                                            255, 111, 164, 113)
                                        : ColorsUtil.bgColor,
                                    borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(
                                    //   color: Color(0xFFbfbfbf),
                                    // ),
                                  ),
                                  child: Text(
                                    chats[ind].msg,
                                    style: theme.textTheme.titleSmall!.copyWith(
                                      color: (chats[ind].user == "current")
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        (chats[ind].user == "current")
                            ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(360),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 60,
              width: width,
              // margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: ColorsUtil.bgColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      GestureDetector(
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: ColorsUtil.onPrimary,
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: Center(child: Icon(Icons.add)),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: ColorsUtil.onPrimary,
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: Center(child: Icon(Icons.attach_file)),
                        ),
                      ),
                      // IconButton(onPressed: () {}, icon: Icon(Icons.attach_file)),
                    ],
                  ),
                  // IconButton(
                  //     onPressed: () {}, icon: Icon(Icons.slow_motion_video_outlined)),
                  Container(
                    height: 30,
                    width: width / 2,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type something...",
                        contentPadding: EdgeInsets.all(7),
                      ),
                    ),
                  ),
                  Icon(Icons.send),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
