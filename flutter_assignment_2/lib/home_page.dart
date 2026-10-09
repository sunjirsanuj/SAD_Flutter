import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade900),
              currentAccountPicture: Icon(
                Icons.person_2_outlined,
                color: Colors.white,
              ),
              accountName: Text("Sunjir Islam"),
              accountEmail: Text("sunjirislam23@gmail.com"),
            ),

            ListTile(
              trailing: Icon(Icons.home),
              hoverColor: Colors.blue.shade50,
              title: Text("Homepage"),
              onTap: () {},
            ),
            Divider(height: 1, thickness: 0.8),
            const SizedBox(height: 10),

            ListTile(
              trailing: Icon(Icons.call),
              hoverColor: Colors.blue.shade50,
              title: Text("Contact Me"),
              onTap: () {},
            ),
            Divider(height: 1, thickness: 0.8),
            const SizedBox(height: 10),

            ListTile(
              trailing: Icon(Icons.settings),
              hoverColor: Colors.blue.shade50,
              title: Text("Settings"),
              onTap: () {},
            ),
            Divider(height: 1, thickness: 0.8),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        tooltip: "Cart",
        child: Icon(Icons.shopping_bag),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Text Button",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Elevated Button",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            OutlinedButton(
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Outlined Button",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            IconButton(
              padding: EdgeInsets.all(20),
              onPressed: () {},
              icon: Icon(Icons.home, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
