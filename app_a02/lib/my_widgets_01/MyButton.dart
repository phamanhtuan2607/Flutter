import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  const MyButton({super.key});

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
            SizedBox(height: 50,),
            // ElevatedButton là một button nổi voiws hiệu ứng đổ bóng
            // thường đươc sử dụng cho các hành động chính trongứng dụng
            ElevatedButton(
                onPressed: (){print("ElevatedButton");}, 
                child: Text("ElevatedButton", style: TextStyle(fontSize: 24),)),

              SizedBox(height: 20,),

            //TextButton là môt button phẳng
            // không có đổ bóng
            // thường dùng cho các hành động thứ yếu
            // hoặc các thành phần  như Dialog, card
            TextButton(
                onPressed: (){print("TextButton");},
                child: Text("TextButton", style: TextStyle(fontSize: 24),)),

            SizedBox(height: 20,),

            // OutlinedButton là button có viền bao quanh
            // không có màu nền,
            // phù hợp cho thay thế
            OutlinedButton(
                onPressed: (){print("TextButton");},
                child: Text("TextButton", style: TextStyle(fontSize: 24),)),


            SizedBox(height: 20,),

            // iconButton là button chỉ gồm icon
            // không có văn bản
            // thường dùng trong Appbar, toolBar

            IconButton(
                onPressed: (){print("IconButton");},
                icon: Icon(Icons.favorite)),

            SizedBox(height: 20,),

            // FloatingActionButton là button hình tròn,
            // nổi trên giao diện
            // thường dùng cho hành động chính của màn hình
            FloatingActionButton(
              onPressed: (){print("FloatingActionButton");},
              child: Icon(Icons.add),
            )
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
