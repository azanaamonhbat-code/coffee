import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/coffee.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  List<Coffee> get coffees => [
        Coffee(
          name: "Americano",
          description: "Strong black coffee",
          details:
              "Американо кофе нь эспрессо дээр халуун ус нэмсэн энгийн боловч хүчтэй амттай ундаа юм. "
              "Гашуун амт давамгайлсан ч цэвэр кофены үнэрийг тод мэдрүүлдэг. "
              "Өглөөний сэргээш болон ажлын эрч хүч авахад тохиромжтой.",
          price: 5.0,
          image:
              "https://images.unsplash.com/photo-1511920170033-f8396924c348",
        ),
        Coffee(
          name: "Latte",
          description: "Milk coffee",
          details:
              "Латте нь сүү ихтэй тул зөөлөн, торгомсог амттай байдаг. "
              "Кофены гашуун амт маш бага тул анхлан ууж байгаа хүмүүст тохиромжтой. "
              "Өдөр тутмын тайван уух ундаа бөгөөд маш алдартай сонголт юм.",
          price: 6.5,
          image:
              "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
        ),
        Coffee(
          name: "Cappuccino",
          description: "Foamy coffee",
          details:
              "Капучино нь эспрессо, сүү, өтгөн хөөс гурвын төгс хослол юм. "
              "Дээрх хөөс нь зөөлөн мэдрэмж өгдөг бөгөөд амт нь тэнцвэртэй байдаг. "
              "Кофены жинхэнэ үнэрийг мэдрүүлэх сонгодог ундаа юм.",
          price: 6.0,
          image:
              "https://images.unsplash.com/photo-1521302080334-4bebac2763a6",
        ),
        Coffee(
          name: "Mocha",
          description: "Chocolate coffee",
          details:
              "Мокка нь шоколад болон кофены гайхалтай хослол юм. "
              "Амт нь чихэрлэг, зөөлөн бөгөөд десерт шиг мэдрэмж төрүүлдэг. "
              "Чихэрлэг дуртай хүмүүст хамгийн тохиромжтой сонголт юм.",
          price: 6.8,
          image:
              "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
        ),
        Coffee(
          name: "Espresso",
          description: "Pure strong shot",
          details:
              "Эспрессо нь маш хүчтэй жижиг хэмжээтэй кофе юм. "
              "Кофены цэвэр essence-ийг шууд мэдрүүлдэг. "
              "Эрч хүч авах, нойр сэргээх хамгийн хүчтэй сонголт.",
          price: 4.0,
          image:
              "https://images.unsplash.com/photo-1510707577719-ae7c14805e3a",
        ),
        Coffee(
          name: "Macchiato",
          description: "Espresso with milk foam",
          details:
              "Макиато нь эспрессо дээр бага зэрэг сүүний хөөс нэмсэн кофе юм. "
              "Гашуун ба зөөлөн амтны төгс тэнцвэрийг бий болгодог. "
              "Хүчтэй кофе уудаг хүмүүст хамгийн тохиромжтой.",
          price: 5.5,
          image:
              "https://images.unsplash.com/photo-1461023058943-07fcbe16d735",
        ),
      ];

  void openDetail(BuildContext context, Coffee coffee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoffeeDetailPage(coffee: coffee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: const Text(
          "☕ Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          // PROFILE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3E2723), Color(0xFF6D4C41)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF3E2723),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Nomuk User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "☕ Coffee Lover",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 👇 NEW TITLE
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "☕ Миний дуртай кофенууд",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ),
          ),

          // LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: coffees.length,
              itemBuilder: (context, index) {
                final coffee = coffees[index];

                return GestureDetector(
                  onTap: () => openDetail(context, coffee),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          coffee.image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        coffee.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      subtitle: Text(coffee.description),

                      // 💰 MNT PRICE
                      trailing: Text(
                        "${coffee.price.toStringAsFixed(1)} ₮",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//
// DETAIL PAGE
//
class CoffeeDetailPage extends StatelessWidget {
  final Coffee coffee;

  const CoffeeDetailPage({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: Text(coffee.name),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              coffee.image,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    coffee.details,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 💰 MNT PRICE
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D4C41),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Үнэ: ${coffee.price.toStringAsFixed(1)} ₮",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}