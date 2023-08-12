import 'package:flutter/material.dart';

class DialogNewChat extends StatelessWidget {
  const DialogNewChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 200,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'New chat',
                ),
              ),
              SizedBox(
                width: 320,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Confirm',
                    style: TextStyle(
                        color: Colors.white
                    ),),
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
