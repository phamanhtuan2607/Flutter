import "package:flutter/material.dart";

class MyButton_3 extends StatelessWidget {
  const MyButton_3({super.key});

  @override
  Widget build(BuildContext context) {
    // Trả về Scaffold - widget cung cấp ố cục Material Design
    // Màn hình
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        // Tiêu đề
        title: Text("App 02"),
        // Màu nền
        backgroundColor: Colors.yellow,
        // Độ bóng của appbar
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            },
            icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              print("b3");
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),

            // Khóa nút nhấn
            ElevatedButton(
              onPressed: null, // Khóa lại
              child: Text("ElevatedButton", style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                // màu nền
                backgroundColor: Colors.green,
                // màu của các nội dung ben trong
                foregroundColor: Colors.white,
                // dạng hình của button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                // padding
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                // elevated
                elevation: 15,
              ),
            ),
            // Chọn thêm ít nhất 1 dạng nút nhấn khác để thiết kế
            SizedBox(height: 50),
            OutlinedButton(
              onPressed: () {
                print("OutlinedButton Pressed");
              },
              child: Text("OutlinedButton", style: TextStyle(fontSize: 24)),
              style: OutlinedButton.styleFrom(
                // màu nền
                backgroundColor: Colors.blueGrey,
                // màu của các nội dung ben trong
                foregroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: (){print("Pressed");},
              onLongPress: (){print("Long Pressed");},// Khóa lại
              child: Text("ElevatedButton", style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                // màu nền
                backgroundColor: Colors.green,
                // màu của các nội dung ben trong
                foregroundColor: Colors.white,
                // dạng hình của button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                // padding
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                // elevated
                elevation: 15,
              ),
            ),
            // Chọn thêm ít nhất 1 dạng nút nhấn khác để thiết kế
            SizedBox(height: 50),
            // InkWell
            // InkWell không phải là button
            // nhưng nó cho phép tạo hiệu ứng gợn sóng
            // khi nhấn vào bất kỳ widget nào
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                print("InkWell được nhấn!");
              },
              onDoubleTap: (){print("InkWell được nhấn 2 lần liên tiếp!");},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Text("Button tùy chỉnh với InkWell"),
              ),
            ),
            
            SizedBox(height: 50,),
            TextButton.icon(
                onPressed: (){},
                icon: Icon(Icons.favorite),
                label: Text("Like"))
            
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}
